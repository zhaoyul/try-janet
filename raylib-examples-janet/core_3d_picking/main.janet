(import jaylib :as jay)
(import jaylib/math :as jmath)

(def screen-width 800)
(def screen-height 450)

(defn main [& args]
  (jay/init-window screen-width screen-height "raylib [core] example - 3d picking")

  (var camera
       (jay/camera-3d
         :position @{:x 10.0 :y 10.0 :z 10.0}
         :target @{:x 0.0 :y 0.0 :z 0.0}
         :up @{:x 0.0 :y 1.0 :z 0.0}
         :fovy 45.0
         :projection :perspective))

  (def cube-position @{:x 0.0 :y 1.0 :z 0.0})
  (def cube-size @{:x 2.0 :y 2.0 :z 2.0})

  (var ray (jay/ray @{:x 0 :y 0 :z 0} @{:x 0 :y 0 :z 0}))
  (var collision (jay/ray-collision false 0.0 @{:x 0 :y 0 :z 0} @{:x 0 :y 0 :z 0}))

  (jay/set-target-fps 60)

  (while (not (jay/window-should-close))
    # Update
    (if (jay/is-cursor-hidden) (jay/update-camera& camera :first-person))

    (when (jay/is-mouse-button-pressed :right)
      (if (jay/is-cursor-hidden) (jay/enable-cursor) (jay/disable-cursor)))

    (when (jay/is-mouse-button-pressed :left)
      (if (not (collision :hit))
        (do
          (set ray (jay/get-screen-to-world-ray (jay/get-mouse-position) camera))
          (def min-vec @{:x (- (cube-position :x) (/ (cube-size :x) 2))
                         :y (- (cube-position :y) (/ (cube-size :y) 2))
                         :z (- (cube-position :z) (/ (cube-size :z) 2))})
          (def max-vec @{:x (+ (cube-position :x) (/ (cube-size :x) 2))
                         :y (+ (cube-position :y) (/ (cube-size :y) 2))
                         :z (+ (cube-position :z) (/ (cube-size :z) 2))})
          (set collision (jay/get-ray-collision-box ray (jay/bounding-box min-vec max-vec))))
        (set (collision :hit) false)))

    # Draw
    (jay/begin-drawing)
    (jay/clear-background :ray-white)

    (jay/with-mode-3d camera
      (if (collision :hit)
        (do
          (jay/draw-cube cube-position (cube-size :x) (cube-size :y) (cube-size :z) :red)
          (jay/draw-cube-wires cube-position (cube-size :x) (cube-size :y) (cube-size :z) :maroon)
          (jay/draw-cube-wires cube-position (+ (cube-size :x) 0.2) (+ (cube-size :y) 0.2) (+ (cube-size :z) 0.2) :green))
        (do
          (jay/draw-cube cube-position (cube-size :x) (cube-size :y) (cube-size :z) :gray)
          (jay/draw-cube-wires cube-position (cube-size :x) (cube-size :y) (cube-size :z) :dark-gray)))

      (jay/draw-ray ray :maroon)
      (jay/draw-grid 10 1.0))

    (jay/draw-text "Try clicking on the box with your mouse!" 240 10 20 :dark-gray)

    (if (collision :hit)
      (jay/draw-text "BOX SELECTED" (/ (- screen-width (jay/measure-text "BOX SELECTED" 30)) 2) (math/floor (* screen-height 0.1)) 30 :green))

    (jay/draw-text "Right click mouse to toggle camera controls" 10 430 10 :gray)
    (jay/draw-fps 10 10)
    (jay/end-drawing))

  (jay/close-window)))
