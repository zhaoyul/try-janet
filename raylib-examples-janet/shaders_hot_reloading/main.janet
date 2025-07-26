(import jaylib :as jay)
(import string)
(import os)

(def screen-width 800)
(def screen-height 450)

(def glsl-version
  (if (or (= (jay/get-platform) :platform-desktop) (= (jay/get-platform) :platform-linux))
    330
    100))

(defn main [& args]
  (jay/init-window screen-width screen-height "raylib [shaders] example - hot reloading")

  (def frag-shader-file-name (string/format "resources/shaders/glsl%d/reload.fs" glsl-version))
  (var frag-shader-file-mod-time (os/stat frag-shader-file-name :mtime))

  (var shader (jay/load-shader nil frag-shader-file-name))

  (var resolution-loc (jay/get-shader-location shader "resolution"))
  (var mouse-loc (jay/get-shader-location shader "mouse"))
  (var time-loc (jay/get-shader-location shader "time"))

  (def resolution @[(float screen-width) (float screen-height)])
  (jay/set-shader-value shader resolution-loc resolution :vec2)

  (var total-time 0.0)
  (var shader-auto-reloading false)

  (jay/set-target-fps 60)

  (while (not (jay/window-should-close))
    # Update
    (set total-time (+ total-time (jay/get-frame-time)))
    (def mouse (jay/get-mouse-position))
    (def mouse-pos @[(mouse :x) (mouse :y)])

    (jay/set-shader-value shader time-loc total-time :float)
    (jay/set-shader-value shader mouse-loc mouse-pos :vec2)

    (if (or shader-auto-reloading (jay/is-mouse-button-pressed :left))
      (do
        (def current-frag-shader-mod-time (os/stat frag-shader-file-name :mtime))
        (when (not= current-frag-shader-mod-time frag-shader-file-mod-time)
          (def updated-shader (jay/load-shader nil frag-shader-file-name))
          (when (not= (updated-shader :id) ((jay/get-shader-default) :id))
            (jay/unload-shader shader)
            (set shader updated-shader)
            (set resolution-loc (jay/get-shader-location shader "resolution"))
            (set mouse-loc (jay/get-shader-location shader "mouse"))
            (set time-loc (jay/get-shader-location shader "time"))
            (jay/set-shader-value shader resolution-loc resolution :vec2)))
          (set frag-shader-file-mod-time current-frag-shader-mod-time))))

    (when (jay/is-key-pressed :a) (set shader-auto-reloading (not shader-auto-reloading)))

    # Draw
    (jay/begin-drawing)
    (jay/clear-background :ray-white)

    (jay/with-shader-mode shader
      (jay/draw-rectangle 0 0 screen-width screen-height :white))

    (jay/draw-text (string/format "PRESS [A] to TOGGLE SHADER AUTOLOADING: %s" (if shader-auto-reloading "AUTO" "MANUAL")) 10 10 10 (if shader-auto-reloading :red :black))
    (unless shader-auto-reloading (jay/draw-text "MOUSE CLICK to SHADER RE-LOADING" 10 30 10 :black))

    (jay/draw-text (string/format "Shader last modification: %d" frag-shader-file-mod-time) 10 430 10 :black)

    (jay/end-drawing))

  (jay/unload-shader shader)
  (jay/close-window)))
