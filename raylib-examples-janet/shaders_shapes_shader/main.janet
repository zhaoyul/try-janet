(import jaylib :as jay)
(import string)

(def screen-width 800)
(def screen-height 450)

(def glsl-version
  (if (or (= (jay/get-platform) :platform-desktop) (= (jay/get-platform) :platform-linux))
    330
    100))

(defn main [& args]
  (jay/init-window screen-width screen-height "raylib [shaders] example - shapes shader")

  (def shader (jay/load-shader nil (string/format "resources/shaders/glsl%d/swirl.fs" glsl-version)))

  (def swirl-center-loc (jay/get-shader-location shader "swirlCenter"))
  (def swirl-radius-loc (jay/get-shader-location shader "swirlRadius"))
  (def swirl-angle-loc (jay/get-shader-location shader "swirlAngle"))

  (var swirl-center @[400.0 225.0])
  (var swirl-radius 200.0)
  (var swirl-angle 0.0)

  (jay/set-shader-value shader swirl-center-loc swirl-center :vec2)
  (jay/set-shader-value shader swirl-radius-loc swirl-radius :float)
  (jay/set-shader-value shader swirl-angle-loc swirl-angle :float)

  (jay/set-target-fps 60)

  (while (not (jay/window-should-close))
    # Update
    (set swirl-angle (+ swirl-angle 0.1))
    (jay/set-shader-value shader swirl-angle-loc swirl-angle :float)

    # Draw
    (jay/begin-drawing)
    (jay/clear-background :ray-white)

    (jay/with-shader-mode shader
      (jay/draw-circle (/ screen-width 2) (/ screen-height 2) 250.0 :orange))

    (jay/draw-fps 10 10)
    (jay/end-drawing))

  (jay/unload-shader shader)
  (jay/close-window)))
