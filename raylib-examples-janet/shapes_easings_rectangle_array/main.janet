(import jaylib :as jay)
(import jaylib/easing :as easing)

(def screen-width 800)
(def screen-height 450)

(def recs-width 50)
(def recs-height 50)
(def max-recs-x (// screen-width recs-width))
(def max-recs-y (// screen-height recs-height))

(def play-time-in-frames 240)

(defn main [& args]
  (jay/init-window screen-width screen-height "raylib [shapes] example - easings rectangle array")

  (var recs (array/new-filled (* max-recs-x max-recs-y) @{}))

  (for y 0 max-recs-y
    (for x 0 max-recs-x
      (def i (+ (* y max-recs-x) x))
      (put-in recs [i :x] (+ (/ recs-width 2.0) (* recs-width x)))
      (put-in recs [i :y] (+ (/ recs-height 2.0) (* recs-height y)))
      (put-in recs [i :width] recs-width)
      (put-in recs [i :height] recs-height)))

  (var rotation 0.0)
  (var frames-counter 0)
  (var state 0)

  (jay/set-target-fps 60)

  (while (not (jay/window-should-close))
    # Update
    (if (= state 0)
      (do
        (set frames-counter (inc frames-counter))
        (for i 0 (* max-recs-x max-recs-y)
          (put-in recs [i :height] (easing/circ-out frames-counter recs-height (- recs-height) play-time-in-frames))
          (put-in recs [i :width] (easing/circ-out frames-counter recs-width (- recs-width) play-time-in-frames))

          (when (< (get-in recs [i :height]) 0) (put-in recs [i :height] 0))
          (when (< (get-in recs [i :width]) 0) (put-in recs [i :width] 0))

          (when (and (= (get-in recs [i :height]) 0) (= (get-in recs [i :width]) 0))
            (set state 1))

          (set rotation (easing/linear-in frames-counter 0.0 360.0 play-time-in-frames))))
      (if (and (= state 1) (jay/is-key-pressed :space))
        (do
          (set frames-counter 0)
          (for i 0 (* max-recs-x max-recs-y)
            (put-in recs [i :height] recs-height)
            (put-in recs [i :width] recs-width))
          (set state 0))))

    # Draw
    (jay/begin-drawing)
    (jay/clear-background :ray-white)

    (if (= state 0)
      (for i 0 (* max-recs-x max-recs-y)
        (jay/draw-rectangle-pro (recs i) @{:x (/ ((recs i) :width) 2) :y (/ ((recs i) :height) 2)} rotation :red))
      (if (= state 1)
        (jay/draw-text "PRESS [SPACE] TO PLAY AGAIN!" 240 200 20 :gray)))

    (jay/end-drawing))

  (jay/close-window)))
