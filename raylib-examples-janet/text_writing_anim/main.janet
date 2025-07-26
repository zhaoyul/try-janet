(import jaylib :as jay)
(import string)

(def screen-width 800)
(def screen-height 450)

(def msg "This is a sample text to be written on screen...")

(defn main [& args]
  (jay/init-window screen-width screen-height "raylib [text] example - writing animation")

  (var frames-counter 0)
  (var sub-text "")

  (jay/set-target-fps 60)

  (while (not (jay/window-should-close))
    # Update
    (set frames-counter (inc frames-counter))
    (when (and (jay/is-key-pressed :enter) (= (length sub-text) (length msg)))
      (set frames-counter 0)
      (set sub-text ""))

    (set sub-text (string/slice msg 0 (// frames-counter 10)))

    # Draw
    (jay/begin-drawing)
    (jay/clear-background :ray-white)

    (jay/draw-text sub-text 210 160 20 :maroon)

    (if (= (length sub-text) (length msg))
      (jay/draw-text "PRESS [ENTER] to REPLAY!" 240 250 20 :gray))

    (jay/end-drawing))

  (jay/close-window)))
