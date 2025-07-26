(import jaylib :as jay)

(def screen-width 800)
(def screen-height 450)

(def msg "THIS is a TTF FONT")

(defn main [& args]
  (jay/init-window screen-width screen-height "raylib [text] example - font loading")

  (def font (jay/load-font "resources/fonts/anonymous_pro_bold.ttf"))

  (jay/set-target-fps 60)

  (while (not (jay/window-should-close))
    (jay/begin-drawing)
    (jay/clear-background :ray-white)

    (jay/draw-text-ex font msg @{:x 20 :y 100} (font :base-size) 4 :maroon)

    (jay/end-drawing))

  (jay/unload-font font)
  (jay/close-window)))
