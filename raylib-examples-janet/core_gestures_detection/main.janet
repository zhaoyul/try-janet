(import jaylib :as jay)
(import string)

(def screen-width 800)
(def screen-height 450)

(def max-gesture-strings 20)

(defn main [& args]
  (jay/init-window screen-width screen-height "raylib [core] example - gestures detection")

  (var touch-position @{:x -1.0 :y -1.0})
  (var touch-area @{:x 0 :y 0 :width 300 :height 300})

  (var gestures-count 0)
  (var gestures (array/new-filled max-gesture-strings ""))
  (var current-gesture :none)
  (var last-gesture :none)

  (jay/set-gestures-enabled #{:tap :double-tap :hold :drag :swipe-right :swipe-left :swipe-up :swipe-down :pinch-in :pinch-out})

  (jay/set-target-fps 60)

  (while (not (jay/window-should-close))
    # Update
    (set last-gesture current-gesture)
    (set current-gesture (jay/get-gesture-detected))
    (set touch-position (jay/get-touch-position 0))

    (when (and (not= current-gesture :none) (= current-gesture last-gesture))
      (case current-gesture
        :tap (do (put gestures gestures-count "TAP") (set gestures-count (inc gestures-count)))
        :double-tap (do (put gestures gestures-count "DOUBLE-TAP") (set gestures-count (inc gestures-count)))
        :hold (do (put gestures gestures-count "HOLD") (set gestures-count (inc gestures-count)))
        :drag (do (put gestures gestures-count "DRAG") (set gestures-count (inc gestures-count)))
        :swipe-right (do (put gestures gestures-count "SWIPE RIGHT") (set gestures-count (inc gestures-count)))
        :swipe-left (do (put gestures gestures-count "SWIPE LEFT") (set gestures-count (inc gestures-count)))
        :swipe-up (do (put gestures gestures-count "SWIPE UP") (set gestures-count (inc gestures-count)))
        :swipe-down (do (put gestures gestures-count "SWIPE DOWN") (set gestures-count (inc gestures-count)))
        :pinch-in (do (put gestures gestures-count "PINCH IN") (set gestures-count (inc gestures-count)))
        :pinch-out (do (put gestures gestures-count "PINCH OUT") (set gestures-count (inc gestures-count)))))

    (when (>= gestures-count max-gesture-strings)
      (for i 0 max-gesture-strings
        (put gestures i (gestures (inc i))))
      (set gestures-count (dec max-gesture-strings)))

    # Draw
    (jay/begin-drawing)
    (jay/clear-background :ray-white)

    (jay/draw-rectangle-rec touch-area :gray)
    (jay/draw-text "GESTURES TEST AREA" (+ (touch-area :x) 10) (+ (touch-area :y) 10) 20 :maroon)

    (for i 0 gestures-count
      (if (<= i gestures-count)
        (jay/draw-text (gestures i) 10 (+ 50 (* i 20)) 20 :maroon)
        (jay/draw-text (gestures i) 10 (+ 50 (* i 20)) 20 :light-gray)))

    (if (jay/check-collision-point-rec touch-position touch-area)
      (jay/draw-circle (touch-position :x) (touch-position :y) 30 :orange)
      (jay/draw-circle (touch-position :x) (touch-position :y) 30 :dark-blue))

    (jay/end-drawing))

  (jay/close-window))
