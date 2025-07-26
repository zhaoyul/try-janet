(import jaylib :as jay)

(def screen-width 800)
(def screen-height 450)

(defn main [& args]
  (jay/init-window screen-width screen-height "raylib [shapes] example - raylib logo animation")

  (var logo-position-x (- (/ screen-width 2) 128))
  (var logo-position-y (- (/ screen-height 2) 128))

  (var frames-counter 0)
  (var letters-count 0)

  (var top-side-rec-width 16)
  (var left-side-rec-height 16)

  (var bottom-side-rec-width 16)
  (var right-side-rec-height 16)

  (var state 0)
  (var alpha 1.0)

  (jay/set-target-fps 60)

  (while (not (jay/window-should-close))
    # Update
    (case state
      0 (do
          (set frames-counter (inc frames-counter))
          (when (= frames-counter 120)
            (set state 1)
            (set frames-counter 0)))
      1 (do
          (update top-side-rec-width #(* % 1.025))
          (when (> top-side-rec-width 256) (set top-side-rec-width 256))
          (when (= top-side-rec-width 256)
            (set state 2)))
      2 (do
          (update left-side-rec-height #(* % 1.025))
          (when (> left-side-rec-height 256) (set left-side-rec-height 256))
          (when (= left-side-rec-height 256)
            (set state 3)))
      3 (do
          (update bottom-side-rec-width #(* % 1.025))
          (when (> bottom-side-rec-width 256) (set bottom-side-rec-width 256))
          (when (= bottom-side-rec-width 256)
            (set state 4)))
      4 (do
          (update right-side-rec-height #(* % 1.025))
          (when (> right-side-rec-height 256) (set right-side-rec-height 256))
          (when (= right-side-rec-height 256)
            (set state 5)))
      5 (do
          (set frames-counter (inc frames-counter))
          (when (= (// frames-counter 12) 1)
            (set letters-count (inc letters-count))
            (set frames-counter 0))
          (when (= letters-count 10)
            (set state 6)))
      6 (do
          (set frames-counter (inc frames-counter))
          (when (>= frames-counter 60)
            (set alpha (- alpha 0.02))
            (when (< alpha 0.0)
              (set alpha 0.0)
              (set state 7))))
      7 (do
          (when (jay/is-key-pressed :enter)
            (set frames-counter 0)
            (set letters-count 0)
            (set top-side-rec-width 16)
            (set left-side-rec-height 16)
            (set bottom-side-rec-width 16)
            (set right-side-rec-height 16)
            (set state 0)
            (set alpha 1.0))))

    # Draw
    (jay/begin-drawing)
    (jay/clear-background :ray-white)

    (if (>= state 0)
      (jay/draw-rectangle logo-position-x logo-position-y 16 top-side-rec-width (jay/fade :black alpha)))
    (if (>= state 1)
      (jay/draw-rectangle logo-position-x logo-position-y top-side-rec-width 16 (jay/fade :black alpha)))
    (if (>= state 2)
      (jay/draw-rectangle logo-position-x logo-position-y 16 left-side-rec-height (jay/fade :black alpha)))
    (if (>= state 3)
      (jay/draw-rectangle logo-position-x (+ logo-position-y 240) bottom-side-rec-width 16 (jay/fade :black alpha)))
    (if (>= state 4)
      (jay/draw-rectangle (+ logo-position-x 240) logo-position-y 16 right-side-rec-height (jay/fade :black alpha)))
    (if (>= state 5)
      (jay/draw-rectangle (- (/ screen-width 2) 112) (- (/ screen-height 2) 112) 224 224 (jay/fade :ray-white alpha)))
    (if (>= state 6)
      (jay/draw-text (string/slice "raylib" 0 letters-count) (- (/ screen-width 2) 44) (+ (/ screen-height 2) 48) 50 (jay/fade :black alpha)))
    (if (= state 7)
      (jay/draw-text "[R] REPLAY" 340 200 20 :gray))

    (jay/end-drawing))

  (jay/close-window)))
