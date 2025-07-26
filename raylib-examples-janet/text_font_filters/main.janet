(import jaylib :as jay)
(import string)

(def screen-width 800)
(def screen-height 450)

(def msg "THIS is a PIXANTIQUA FONT")

(defn main [& args]
  (jay/init-window screen-width screen-height "raylib [text] example - font filters")

  (def font (jay/load-font "resources/fonts/pixantiqua.png"))
  (var font-size (font :base-size))
  (var font-position @{:x 0.0 :y 0.0})
  (var current-font-filter 0)

  (jay/set-target-fps 60)

  (while (not (jay/window-should-close))
    # Update
    (set font-size (+ font-size (* (jay/get-mouse-wheel-move) 4.0)))
    (when (< font-size 6) (set font-size 6))

    (when (jay/is-key-pressed :space)
      (set current-font-filter (if (> (inc current-font-filter) 2) 0 (inc current-font-filter))))

    (case current-font-filter
      0 (jay/set-texture-filter (font :texture) :point)
      1 (jay/set-texture-filter (font :texture) :bilinear)
      2 (jay/set-texture-filter (font :texture) :trilinear))

    (set font-position @{:x (- (/ screen-width 2) (/ ((jay/measure-text-ex font msg font-size 4) :x) 2))
                         :y (- (/ screen-height 2) (/ font-size 2))})

    # Draw
    (jay/begin-drawing)
    (jay/clear-background :ray-white)

    (jay/draw-text "Use MOUSE WHEEL to SCALE TEXT" 20 20 20 :gray)
    (jay/draw-text "PRESS SPACE to CHANGE FILTERING" 20 50 20 :gray)

    (jay/draw-text-ex font msg font-position font-size 4 :black)

    (jay/draw-rectangle 0 (- screen-height 40) screen-width 40 :light-gray)
    (jay/draw-text
      (case current-font-filter
        0 "POINT"
        1 "BILINEAR"
        2 "TRILINEAR")
      20 (- screen-height 30) 20 :black)

    (jay/end-drawing))

  (jay/unload-font font)
  (jay/close-window)))
