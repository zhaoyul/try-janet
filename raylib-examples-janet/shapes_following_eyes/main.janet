(import jaylib :as jay)

(def screen-width 800)
(def screen-height 450)

(ffi/context nil)
(ffi/defbind cosf :float [input :float])
(ffi/defbind sinf :float [input :float])
(ffi/defbind atan2f :float [input1 :float input2 :float])

(defn main [& args]
  (jay/init-window screen-width screen-height "raylib [shapes] example - following eyes")

  (var sclera-left-pos @{:x (/ screen-width 2.0) :y (/ screen-height 2.0)})
  (var sclera-right-pos @{:x (+ (/ screen-width 2.0) 100) :y (/ screen-height 2.0)})
  (var iris-left-pos @{:x (/ screen-width 2.0) :y (/ screen-height 2.0)})
  (var iris-right-pos @{:x (+ (/ screen-width 2.0) 100) :y (/ screen-height 2.0)})

  (jay/set-target-fps 60)

  (while (not (jay/window-should-close))
    # Update
    (def mouse-pos (jay/get-mouse-position))

    (def angle-left (atan2f (- (get mouse-pos 1) (sclera-left-pos :y))
                            (- (get mouse-pos 0) (sclera-left-pos :x))))
    (def angle-right (atan2f (- (get mouse-pos 1) (sclera-right-pos :y))
                             (- (get mouse-pos 0) (sclera-right-pos :x))))

    (set (iris-left-pos :x) (+ (sclera-left-pos :x) (* (cosf angle-left) 20)))
    (set (iris-left-pos :y) (+ (sclera-left-pos :y) (* (sinf angle-left) 20)))

    (set (iris-right-pos :x) (+ (sclera-right-pos :x) (* (cosf angle-right) 20)))
    (set (iris-right-pos :y) (+ (sclera-right-pos :y) (* (sinf angle-right) 20)))

    # Draw
    (jay/begin-drawing)
    (jay/clear-background :ray-white)

    (jay/draw-circle-v (values sclera-left-pos) 80 :light-gray)
    (jay/draw-circle-v (values iris-left-pos) 25 :brown)
    (jay/draw-circle-v (values iris-left-pos) 10 :black)

    (jay/draw-circle-v (values sclera-right-pos) 80 :light-gray)
    (jay/draw-circle-v (values iris-right-pos) 25 :brown)
    (jay/draw-circle-v (values iris-right-pos) 10 :black)

    (jay/end-drawing))

  (jay/close-window))


(comment
  (main)
  )
