(import jaylib :as jay)
(import string)

(def screen-width 800)
(def screen-height 450)

(def glsl-version
  (if (or (= (jay/get-platform) :platform-desktop) (= (jay/get-platform) :platform-linux))
    330
    100))

(defn main [& args]
  (jay/init-window screen-width screen-height "raylib [shaders] example - texture shader")

  (def texture (jay/load-texture "resources/fudesumi.png"))
  (def shader (jay/load-shader nil (string/format "resources/shaders/glsl%d/grayscale.fs" glsl-version)))

  (jay/set-target-fps 60)

  (while (not (jay/window-should-close))
    (jay/begin-drawing)
    (jay/clear-background :ray-white)

    (jay/with-shader-mode shader
      (jay/draw-texture texture 0 0 :white))

    (jay/draw-text "(c) Fudesumi (Sumo paint) by viciious" (- screen-width 280) (- screen-height 20) 10 :gray)
    (jay/draw-fps 10 10)

    (jay/end-drawing))

  (jay/unload-shader shader)
  (jay/unload-texture texture)
  (jay/close-window)))
