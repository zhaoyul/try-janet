(import jaylib :as jay)
(import string)

(def max-touch-points 10)

(def screen-width 800)
(def screen-height 450)

(defn main [& args]
  (jay/init-window screen-width screen-height "raylib [core] example - input multitouch")

  (var ball-positions (array/new-filled max-touch-points @{:x -100.0 :y -100.0}))
  (var touch-colors (array/new-filled max-touch-points :gray))

  (jay/set-target-fps 60)

  (while (not (jay/window-should-close))
    # Update
    (for i 0 max-touch-points
      (put ball-positions i (jay/get-touch-position i))
      (if (and (> (get-in ball-positions [i :x]) 0)
               (> (get-in ball-positions [i :y]) 0))
        (cond (jay/gesture-detected? :tap) (put touch-colors i :orange)
              (jay/gesture-detected? :double-tap) (put touch-colors i :dark-blue)
              (jay/gesture-detected? :hold) (put touch-colors i :red)
              (jay/gesture-detected? :drag) (put touch-colors i :purple)
              (jay/gesture-detected? :swipe-right) (put touch-colors i :maroon)
              (jay/gesture-detected? :swipe-left) (put touch-colors i :lime)
              (jay/gesture-detected? :swipe-up) (put touch-colors i :gold)
              (jay/gesture-detected? :swipe-down) (put touch-colors i :blue)
              (jay/gesture-detected? :pinch-in) (put touch-colors i :beige)
              (jay/gesture-detected? :pinch-out) (put touch-colors i :violet))))

    # Draw
    (jay/begin-drawing)
    (jay/clear-background :ray-white)

    (jay/draw-text "move ball with mouse and click mouse button to change color" 10 10 20 :dark-gray)

    (for i 0 max-touch-points
      (when (> (get-in ball-positions [i :x]) 0)
        (jay/draw-circle-v (ball-positions i) 30 (touch-colors i))))

    (jay/draw-text (string/format "Touch points: %d" (jay/get-touch-point-count)) 10 40 20 :dark-gray)

    (jay/end-drawing))

  (jay/close-window))
