(import jaylib :as jay)
(import jaylib/math :as jmath)

(def screen-width 800)
(def screen-height 450)

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

    (def angle-left (jmath/atan2 (- (mouse-pos :y) (sclera-left-pos :y)) (- (mouse-pos :x) (sclera-left-pos :x))))
    (def angle-right (jmath/atan2 (- (mouse-pos :y) (sclera-right-pos :y)) (- (mouse-pos :x) (sclera-right-pos :x))))

    (set (iris-left-pos :x) (+ (sclera-left-pos :x) (* (jmath/cos angle-left) 20)))
    (set (iris-left-pos :y) (+ (sclera-left-pos :y) (* (jmath/sin angle-left) 20)))

    (set (iris-right-pos :x) (+ (sclera-right-pos :x) (* (jmath/cos angle-right) 20)))
    (set (iris-right-pos :y) (+ (sclera-right-pos :y) (* (jmath/sin angle-right) 20)))

    # Draw
    (jay/begin-drawing)
    (jay/clear-background :ray-white)

    (jay/draw-circle-v sclera-left-pos 80 :light-gray)
    (jay/draw-circle-v iris-left-pos 25 :brown)
    (jay/draw-circle-v iris-left-pos 10 :black)

    (jay/draw-circle-v sclera-right-pos 80 :light-gray)
    (jay/draw-circle-v iris-right-pos 25 :brown)
    (jay/draw-circle-v iris-right-pos 10 :black)

    (jay/end-drawing))

  (jay/close-window)))
