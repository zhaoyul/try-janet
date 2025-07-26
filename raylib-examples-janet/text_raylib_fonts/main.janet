(import jaylib :as jay)

(def screen-width 800)
(def screen-height 450)

(defn main [& args]
  (jay/init-window screen-width screen-height "raylib [text] example - raylib fonts")

  (def fonts
    (array
      (jay/load-font "resources/fonts/alagard.png")
      (jay/load-font "resources/fonts/pixelplay.png")
      (jay/load-font "resources/fonts/mecha.png")
      (jay/load-font "resources/fonts/setback.png")
      (jay/load-font "resources/fonts/romulus.png")
      (jay/load-font "resources/fonts/pixantiqua.png")
      (jay/load-font "resources/fonts/alpha_beta.png")
      (jay/load-font "resources/fonts/jupiter_crash.png")))

  (def messages
    (array
      "THIS is a NOT SO TINY FONT"
      "THIS is a NOT SO TINY FONT"
      "THIS is a NOT SO TINY FONT"
      "THIS is a NOT SO TINY FONT"
      "THIS is a NOT SO TINY FONT"
      "THIS is a NOT SO TINY FONT"
      "THIS is a NOT SO TINY FONT"
      "THIS is a NOT SO TINY FONT"))

  (def spacings (array/new-filled (length fonts) 0))
  (def colors (array/new-filled (length fonts) :black))

  (for i 0 (length fonts)
    (put spacings i (if (< i 2) 2 4))
    (put colors i (jay/color (jay/get-random-value 100 250)
                             (jay/get-random-value 80 200)
                             (jay/get-random-value 50 180)
                             255)))

  (jay/set-target-fps 60)

  (while (not (jay/window-should-close))
    (jay/begin-drawing)
    (jay/clear-background :ray-white)

    (jay/draw-text "Following fonts are provided by raylib" 20 20 20 :dark-gray)
    (jay/draw-line 20 40 780 40 :dark-gray)

    (for i 0 (length fonts)
      (jay/draw-text-ex (fonts i) (messages i) @{:x 20 :y (+ 60 (* 40 i))} (// ((fonts i) :base-size) 1) (spacings i) (colors i)))

    (jay/end-drawing))

  (for font fonts (jay/unload-font font))
  (jay/close-window)))
