(import jaylib :as jay)
(import string)

(def screen-width 800)
(def screen-height 450)

(def glsl-version
  (if (or (= (jay/get-platform) :platform-desktop) (= (jay/get-platform) :platform-linux))
    330
    100))

(defn main [& args]
  (jay/set-config-flags :msaa-4x-hint)
  (jay/init-window screen-width screen-height "raylib [shaders] example - model shader")

  (var camera
       (jay/camera-3d
         :position @{:x 4.0 :y 4.0 :z 4.0}
         :target @{:x 0.0 :y 1.0 :z -1.0}
         :up @{:x 0.0 :y 1.0 :z 0.0}
         :fovy 45.0
         :projection :perspective))

  (def model (jay/load-model "resources/models/watermill.obj"))
  (def texture (jay/load-texture "resources/models/watermill_diffuse.png"))
  (def shader (jay/load-shader nil (string/format "resources/shaders/glsl%d/grayscale.fs" glsl-version)))

  (jay/set-material-shader (model :materials 0) shader)
  (jay/set-material-texture (model :materials 0) :diffuse texture)

  (def position @{:x 0.0 :y 0.0 :z 0.0})

  (jay/disable-cursor)
  (jay/set-target-fps 60)

  (while (not (jay/window-should-close))
    # Update
    (jay/update-camera& camera :free)

    # Draw
    (jay/begin-drawing)
    (jay/clear-background :ray-white)

    (jay/with-mode-3d camera
      (jay/draw-model model position 0.2 :white)
      (jay/draw-grid 10 1.0))

    (jay/draw-text "(c) Watermill 3D model by Alberto Cano" (- screen-width 210) (- screen-height 20) 10 :gray)
    (jay/draw-fps 10 10)

    (jay/end-drawing))

  (jay/unload-shader shader)
  (jay/unload-texture texture)
  (jay/unload-model model)
  (jay/close-window)))
