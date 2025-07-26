(import jaylib :as jay)

(def screen-width 800)
(def screen-height 450)

(defn main [& args]
  (jay/init-window screen-width screen-height "raylib [core] example - mouse wheel")

  (var box-height 40.0)

  (jay/set-target-fps 60)

  (while (not (jay/window-should-close))
    # Update
    (def wheel (jay/get-mouse-wheel-move))
    (set box-height (+ box-height (* wheel 8.0)))

    # Draw
    (jay/begin-drawing)
    (jay/clear-background :ray-white)
    (jay/draw-rectangle
      (/ (- screen-width 300) 2)
      (/ (- screen-height box-height) 2)
      300
      box-height
      :maroon)
    (jay/draw-text "Use mouse wheel to change box height" 10 10 20 :gray)
    (jay/end-drawing))

  (jay/close-window))
