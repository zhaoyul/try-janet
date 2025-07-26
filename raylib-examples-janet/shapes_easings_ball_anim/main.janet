(import jaylib :as jay)
(import jaylib/easing :as easing)

(def screen-width 800)
(def screen-height 450)

(defn main [& args]
  (jay/init-window screen-width screen-height "raylib [shapes] example - easings ball anim")

  (var ball-position @{:x -100.0 :y 200.0})
  (var ball-radius 20.0)
  (var ball-color :maroon)

  (var state 0)
  (var frames-counter 0)

  (jay/set-target-fps 60)

  (while (not (jay/window-should-close))
    # Update
    (case state
      0 (do
          (set frames-counter (inc frames-counter))
          (set (ball-position :x) (easing/out-circ frames-counter 200 (- screen-width 400) 240))
          (when (= frames-counter 240)
            (set state 1)
            (set frames-counter 0)))
      1 (when (jay/is-key-pressed :space)
          (set frames-counter 0)
          (set (ball-position :x) 200.0)
          (set state 0)))

    # Draw
    (jay/begin-drawing)
    (jay/clear-background :ray-white)

    (jay/draw-circle-v ball-position ball-radius ball-color)
    (jay/draw-text "PRESS SPACE to RESTART" 10 10 20 :light-gray)

    (jay/end-drawing))

  (jay/close-window)))
