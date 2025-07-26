(import jaylib :as jay)
(import jaylib/math :as jmath)

(def screen-width 800)
(def screen-height 450)

(defn main [& args]
  (jay/init-window screen-width screen-height "raylib [models] example - yaw pitch roll")

  (var camera
       (jay/camera-3d
         :position @{:x 0.0 :y 50.0 :z 50.0}
         :target @{:x 0.0 :y 0.0 :z 0.0}
         :up @{:x 0.0 :y 1.0 :z 0.0}
         :fovy 30.0
         :projection :perspective))

  (def model (jay/load-model "resources/airplane.obj"))
  (def texture (jay/load-texture "resources/airplane_diffuse.png"))
  (jay/set-material-texture (model :materials 0) :diffuse texture)

  (var pitch 0.0)
  (var roll 0.0)
  (var yaw 0.0)

  (jay/set-target-fps 60)

  (while (not (jay/window-should-close))
    # Update
    (when (jay/is-key-down :down) (set pitch (+ pitch 0.6)))
    (when (jay/is-key-down :up) (set pitch (- pitch 0.6)))
    (when (jay/is-key-down :right) (set yaw (- yaw 0.6)))
    (when (jay/is-key-down :left) (set yaw (+ yaw 0.6)))
    (when (jay/is-key-down :q) (set roll (+ roll 0.6)))
    (when (jay/is-key-down :e) (set roll (- roll 0.6)))

    (def matrix (jmath/matrix-rotate-zyx @{:x (* pitch jmath/deg2rad) :y (* yaw jmath/deg2rad) :z (* roll jmath/deg2rad)}))
    (set (model :transform) matrix)

    # Draw
    (jay/begin-drawing)
    (jay/clear-background :ray-white)

    (jay/with-mode-3d camera
      (jay/draw-model model @{:x 0 :y 0 :z 0} 1.0 :white)
      (jay/draw-grid 10 10.0))

    (jay/draw-text "Use UP/DOWN to Pitch, LEFT/RIGHT to Yaw, Q/E to Roll" 10 10 20 :gray)
    (jay/draw-fps 10 30)

    (jay/end-drawing))

  (jay/unload-texture texture)
  (jay/unload-model model)
  (jay/close-window)))
