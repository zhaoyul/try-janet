(import jaylib :as jay)
(import jaylib/math :as jmath)

(def screen-width 800)
(def screen-height 450)

(defn main [& args]
  (jay/init-window screen-width screen-height "raylib [models] example - box collisions")

  (var camera
       (jay/camera-3d
         :position @{:x 0.0 :y 10.0 :z 10.0}
         :target @{:x 0.0 :y 0.0 :z 0.0}
         :up @{:x 0.0 :y 1.0 :z 0.0}
         :fovy 45.0
         :projection :perspective))

  (var player-position @{:x 0.0 :y 1.0 :z 2.0})
  (def player-size @{:x 2.0 :y 2.0 :z 2.0})
  (def player-color :white)

  (def enemy-box-pos @{:x -4.0 :y 1.0 :z 2.0})
  (def enemy-box-size @{:x 2.0 :y 2.0 :z 2.0})

  (def enemy-sphere-pos @{:x 4.0 :y 0.0 :z 2.0})
  (def enemy-sphere-size 1.5)

  (var collision false)

  (jay/set-target-fps 60)

  (while (not (jay/window-should-close))
    # Update
    (when (jay/is-key-down :up) (update player-position :z #(- % 0.2)))
    (when (jay/is-key-down :down) (update player-position :z #(+ % 0.2)))
    (when (jay/is-key-down :left) (update player-position :x #(- % 0.2)))
    (when (jay/is-key-down :right) (update player-position :x #(+ % 0.2)))

    (set collision false)

    (def player-bbox
      (jay/bounding-box
        (jmath/vector3-subtract player-position (jmath/vector3-scale player-size 0.5))
        (jmath/vector3-add player-position (jmath/vector3-scale player-size 0.5))))

    (def enemy-bbox
      (jay/bounding-box
        (jmath/vector3-subtract enemy-box-pos (jmath/vector3-scale enemy-box-size 0.5))
        (jmath/vector3-add enemy-box-pos (jmath/vector3-scale enemy-box-size 0.5))))

    (if (jay/check-collision-boxes player-bbox enemy-bbox) (set collision true))
    (if (jay/check-collision-box-sphere player-bbox enemy-sphere-pos enemy-sphere-size) (set collision true))

    (if collision (set player-color :red) (set player-color :white))

    # Draw
    (jay/begin-drawing)
    (jay/clear-background :ray-white)

    (jay/with-mode-3d camera
      (jay/draw-cube-v player-position player-size player-color)
      (jay/draw-cube-wires-v player-position player-size :dark-gray)

      (jay/draw-cube-v enemy-box-pos enemy-box-size :gray)
      (jay/draw-sphere-ex enemy-sphere-pos enemy-sphere-size 8 8 :gray)

      (jay/draw-grid 10 1.0))

    (jay/draw-text "Move player with arrow keys to collide" 220 40 20 :gray)
    (if collision
      (jay/draw-text "COLLISION!" 280 80 40 :red)
      (jay/draw-text "NO COLLISION" 280 80 40 :gray))

    (jay/draw-fps 10 10)
    (jay/end-drawing))

  (jay/close-window)))
