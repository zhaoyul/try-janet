(import jaylib :as jay)

(def screen-width 800)
(def screen-height 450)

(defn main [& args]
  (jay/init-window screen-width screen-height "raylib [core] example - mouse input")

  (var ball-color :dark-blue)

  (jay/set-target-fps 100)
  (while (not (jay/window-should-close))
    # Update
    (def ball-position (jay/get-mouse-position))

    (cond (jay/mouse-button-pressed? :left)   (set ball-color :maroon)
          (jay/mouse-button-pressed? :middle) (set ball-color :lime)
          (jay/mouse-button-pressed? :right)  (set ball-color :dark-blue))


    # Draw
    (jay/begin-drawing)
    (jay/clear-background :ray-white)
    (jay/draw-text "move ball with mouse and click mouse button to change color" 10 10 20 :dark-gray)
    (jay/draw-circle-v ball-position 40.0 ball-color)
    (jay/end-drawing))

  (jay/close-window))
