(import jaylib :as jay)

(def screen-width 800)
(def screen-height 450)

(defn main [& args]
  (jay/init-window screen-width screen-height "raylib [models] example - first person maze")

  (var camera
       (jay/camera-3d
         :position @{:x 0.2 :y 0.4 :z 0.2}
         :target @{:x 0.0 :y 0.0 :z 0.0}
         :up @{:x 0.0 :y 1.0 :z 0.0}
         :fovy 45.0
         :projection :perspective))

  (def cubicmap (jay/load-image "resources/cubicmap.png"))
  (def mesh (jay/gen-mesh-cubicmap cubicmap @{:x 1.0 :y 1.0 :z 1.0}))
  (def model (jay/load-model-from-mesh mesh))

  (def texture (jay/load-texture "resources/cubicmap_atlas.png"))
  (jay/set-material-texture (model :materials 0) :diffuse texture)

  (def map-position @{:x -16.0 :y 0.0 :z -8.0})
  (def player-position (camera :position))

  (jay/unload-image cubicmap)

  (jay/set-camera-mode camera :first-person)
  (jay/set-target-fps 60)

  (while (not (jay/window-should-close))
    # Update
    (def old-cam-pos (camera :position))
    (jay/update-camera& camera)
    (def new-cam-pos (camera :position))

    (def map-pixels (jay/load-image-colors cubicmap))
    (def map-width (cubicmap :width))
    (def map-height (cubicmap :height))

    (def player-map-x (math/floor (+ new-cam-pos :x (- map-position :x) 0.5)))
    (def player-map-y (math/floor (+ new-cam-pos :z (- map-position :z) 0.5)))

    (if (and (>= player-map-x 0) (< player-map-x map-width)
             (>= player-map-y 0) (< player-map-y map-height)
             (= ((map-pixels (+ (* player-map-y map-width) player-map-x)) :r) 255))
      (set (camera :position) old-cam-pos))

    (jay/unload-image-colors map-pixels)

    # Draw
    (jay/begin-drawing)
    (jay/clear-background :ray-white)

    (jay/with-mode-3d camera
      (jay/draw-model model map-position 1.0 :white))

    (jay/draw-rectangle (- screen-width 260) 10 250 120 (jay/fade :sky-blue 0.5))
    (jay/draw-rectangle-lines (- screen-width 260) 10 250 120 :blue)
    (jay/draw-text "PLAYER POSITION" (- screen-width 250) 20 10 :black)
    (jay/draw-text (string/format "X: %.2f" (player-position :x)) (- screen-width 250) 40 10 :black)
    (jay/draw-text (string/format "Y: %.2f" (player-position :y)) (- screen-width 250) 60 10 :black)
    (jay/draw-text (string/format "Z: %.2f" (player-position :z)) (- screen-width 250) 80 10 :black)

    (jay/draw-fps 10 10)
    (jay/end-drawing))

  (jay/unload-texture texture)
  (jay/unload-model model)
  (jay/close-window)))
