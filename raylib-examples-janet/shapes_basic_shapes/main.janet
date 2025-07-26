(import jaylib :as jay)

(def screen-width 800)
(def screen-height 450)

(defn main [& args]
  (jay/init-window screen-width screen-height "raylib [shapes] example - basic shapes")
  (jay/set-target-fps 60)

  (while (not (jay/window-should-close))
    (jay/begin-drawing)
    (jay/clear-background :ray-white)

    (jay/draw-text "some basic shapes available on raylib" 20 20 20 :dark-gray)

    (jay/draw-circle 120 120 35 (jay/fade :gold 0.5))
    (jay/draw-rectangle 250 70 120 60 :maroon)
    (jay/draw-rectangle-lines 250 70 120 60 :black)
    (jay/draw-rectangle-gradient-h 250 140 120 60 :green :blue)
    (jay/draw-triangle [430 70] [430 130] [490 130] :red)
    (jay/draw-poly [560 120] 6 40 0 :brown)
    (jay/draw-circle-gradient 120 240 60 :green :sky-blue)

    (jay/draw-line 30 400 770 400 :light-gray)
    (jay/draw-ring [200 320] 40 80 0 360 32 :blue)
    (jay/draw-ring-lines [200 320] 40 80 0 360 32 :black)
    (jay/draw-ellipse 560 320 80 40 :sky-blue)
    (jay/draw-ellipse-lines 560 320 80 40 :blue)

    (jay/end-drawing))

  (jay/close-window)))
