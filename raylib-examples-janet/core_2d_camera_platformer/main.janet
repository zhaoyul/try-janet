(import jaylib :as jay)
(import jaylib/math :as jmath)
(import string)

(def screen-width 800)
(def screen-height 450)

(def G 400)
(def player-jump-spd 350.0)
(def player-hor-spd 200.0)

(defstruct player-data
  :position
  :speed
  :can-jump)

(defstruct env-item
  :rect
  :blocking
  :color)

(defn update-player [player delta env-items]
  (when (jay/is-key-down :left) (set ((player :position) :x) (- ((player :position) :x) (* player-hor-spd delta))))
  (when (jay/is-key-down :right) (set ((player :position) :x) (+ ((player :position) :x) (* player-hor-spd delta))))
  (when (and (jay/is-key-down :space) (player :can-jump))
    (set (player :speed) player-jump-spd)
    (set (player :can-jump) false))

  (var hit-obstacle false)
  (loop [item :in env-items]
    (def p-pos (player :position))
    (def p-rect @{:x (p-pos :x) :y (p-pos :y) :width 20 :height 40})
    (when (and (item :blocking)
               (jay/check-collision-recs p-rect (item :rect)))
      (set hit-obstacle true)
      (set (player :speed) 0.0)
      (set ((player :position) :y) (- ((item :rect) :y) ((item :rect) :height)))))

  (unless hit-obstacle
    (update (player :position) :y (fn [y] (+ y (* (player :speed) delta))))
    (update (player :speed) |(- $ (* G delta)))
    (set (player :can-jump) false))

  player)

(defn main [& args]
  (jay/init-window screen-width screen-height "raylib [core] example - 2d camera platformer")

  (var player (player-data
                :position @{:x 400 :y 280}
                :speed 0
                :can-jump false))

  (def env-items
    (array
      (env-item :rect @{:x 0 :y 0 :width 1000 :height 400} :blocking false :color :light-gray)
      (env-item :rect @{:x 0 :y 400 :width 1000 :height 200} :blocking true :color :gray)
      (env-item :rect @{:x 300 :y 200 :width 400 :height 10} :blocking true :color :gray)
      (env-item :rect @{:x 250 :y 300 :width 100 :height 10} :blocking true :color :gray)
      (env-item :rect @{:x 650 :y 300 :width 100 :height 10} :blocking true :color :gray)))

  (var camera
       (jay/camera-2d
         :target (player :position)
         :offset @{:x (/ screen-width 2.0) :y (/ screen-height 2.0)}
         :rotation 0.0
         :zoom 1.0))

  (jay/set-target-fps 60)

  (while (not (jay/window-should-close))
    # Update
    (def delta (jay/get-frame-time))
    (set player (update-player player delta env-items))

    (update (camera :zoom) |(+ $ (* (jay/get-mouse-wheel-move) 0.05)))
    (when (> (camera :zoom) 3.0) (set (camera :zoom) 3.0))
    (when (< (camera :zoom) 0.25) (set (camera :zoom) 0.25))

    (when (jay/is-key-pressed :r)
      (set (camera :zoom) 1.0)
      (set (player :position) @{:x 400 :y 280}))

    (set (camera :target) (player :position))

    # Draw
    (jay/begin-drawing)
    (jay/clear-background :light-gray)

    (jay/with-mode-2d camera
      (loop [item :in env-items]
        (jay/draw-rectangle-rec (item :rect) (item :color)))

      (def player-rect @{:x ((player :position) :x) :y ((player :position) :y) :width 20 :height 40})
      (jay/draw-rectangle-rec player-rect :red))

    (jay/draw-text "Controls:" 20 20 10 :black)
    (jay/draw-text "- Right/Left to move" 40 40 10 :dark-gray)
    (jay/draw-text "- Space to jump" 40 60 10 :dark-gray)
    (jay/draw-text "- Mouse Wheel to Zoom in/out" 40 80 10 :dark-gray)
    (jay/draw-text "- R to reset Zoom and Position" 40 100 10 :dark-gray)

    (jay/end-drawing))

  (jay/close-window))
