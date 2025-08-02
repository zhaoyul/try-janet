(import jaylib :as jay)
(import spork/randgen :as rand)

(def screen-width 800)
(def screen-height 450)

(def max-buildings 100)

(ffi/context nil)
(ffi/defbind Fade [:u8 :u8 :u8 :u8] [color [:u8 :u8 :u8 :u8] alpha :float])



(defn main [& args]
  (jay/init-window screen-width screen-height "raylib [core] example - 2d camera")

  (var player @{:x 400 :y 280 :width 40 :height 40})
  (var buildings (array/new max-buildings))
  (var build-colors (array/new max-buildings))

  (var spacing 0)

  (each i (range  max-buildings)
    (put-in buildings [i :width] (rand/rand-int 50 200))
    (put-in buildings [i :height] (rand/rand-int 100 800))
    (put-in buildings [i :y] (- screen-height 130.0 (get-in buildings [i :height])))
    (put-in buildings [i :x] (+ -6000.0 spacing))
    (set spacing (+ spacing (get-in buildings [i :width]))))

  (each i (range max-buildings)
    (put build-colors i
         [
           (rand/rand-int 200 240)
           (rand/rand-int 200 240)
           (rand/rand-int 200 250)
           255]))

  (var camera
       (jay/camera-2d
         :target [(+ (player :x) 20.0) (+ (player :y) 20.0)]
         :offset [(/ screen-width 2.0) (/ screen-height 2.0)]
         :rotation 0.0
         :zoom 1.0))

  (jay/set-target-fps 60)

  (while (not (jay/window-should-close))
    # Update
    (when (jay/key-down? :right) (update player :x (fn [x] (+ x 2))))
    (when (jay/key-down? :left) (update player :x (fn [x] (- x 2))))

    (set (camera :target)  [(+ (player :x) 20)  (+ (player :y) 20)])

    (if (jay/key-down? :a) (update camera :rotation |(- $ 1)))
    (if (jay/key-down? :s) (update camera :rotation |(+ $ 1)))

    (when (< (camera :rotation) -40) (set (camera :rotation) -40))
    (when (> (camera :rotation) 40) (set (camera :rotation) 40))

    (update camera :zoom |(+ $ (* (jay/get-mouse-wheel-move) 0.05)))

    (when (> (camera :zoom) 3.0) (set (camera :zoom) 3.0))
    (when (< (camera :zoom) 0.1) (set (camera :zoom) 0.1))

    (when (jay/key-pressed? :r)
      (set (camera :zoom) 1.0)
      (set (camera :rotation) 0.0))

    # Draw
    (jay/begin-drawing)
    (jay/clear-background :ray-white)

    (jay/begin-mode-2d camera)

    (jay/draw-rectangle -6000 320 13000 8000 :dark-gray)
    (each i (range max-buildings)
      (jay/draw-rectangle-rec (values (get buildings i)) (build-colors i)))
    (jay/draw-rectangle-rec (values player) :red)

    (jay/draw-text "SCREEN AREA" 640 10 20 :red)
    (jay/draw-rectangle 0 0 screen-width 5 :red)
    (jay/draw-rectangle 0 5 5 (- screen-height 10) :red)
    (jay/draw-rectangle (- screen-width 5) 5 5 (- screen-height 10) :red)
    (jay/draw-rectangle 0 (- screen-height 5) screen-width 5 :red)

    (var sky-blue [135 206 235 255])

    (jay/draw-rectangle 10 10 250 113 :sky-blue)
    (jay/draw-rectangle-lines 10 10 250 113 :blue)

    (jay/draw-text "Free 2d camera controls:" 20 20 10 :black)
    (jay/draw-text "- Right/Left to move Offset" 40 40 10 :dark-gray)
    (jay/draw-text "- Mouse Wheel to Zoom in/out" 40 60 10 :dark-gray)
    (jay/draw-text "- A / S to Rotate" 40 80 10 :dark-gray)
    (jay/draw-text "- R to reset Zoom and Rotation" 40 100 10 :dark-gray)

    (jay/end-drawing))

  (jay/close-window))
