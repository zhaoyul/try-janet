(import jaylib :as jay)

(def screen-width 800)
(def screen-height 450)

(defn main [& args]
  (jay/init-window screen-width screen-height "raylib [models] example - geometric shapes")

  (var camera
       (jay/camera-3d
         :position @{:x 0.0 :y 10.0 :z 10.0}
         :target @{:x 0.0 :y 0.0 :z 0.0}
         :up @{:x 0.0 :y 1.0 :z 0.0}
         :fovy 45.0
         :projection :perspective))

  (jay/set-target-fps 60)

  (while (not (jay/window-should-close))
    # Update
    (jay/update-camera& camera)

    # Draw
    (jay/begin-drawing)
    (jay/clear-background :ray-white)

    (jay/with-mode-3d camera
      (jay/draw-cube @{:x -4.0 :y 0.0 :z 2.0} 2.0 2.0 2.0 :red)
      (jay/draw-cube-wires @{:x -4.0 :y 0.0 :z 2.0} 2.0 2.0 2.0 :maroon)
      (jay/draw-cube @{:x -4.0 :y 0.0 :z -2.0} 2.0 2.0 2.0 :dark-green)

      (jay/draw-sphere @{:x -2.0 :y 0.0 :z -2.0} 1.0 :blue)
      (jay/draw-sphere-wires @{:x -2.0 :y 0.0 :z 2.0} 1.0 16 16 :dark-blue)

      (jay/draw-cylinder @{:x 0.0 :y 0.0 :z -4.0} 1.0 1.0 2.0 16 :gold)
      (jay/draw-cylinder-wires @{:x 0.0 :y 0.0 :z -2.0} 0.0 1.0 2.0 16 :brown)

      (jay/draw-plane @{:x 0.0 :y -1.0 :z 0.0} @{:x 10.0 :y 10.0} :light-gray)
      (jay/draw-ray @{:x 0 :y 0 :z 0} @{:x 1 :y 1 :z 1} :maroon))

    (jay/draw-fps 10 10)
    (jay/end-drawing))

  (jay/close-window)))
