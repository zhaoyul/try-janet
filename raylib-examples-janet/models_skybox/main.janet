(import jaylib :as jay)
(import string)

(def screen-width 800)
(def screen-height 450)

(def glsl-version
  (if (or (= (jay/get-platform) :platform-desktop) (= (jay/get-platform) :platform-linux))
    330
    100))

(defn main [& args]
  (jay/init-window screen-width screen-height "raylib [models] example - skybox")

  (var camera
       (jay/camera-3d
         :position @{:x 0.0 :y 0.0 :z 0.0}
         :target @{:x 0.0 :y 0.0 :z 0.0}
         :up @{:x 0.0 :y 1.0 :z 0.0}
         :fovy 45.0
         :projection :perspective))

  (def skybox-shader (jay/load-shader (string/format "resources/shaders/glsl%d/skybox.vs" glsl-version)
                                      (string/format "resources/shaders/glsl%d/skybox.fs" glsl-version)))

  (jay/set-shader-value skybox-shader (jay/get-shader-location skybox-shader "environmentMap") 1 :int)

  (def skybox-mesh (jay/gen-mesh-cube 1.0 1.0 1.0))
  (def skybox (jay/load-model-from-mesh skybox-mesh))
  (jay/set-material-shader (skybox :materials 0) skybox-shader)

  (def skybox-texture (jay/load-texture-cubemap (jay/load-image "resources/skybox.png") :layout-auto))
  (jay/set-material-texture (skybox :materials 0) :cubemap skybox-texture)

  (jay/set-camera-mode camera :first-person)
  (jay/set-target-fps 60)

  (while (not (jay/window-should-close))
    # Update
    (jay/update-camera& camera)

    # Draw
    (jay/begin-drawing)
    (jay/clear-background :ray-white)

    (jay/with-mode-3d camera
      (jay/draw-model skybox @{:x 0 :y 0 :z 0} 1.0 :white))

    (jay/draw-text "Welcome to the skybox!" 10 10 20 :white)
    (jay/draw-fps 10 30)

    (jay/end-drawing))

  (jay/unload-shader skybox-shader)
  (jay/unload-texture skybox-texture)
  (jay/unload-model skybox)
  (jay/close-window)))
