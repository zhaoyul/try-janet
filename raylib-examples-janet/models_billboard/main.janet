(import jaylib :as jay)

(def screen-width 800)
(def screen-height 450)

(defn main [& args]
  (jay/init-window screen-width screen-height "raylib [models] example - billboard")

  (var camera
       (jay/camera-3d
         :position @{:x 5.0 :y 4.0 :z 5.0}
         :target @{:x 0.0 :y 2.0 :z 0.0}
         :up @{:x 0.0 :y 1.0 :z 0.0}
         :fovy 45.0
         :projection :perspective))

  (def bill (jay/load-texture "resources/billboard.png"))
  (def bill-position @{:x 0.0 :y 2.0 :z 0.0})

  (jay/set-target-fps 60)

  (while (not (jay/window-should-close))
    # Update
    (jay/update-camera& camera)

    # Draw
    (jay/begin-drawing)
    (jay/clear-background :ray-white)

    (jay/with-mode-3d camera
      (jay/draw-grid 10 1.0)
      (jay/draw-billboard camera bill bill-position 2.0 :white))

    (jay/draw-fps 10 10)
    (jay/end-drawing))

  (jay/unload-texture bill)
  (jay/close-window)))
