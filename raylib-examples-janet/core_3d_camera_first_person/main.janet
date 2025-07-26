(import jaylib :as jay)

(def screen-width 800)
(def screen-height 450)

(def camera-pro-speed 0.1)
(def camera-pro-mouse-move 0.003)
(def camera-pro-distance 50.0)

(defstruct camera-data
  :camera
  :angle
  :direction)

(defn update-camera-pro [camera-data]
  (def camera (camera-data :camera))
  (def angle (camera-data :angle))
  (def direction (camera-data :direction))

  (set (angle :x) (+ (angle :x) (* (jay/get-mouse-delta :x) camera-pro-mouse-move)))
  (set (angle :y) (- (angle :y) (* (jay/get-mouse-delta :y) camera-pro-mouse-move)))

  (when (> (angle :y) (* 1.57 (jay/pi))) (set (angle :y) (* 1.57 (jay/pi))))
  (when (< (angle :y) (* -1.57 (jay/pi))) (set (angle :y) (* -1.57 (jay/pi))))

  (set (direction :x) (* (jay/cos (angle :y)) (jay/sin (angle :x))))
  (set (direction :y) (jay/sin (angle :y)))
  (set (direction :z) (* (jay/cos (angle :y)) (jay/cos (angle :x))))

  (when (jay/is-key-down :w)
    (update (camera :position) :x (fn [x] (+ x (* (direction :x) camera-pro-speed))))
    (update (camera :position) :y (fn [y] (+ y (* (direction :y) camera-pro-speed))))
    (update (camera :position) :z (fn [z] (+ z (* (direction :z) camera-pro-speed)))))
  (when (jay/is-key-down :s)
    (update (camera :position) :x (fn [x] (- x (* (direction :x) camera-pro-speed))))
    (update (camera :position) :y (fn [y] (- y (* (direction :y) camera-pro-speed))))
    (update (camera :position) :z (fn [z] (- z (* (direction :z) camera-pro-speed)))))

  (set ((camera :target) :x) (+ ((camera :position) :x) (* (direction :x) camera-pro-distance)))
  (set ((camera :target) :y) (+ ((camera :position) :y) (* (direction :y) camera-pro-distance)))
  (set ((camera :target) :z) (+ ((camera :position) :z) (* (direction :z) camera-pro-distance)))

  (camera-data :camera camera :angle angle :direction direction))

(defn main [& args]
  (jay/init-window screen-width screen-height "raylib [core] example - 3d camera first person")

  (var camera-data
       (camera-data
         :camera (jay/camera-3d
                   :position @{:x 4.0 :y 2.0 :z 4.0}
                   :target @{:x 0.0 :y 1.8 :z 0.0}
                   :up @{:x 0.0 :y 1.0 :z 0.0}
                   :fovy 60.0
                   :projection :perspective)
         :angle @{:x 0.0 :y 0.0}
         :direction @{:x 0.0 :y 0.0 :z 0.0}))

  (jay/disable-cursor)
  (jay/set-target-fps 60)

  (while (not (jay/window-should-close))
    # Update
    (set camera-data (update-camera-pro camera-data))

    # Draw
    (jay/begin-drawing)
    (jay/clear-background :ray-white)

    (jay/with-mode-3d (camera-data :camera)
      (jay/draw-plane @{:x 0.0 :y 0.0 :z 0.0} @{:x 32.0 :y 32.0} :light-gray)
      (jay/draw-cube @{:x -16.0 :y 2.5 :z 0.0} 1.0 5.0 32.0 :blue)
      (jay/draw-cube @{:x 16.0 :y 2.5 :z 0.0} 1.0 5.0 32.0 :lime)
      (jay/draw-cube @{:x 0.0 :y 2.5 :z 16.0} 32.0 5.0 1.0 :gold))

    (jay/draw-rectangle 5 5 220 70 (jay/fade :sky-blue 0.5))
    (jay/draw-rectangle-lines 5 5 220 70 :blue)

    (jay/draw-text "First person camera" 15 15 10 :black)
    (jay/draw-text "- Move with W, A, S, D" 15 30 10 :dark-gray)
    (jay/draw-text "- Look with mouse" 15 45 10 :dark-gray)

    (jay/end-drawing))

  (jay/close-window)))
