(import jaylib :as jay)
(import string)

(def screen-width 800)
(def screen-height 450)

(def glsl-version
  (if (or (= (jay/get-platform) :platform-desktop) (= (jay/get-platform) :platform-linux))
    330
    100))

(defn main [& args]
  (jay/init-window screen-width screen-height "raylib [text] example - SDF fonts")

  (def msg "Signed Distance Fields")

  (def font-default (jay/load-font-ex "resources/fonts/anonymous_pro_bold.ttf" 16 95 :default))
  (def font-sdf (jay/load-font-ex "resources/fonts/anonymous_pro_bold.ttf" 16 95 :sdf))

  (def shader (jay/load-shader nil (string/format "resources/shaders/glsl%d/sdf.fs" glsl-version)))
  (jay/set-texture-filter (font-sdf :texture) :bilinear)

  (var font-position @{:x 40.0 :y (- (/ screen-height 2.0) 50)})
  (var text-size @{:x 0.0 :y 0.0})
  (var font-size 16.0)
  (var current-font 0)

  (jay/set-target-fps 60)

  (while (not (jay/window-should-close))
    # Update
    (set font-size (+ font-size (* (jay/get-mouse-wheel-move) 8.0)))
    (when (< font-size 6) (set font-size 6))

    (if (jay/is-key-down :space) (set current-font 1) (set current-font 0))

    (set text-size
         (if (= current-font 0)
           (jay/measure-text-ex font-default msg font-size 0)
           (jay/measure-text-ex font-sdf msg font-size 0)))

    (set (font-position :x) (- (/ screen-width 2.0) (/ (text-size :x) 2)))
    (set (font-position :y) (+ (- (/ screen-height 2.0) (/ (text-size :y) 2)) 80))

    # Draw
    (jay/begin-drawing)
    (jay/clear-background :ray-white)

    (if (= current-font 1)
      (do
        (jay/begin-shader-mode shader)
        (jay/draw-text-ex font-sdf msg font-position font-size 0 :black)
        (jay/end-shader-mode))
      (jay/draw-text-ex font-default msg font-position font-size 0 :black))

    (if (= current-font 1)
      (jay/draw-text "SDF!" 320 20 80 :red)
      (jay/draw-text "default font" 315 40 30 :gray))

    (jay/draw-text "FONT SIZE: 16.0" (- screen-width 240) 20 20 :dark-gray)
    (jay/draw-text (string/format "RENDER SIZE: %02.02f" font-size) (- screen-width 240) 50 20 :dark-gray)
    (jay/draw-text "Use MOUSE WHEEL to SCALE TEXT!" (- screen-width 240) 90 10 :dark-gray)
    (jay/draw-text "HOLD SPACE to USE SDF FONT VERSION!" 340 (- screen-height 30) 20 :maroon)

    (jay/end-drawing))

  (jay/unload-font font-default)
  (jay/unload-font font-sdf)
  (jay/unload-shader shader)
  (jay/close-window)))
