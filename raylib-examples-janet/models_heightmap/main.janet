(import jaylib :as jay)

(def screen-width 800)
(def screen-height 450)

(defn main [& args]
  (jay/init-window screen-width screen-height "raylib [models] example - heightmap")

  (var camera
       (jay/camera-3d
         :position @{:x 16.0 :y 14.0 :z 16.0}
         :target @{:x 0.0 :y 0.0 :z 0.0}
         :up @{:x 0.0 :y 1.0 :z 0.0}
         :fovy 45.0
         :projection :perspective))

  (def heightmap (jay/load-image "resources/heightmap.png"))
  (def mesh (jay/gen-mesh-heightmap heightmap @{:x 16.0 :y 8.0 :z 16.0}))
  (def model (jay/load-model-from-mesh mesh))

  (def texture (jay/load-texture "resources/colormaps.png"))
  (jay/set-material-texture (model :materials 0) :diffuse texture)

  (def map-position @{:x -8.0 :y 0.0 :z -8.0})

  (jay/unload-image heightmap)

  (jay/set-target-fps 60)

  (while (not (jay/window-should-close))
    # Update
    (jay/update-camera& camera)

    # Draw
    (jay/begin-drawing)
    (jay/clear-background :ray-white)

    (jay/with-mode-3d camera
      (jay/draw-model model map-position 1.0 :white)
      (jay/draw-grid 20 1.0))

    (jay/draw-texture-ex texture @{:x (- screen-width (texture :width) 20) :y 20} 0.0 1.0 :white)
    (jay/draw-rectangle-lines (- screen-width (texture :width) 20) 20 (texture :width) (texture :height) :green)

    (jay/draw-text "HEIGHTMAP EXAMPLE" 10 10 20 :dark-gray)
    (jay/draw-fps 10 40)

    (jay/end-drawing))

  (jay/unload-texture texture)
  (jay/unload-model model)
  (jay/close-window)))
