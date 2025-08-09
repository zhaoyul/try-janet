(import jaylib :as jay)
(import jaylib/math :as jmath)

(def screen-width 800)
(def screen-height 450)

(defn main [& args]
  (jay/init-window screen-width screen-height "raylib [core] example - 3d picking")

  (var camera
    (jay/camera-3d
      :position [10.0 10.0 10.0]
      :target [0.0 0.0  0.0]
      :up [0.0 1.0 0.0]
      :fovy 45.0
      :type :perspective))

  (def cube-position @{:x 0.0 :y 1.0 :z 0.0})
  (def cube-size @{:x 2.0 :y 2.0 :z 2.0})

  (var ray @[@[0  0 0] @[0 0 0]])
  (var collision @[1])

  (jay/set-target-fps 60)

  (while (not (jay/window-should-close))
    # Update
    (if (jay/cursor-hidden?) (jay/update-camera camera :first-person))

    (when (jay/mouse-button-pressed? :right)
      (if (jay/cursor-hidden?) (jay/enable-cursor) (jay/disable-cursor)))

    (when (jay/mouse-button-pressed? :left)
      (if (zero? (first collision))
        (do
          # Get the mouse ray
          (def mouse-ray (jay/get-mouse-ray (jay/get-mouse-position) camera))
          (put-in ray [0] (mouse-ray :position))
          (put-in ray [1] (mouse-ray :direction))

          # Check ray collision with bounding box
          (def min-vec @{:x (- (cube-position :x) (/ (cube-size :x) 2))
                         :y (- (cube-position :y) (/ (cube-size :y) 2))
                         :z (- (cube-position :z) (/ (cube-size :z) 2))})
          (def max-vec @{:x (+ (cube-position :x) (/ (cube-size :x) 2))
                         :y (+ (cube-position :y) (/ (cube-size :y) 2))
                         :z (+ (cube-position :z) (/ (cube-size :z) 2))})
          (def collision-info (jay/get-ray-collision-box (values ray) [(values min-vec) (values max-vec)]))
          (when (collision-info :hit)
            (put-in collision [0] 1)))
        (put-in collision [0] 0)))

    # Draw
    (jay/begin-drawing)
    (jay/clear-background :ray-white)

    (jay/begin-mode-3d camera)
    (if (not (zero? (first collision)))
      (do
        (jay/draw-cube (values cube-position) (cube-size :x) (cube-size :y) (cube-size :z) :red)
        (jay/draw-cube-wires (values cube-position) (cube-size :x) (cube-size :y) (cube-size :z) :maroon)
        (jay/draw-cube-wires (values cube-position) (+ (cube-size :x) 0.2) (+ (cube-size :y) 0.2) (+ (cube-size :z) 0.2) :green))
      (do
        (jay/draw-cube (values cube-position) (cube-size :x) (cube-size :y) (cube-size :z) :gray)
        (jay/draw-cube-wires (values cube-position) (cube-size :x) (cube-size :y) (cube-size :z) :dark-gray)))

    (jay/draw-ray (values ray) :maroon)
    (jay/draw-grid 10 1.0)
    (jay/end-mode-3d)

    (jay/draw-text "Try clicking on the box with your mouse!" 240 10 20 :dark-gray)

    (if (not (zero? (first collision)))
      (jay/draw-text "BOX SELECTED"
                     (/ (- screen-width (jay/measure-text "BOX SELECTED" 30)) 2)
                     (math/floor (* screen-height 0.1)) 30 :green))

    (jay/draw-text "Right click mouse to toggle camera controls" 10 430 10 :gray)
    (jay/draw-fps 10 10)
    (jay/end-drawing))

  (jay/close-window))
