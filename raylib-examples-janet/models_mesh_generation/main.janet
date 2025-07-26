(import jaylib :as jay)

(def screen-width 800)
(def screen-height 450)

(defn main [& args]
  (jay/init-window screen-width screen-height "raylib [models] example - mesh generation")

  (var camera
       (jay/camera-3d
         :position @{:x 0.0 :y 10.0 :z 10.0}
         :target @{:x 0.0 :y 0.0 :z 0.0}
         :up @{:x 0.0 :y 1.0 :z 0.0}
         :fovy 45.0
         :projection :perspective))

  (def models
    (array
      (jay/load-model-from-mesh (jay/gen-mesh-plane 2 2 5 5))
      (jay/load-model-from-mesh (jay/gen-mesh-cube 2.0 1.0 2.0))
      (jay/load-model-from-mesh (jay/gen-mesh-sphere 2.0 32 32))
      (jay/load-model-from-mesh (jay/gen-mesh-hemi-sphere 2.0 16 16))
      (jay/load-model-from-mesh (jay/gen-mesh-cylinder 1.0 2.0 16))
      (jay/load-model-from-mesh (jay/gen-mesh-torus 0.25 4.0 16 32))
      (jay/load-model-from-mesh (jay/gen-mesh-knot 1.0 2.0 16 128))))

  (var current-model 0)

  (jay/set-target-fps 60)

  (while (not (jay/window-should-close))
    # Update
    (jay/update-camera& camera)

    (when (jay/is-mouse-button-pressed :right)
      (set current-model (if (>= (inc current-model) (length models)) 0 (inc current-model))))

    # Draw
    (jay/begin-drawing)
    (jay/clear-background :ray-white)

    (jay/with-mode-3d camera
      (jay/draw-model (models current-model) @{:x 0 :y 0 :z 0} 1.0 :white)
      (jay/draw-grid 10 1.0))

    (jay/draw-text "Right-click to cycle through meshes" 20 20 20 :gray)
    (jay/draw-text (case current-model
                     0 "Plane"
                     1 "Cube"
                     2 "Sphere"
                     3 "HemiSphere"
                     4 "Cylinder"
                     5 "Torus"
                     6 "Knot")
                   (- (/ screen-width 2) 40) (- screen-height 40) 20 :gray)

    (jay/draw-fps 10 10)
    (jay/end-drawing))

  (for model models (jay/unload-model model))
  (jay/close-window)))
