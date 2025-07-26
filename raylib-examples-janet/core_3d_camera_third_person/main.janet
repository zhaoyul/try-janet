(import jaylib :as jay)
(import jaylib/math :as jmath)

(def screen-width 800)
(def screen-height 450)

(defn main [& args]
  (jay/init-window screen-width screen-height "raylib [core] example - 3d camera third person")

  (var camera
       (jay/camera-3d
         :position @{:x 0.0 :y 10.0 :z 10.0}
         :target @{:x 0.0 :y 0.0 :z 0.0}
         :up @{:x 0.0 :y 1.0 :z 0.0}
         :fovy 45.0
         :projection :perspective))

  (var player-position @{:x 0.0 :y 0.0 :z 0.0})
  (var player-rotation 0.0)

  (jay/set-camera-mode camera :third-person)
  (jay/set-target-fps 60)

  (while (not (jay/window-should-close))
    # Update
    (jay/update-camera& camera)

    (when (jay/is-key-down :left) (set player-rotation (+ player-rotation 2.0)))
    (when (jay/is-key-down :right) (set player-rotation (- player-rotation 2.0)))

    (def matrix (jmath/matrix-rotate-y (* player-rotation (jmath/deg2rad))))
    (def forward (jmath/vector3-transform @{:x 0 :y 0 :z -1} matrix))

    (when (jay/is-key-down :up)
      (update player-position :x (fn [x] (+ x (forward :x))))
      (update player-position :z (fn [z] (+ z (forward :z)))))
    (when (jay/is-key-down :down)
      (update player-position :x (fn [x] (- x (forward :x))))
      (update player-position :z (fn [z] (- z (forward :z)))))

    (set (camera :target) player-position)

    # Draw
    (jay/begin-drawing)
    (jay/clear-background :ray-white)

    (jay/with-mode-3d camera
      (jay/draw-grid 20 1.0)
      (jay/draw-cube-ex player-position 2.0 2.0 2.0 :red)
      (jay/draw-cube-wires-ex player-position 2.0 2.0 2.0 :maroon)
      (jay/draw-line-3d player-position (camera :position) :green))

    (jay/draw-text "Player" (- (jay/get-world-to-screen player-position camera) :x 20)
                 (- (jay/get-world-to-screen player-position camera) :y 40)
                 20 :black)

    (jay/draw-fps 10 10)
    (jay/end-drawing))

  (jay/close-window)))
