(import jaylib :as jay)
(import jaylib/rlgl :as rl)

(def screen-width 800)
(def screen-height 450)

(defn main [& args]
  (jay/init-window screen-width screen-height "raylib [models] example - rlgl solar system")

  (var camera
       (jay/camera-3d
         :position @{:x 16.0 :y 16.0 :z 16.0}
         :target @{:x 0.0 :y 0.0 :z 0.0}
         :up @{:x 0.0 :y 1.0 :z 0.0}
         :fovy 45.0
         :projection :perspective))

  (var sun-radius 4.0)
  (var earth-radius 1.0)
  (var earth-distance 10.0)
  (var moon-radius 0.25)
  (var moon-distance 2.0)

  (var rotation-speed 0.2)
  (var earth-orbit-speed 0.5)
  (var moon-orbit-speed 2.0)

  (var angle 0.0)

  (jay/set-target-fps 60)

  (while (not (jay/window-should-close))
    # Update
    (set angle (+ angle (* rotation-speed (jay/get-frame-time))))

    # Draw
    (jay/begin-drawing)
    (jay/clear-background :ray-white)

    (jay/with-mode-3d camera
      (rl/push-matrix)
      (rl/rotate-f 0 1 0 (* angle 30))
      (jay/draw-sphere @{:x 0 :y 0 :z 0} sun-radius :gold)

      (rl/push-matrix)
      (rl/rotate-f 0 1 0 (* angle earth-orbit-speed))
      (rl/translate-f earth-distance 0 0)
      (jay/draw-sphere @{:x 0 :y 0 :z 0} earth-radius :blue)

      (rl/push-matrix)
      (rl/rotate-f 0 1 0 (* angle moon-orbit-speed))
      (rl/translate-f moon-distance 0 0)
      (jay/draw-sphere @{:x 0 :y 0 :z 0} moon-radius :light-gray)
      (rl/pop-matrix)
      (rl/pop-matrix)
      (rl/pop-matrix))

    (jay/draw-text "Solar System" 10 10 20 :dark-gray)
    (jay/draw-fps 10 30)

    (jay/end-drawing))

  (jay/close-window)))
