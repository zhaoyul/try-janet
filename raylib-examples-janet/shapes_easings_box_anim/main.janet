(import jaylib :as jay)
(import jaylib/easing :as easing)

(def screen-width 800)
(def screen-height 450)

(defn main [& args]
  (jay/init-window screen-width screen-height "raylib [shapes] example - easings box anim")

  (var box-rec @{:x -100.0 :y 200.0 :width 100.0 :height 100.0})
  (var rotation 0.0)
  (var alpha 1.0)

  (var state 0)
  (var frames-counter 0)

  (jay/set-target-fps 60)

  (while (not (jay/window-should-close))
    # Update
    (case state
      0 (do
          (set frames-counter (inc frames-counter))
          (set (box-rec :x) (easing/out-elastic frames-counter -100.0 (+ (/ screen-width 2.0) 100) 120))
          (when (= frames-counter 120)
            (set state 1)
            (set frames-counter 0)))
      1 (when (jay/is-key-pressed :space)
          (set frames-counter 0)
          (set (box-rec :x) -100.0)
          (set state 0)))

    # Draw
    (jay/begin-drawing)
    (jay/clear-background :ray-white)

    (jay/draw-rectangle-pro box-rec @{:x (/ (box-rec :width) 2) :y (/ (box-rec :height) 2)} rotation (jay/fade :blue alpha))
    (jay/draw-text "PRESS SPACE to RESTART" 10 10 20 :light-gray)

    (jay/end-drawing))

  (jay/close-window)))
