(import jaylib :as jay)

(def screen-width 800)
(def screen-height 450)

(defn main [& args]
  (jay/init-window screen-width screen-height "raylib [shapes] example - bezier lines")

  (var start @{:x 40.0 :y 250.0})
  (var end @{:x (- screen-width 40.0) :y 250.0})

  (jay/set-target-fps 60)

  (while (not (jay/window-should-close))
    # Update
    (if (jay/is-mouse-button-down :left)
      (set start (jay/get-mouse-position))
      (if (jay/is-mouse-button-down :right)
        (set end (jay/get-mouse-position))))

    # Draw
    (jay/begin-drawing)
    (jay/clear-background :ray-white)

    (jay/draw-text "USE MOUSE LEFT-RIGHT BUTTONS to DEFINE START and END POINTS" 15 20 20 :gray)

    (jay/draw-line-bezier start end 2.0 :red)

    (jay/draw-circle-v start 5 :blue)
    (jay/draw-circle-v end 5 :blue)

    (jay/end-drawing))

  (jay/close-window)))
