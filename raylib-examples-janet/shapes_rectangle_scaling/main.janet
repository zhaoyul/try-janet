(import jaylib :as jay)

(def screen-width 800)
(def screen-height 450)

(defn main [& args]
  (jay/init-window screen-width screen-height "raylib [shapes] example - rectangle scaling")

  (var rec @{:x 100.0 :y 100.0 :width 200.0 :height 80.0})
  (var mouse-scale-mode :none)

  (jay/set-target-fps 60)

  (while (not (jay/window-should-close))
    # Update
    (def mouse-pos (jay/get-mouse-position))

    (if (and (jay/check-collision-point-rec mouse-pos rec)
             (not= mouse-scale-mode :scale))
      (set mouse-scale-mode :move)
      (set mouse-scale-mode :none))

    (when (jay/check-collision-point-rec mouse-pos @{:x (+ (rec :x) (rec :width) - 20)
                                                     :y (+ (rec :y) (rec :height) - 20)
                                                     :width 20 :height 20})
      (set mouse-scale-mode :scale))

    (case mouse-scale-mode
      :move (when (jay/is-mouse-button-down :left)
              (update rec :x #(+ % ((jay/get-mouse-delta) :x)))
              (update rec :y #(+ % ((jay/get-mouse-delta) :y))))
      :scale (when (jay/is-mouse-button-down :left)
               (update rec :width #(+ % ((jay/get-mouse-delta) :x)))
               (update rec :height #(+ % ((jay/get-mouse-delta) :y)))))

    # Draw
    (jay/begin-drawing)
    (jay/clear-background :ray-white)

    (jay/draw-rectangle-rec rec (jay/fade :green 0.5))
    (jay/draw-rectangle-lines-ex rec 2 :black)

    (when (= mouse-scale-mode :scale)
      (jay/draw-rectangle-rec @{:x (+ (rec :x) (rec :width) - 20)
                                :y (+ (rec :y) (rec :height) - 20)
                                :width 20 :height 20} :red))

    (jay/draw-text "Scale rectangle with mouse" 10 10 20 :gray)
    (jay/end-drawing))

  (jay/close-window)))
