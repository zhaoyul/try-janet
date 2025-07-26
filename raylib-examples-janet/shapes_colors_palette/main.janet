(import jaylib :as jay)
(import string)

(def screen-width 800)
(def screen-height 450)

(def colors
  [:dark-gray :maroon :orange :dark-green :dark-blue :dark-purple
   :dark-brown :gray :red :gold :lime :blue :violet :brown
   :light-gray :pink :yellow :green :sky-blue :purple :beige])

(def color-names
  ["DARKGRAY" "MAROON" "ORANGE" "DARKGREEN" "DARKBLUE" "DARKPURPLE"
   "DARKBROWN" "GRAY" "RED" "GOLD" "LIME" "BLUE" "VIOLET" "BROWN"
   "LIGHTGRAY" "PINK" "YELLOW" "GREEN" "SKYBLUE" "PURPLE" "BEIGE"])

(defn main [& args]
  (jay/init-window screen-width screen-height "raylib [shapes] example - colors palette")

  (var color-recs (array/new-filled (length colors) @{}))

  (for i 0 (length colors)
    (put-in color-recs [i :x] (+ 20 (* 100 (math/floor (/ i 7)))))
    (put-in color-recs [i :y] (+ 50 (* 50 (math/fmod i 7))))
    (put-in color-recs [i :width] 80)
    (put-in color-recs [i :height] 30))

  (jay/set-target-fps 60)

  (while (not (jay/window-should-close))
    # Draw
    (jay/begin-drawing)
    (jay/clear-background :ray-white)

    (jay/draw-text "raylib colors palette" 28 42 20 :black)
    (jay/draw-text "raylib colors palette" 29 41 20 :light-gray)

    (for i 0 (length colors)
      (jay/draw-rectangle-rec (color-recs i) (colors i))
      (jay/draw-rectangle-lines-ex (color-recs i) 2 :black)
      (jay/draw-text (color-names i) (+ ((color-recs i) :x) 10) (+ ((color-recs i) :y) 10) 10 :black))

    (jay/end-drawing))

  (jay/close-window)))
