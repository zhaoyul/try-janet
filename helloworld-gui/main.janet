(import jaylib :as jay)

(def screen-width 800)
(def screen-height 450)

(defn main [& args]
  (jay/init-window screen-width screen-height "Hello, Jaylib!")
  (jay/set-target-fps 60)

  (while (not (jay/window-should-close))
    (jay/begin-drawing)
    (jay/clear-background :ray-white)
    (jay/draw-text "Hello, World!" 190 200 20 :light-gray)
    (jay/end-drawing))

  (jay/close-window))
