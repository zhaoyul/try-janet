(import jaylib :as jay)
(import string)

(def screen-width 800)
(def screen-height 450)

(defn main [& args]
  (jay/init-window screen-width screen-height "raylib [text] example - format text")

  (var score 0)
  (var hiscore 0)

  (jay/set-target-fps 60)

  (while (not (jay/window-should-close))
    # Update
    (set score (inc score))
    (when (> score hiscore) (set hiscore score))

    (when (jay/is-key-pressed :space)
      (set score 0))

    # Draw
    (jay/begin-drawing)
    (jay/clear-background :ray-white)

    (jay/draw-text (string/format "SCORE: %08d" score) 20 20 20 :maroon)
    (jay/draw-text (string/format "HI-SCORE: %08d" hiscore) 20 50 20 :black)

    (jay/draw-text "PRESS [SPACE] to RESET SCORE" 20 (- screen-height 30) 20 :light-gray)

    (jay/end-drawing))

  (jay/close-window)))
