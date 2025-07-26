(import jaylib :as jay)

(def screen-width 800)
(def screen-height 450)

(defn main [& args]
  (jay/init-window screen-width screen-height "raylib [models] example - material map")

  (var camera
       (jay/camera-3d
         :position @{:x 2.0 :y 2.0 :z 6.0}
         :target @{:x 0.0 :y 0.5 :z 0.0}
         :up @{:x 0.0 :y 1.0 :z 0.0}
         :fovy 45.0
         :projection :perspective))

  (def model (jay/load-model "resources/cube.obj"))
  (def texture (jay/load-texture "resources/dice_diffuse.png"))
  (jay/set-material-texture (model :materials 0) :diffuse texture)

  (def position @{:x 0.0 :y 0.0 :z 0.0})

  (jay/set-target-fps 60)

  (while (not (jay/window-should-close))
    # Update
    (jay/update-camera& camera)

    # Draw
    (jay/begin-drawing)
    (jay/clear-background :ray-white)

    (jay/with-mode-3d camera
      (jay/draw-model model position 1.0 :white)
      (jay/draw-grid 10 1.0))

    (jay/draw-text "(c) Dice 3D model by Emanuele Salvucci" (- screen-width 220) (- screen-height 20) 10 :gray)
    (jay/draw-fps 10 10)

    (jay/end-drawing))

  (jay/unload-texture texture)
  (jay/unload-model model)
  (jay/close-window)))
