(import jaylib :as jay)

(def screen-width 800)
(def screen-height 450)

(def msg "SMITE")

(defn main [& args]
  (jay/init-window screen-width screen-height "raylib [text] example - smite logo font")

  (def font (jay/load-font "resources/fonts/smitelogo.ttf"))

  (def font-position
    @{:x (- (/ screen-width 2) (/ ((jay/measure-text-ex font msg (font :base-size) 10) :x) 2))
      :y (- (/ screen-height 2) (/ (font :base-size) 2) 80)})

  (jay/set-target-fps 60)

  (while (not (jay/window-should-close))
    (jay/begin-drawing)
    (jay/clear-background :ray-white)

    (jay/draw-text-ex font msg font-position (font :base-size) 10 :black)
    (jay/draw-text "Smitelogo by Brian Kent (Ebrius)" 20 (- screen-height 20) 10 :dark-gray)

    (jay/end-drawing))

  (jay/unload-font font)
  (jay/close-window)))
