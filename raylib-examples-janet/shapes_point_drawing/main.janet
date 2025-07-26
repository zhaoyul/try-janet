(import jaylib :as jay)

(def screen-width 800)
(def screen-height 450)

(defn main [& args]
  (jay/init-window screen-width screen-height "raylib [shapes] example - point drawing")
  (jay/set-target-fps 60)

  (while (not (jay/window-should-close))
    (jay/begin-drawing)
    (jay/clear-background :ray-white)

    (jay/draw-point (/ screen-width 2) (/ screen-height 2) :maroon)

    (jay/draw-text "This is a single pixel" (- (/ screen-width 2) 100) (+ (/ screen-height 2) 20) 20 :gray)

    (jay/end-drawing))

  (jay/close-window)))
