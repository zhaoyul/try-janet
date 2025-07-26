(import jaylib :as jay)

(def screen-width 800)
(def screen-height 450)

(defn main [& args]
  (jay/init-window screen-width screen-height "raylib [core] example - 3d camera mode")

  (var camera
       (jay/camera-3d
         :position @{:x 0.0 :y 10.0 :z 10.0}
         :target @{:x 0.0 :y 0.0 :z 0.0}
         :up @{:x 0.0 :y 1.0 :z 0.0}
         :fovy 45.0
         :projection :perspective))

  (var cube-position @{:x 0.0 :y 0.0 :z 0.0})

  (jay/set-camera-mode camera :free)

  (jay/set-target-fps 60)

  (while (not (jay/window-should-close))
    # Update
    (jay/update-camera& camera)

    (when (jay/is-key-pressed :z)
      (jay/set-camera-mode camera :orbital))

    (when (jay/is-key-pressed :x)
      (jay/set-camera-mode camera :first-person))

    (when (jay/is-key-pressed :c)
      (jay/set-camera-mode camera :third-person))

    (when (jay/is-key-pressed :v)
      (jay/set-camera-mode camera :free))

    # Draw
    (jay/begin-drawing)
    (jay/clear-background :ray-white)

    (jay/with-mode-3d camera
      (jay/draw-cube cube-position 2.0 2.0 2.0 :red)
      (jay/draw-cube-wires cube-position 2.0 2.0 2.0 :maroon)
      (jay/draw-grid 10 1.0))

    (jay/draw-rectangle 10 10 320 130 (jay/fade :sky-blue 0.5))
    (jay/draw-rectangle-lines 10 10 320 130 :blue)

    (jay/draw-text "Camera modes" 20 20 10 :black)
    (jay/draw-text "- Z: Orbital" 40 40 10 :dark-gray)
    (jay/draw-text "- X: First Person" 40 60 10 :dark-gray)
    (jay/draw-text "- C: Third Person" 40 80 10 :dark-gray)
    (jay/draw-text "- V: Free" 40 100 10 :dark-gray)

    (jay/draw-text "Camera movement controls:" 20 150 10 :black)
    (jay/draw-text "- Mouse wheel to zoom in-out" 40 170 10 :dark-gray)
    (jay/draw-text "- Mouse wheel press to pan" 40 190 10 :dark-gray)
    (jay/draw-text "- Alt + Mouse wheel press to rotate" 40 210 10 :dark-gray)
    (jay/draw-text "- Alt + Ctrl + Mouse wheel press for smooth zoom" 40 230 10 :dark-gray)
    (jay/draw-text "- W, A, S, D to move in first-person" 40 250 10 :dark-gray)

    (jay/end-drawing))

  (jay/close-window)))
