(import jaylib :as jay)
(import string)

(def screen-width 800)
(def screen-height 450)

(def max-input-chars 9)

(defn main [& args]
  (jay/init-window screen-width screen-height "raylib [text] example - input box")

  (var name @"")
  (var letter-count 0)

  (def text-box @{:x (- (/ screen-width 2.0) 100) :y 180 :width 225 :height 50})
  (var mouse-on-text false)
  (var frames-counter 0)

  (jay/set-target-fps 60)

  (while (not (jay/window-should-close))
    # Update
    (set mouse-on-text (jay/check-collision-point-rec (jay/get-mouse-position) text-box))

    (if mouse-on-text
      (do
        (jay/set-mouse-cursor :i-beam)
        (var key (jay/get-char-pressed))
        (while (> key 0)
          (when (and (>= key 32) (<= key 125) (< letter-count max-input-chars))
            (set name (string name (string/from-bytes key)))
            (set letter-count (inc letter-count)))
          (set key (jay/get-char-pressed)))

        (when (jay/is-key-pressed :backspace)
          (set letter-count (dec letter-count))
          (when (< letter-count 0) (set letter-count 0))
          (set name (string/slice name 0 letter-count))))
      (jay/set-mouse-cursor :default))

    (if mouse-on-text (set frames-counter (inc frames-counter)) (set frames-counter 0))

    # Draw
    (jay/begin-drawing)
    (jay/clear-background :ray-white)

    (jay/draw-text "PLACE MOUSE OVER INPUT BOX!" 240 140 20 :gray)
    (jay/draw-rectangle-rec text-box :light-gray)
    (jay/draw-rectangle-lines (text-box :x) (text-box :y) (text-box :width) (text-box :height) (if mouse-on-text :red :dark-gray))

    (jay/draw-text name (+ (text-box :x) 5) (+ (text-box :y) 8) 40 :maroon)
    (jay/draw-text (string/format "INPUT CHARS: %d/%d" letter-count max-input-chars) 315 250 20 :dark-gray)

    (when mouse-on-text
      (if (< letter-count max-input-chars)
        (when (even? (// frames-counter 20))
          (jay/draw-text "_" (+ (text-box :x) 8 (jay/measure-text name 40)) (+ (text-box :y) 12) 40 :maroon))
        (jay/draw-text "Press BACKSPACE to delete chars..." 230 300 20 :gray)))

    (jay/end-drawing))

  (jay/close-window)))
