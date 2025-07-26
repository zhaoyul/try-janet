(import jaylib :as jay)

(def screen-width 800)
(def screen-height 450)

(defn main [& args]
  (jay/init-window screen-width screen-height "raylib [models] example - model animation")

  (var camera
       (jay/camera-3d
         :position @{:x 10.0 :y 10.0 :z 10.0}
         :target @{:x 0.0 :y 0.0 :z 0.0}
         :up @{:x 0.0 :y 1.0 :z 0.0}
         :fovy 45.0
         :projection :perspective))

  (def model (jay/load-model "resources/guy.iqm"))
  (def texture (jay/load-texture "resources/guytex.png"))
  (jay/set-material-texture (model :materials 0) :diffuse texture)

  (def anims (jay/load-model-animations "resources/guyanim.iqm"))
  (var anim-frame-counter 0)

  (jay/set-target-fps 60)

  (while (not (jay/window-should-close))
    # Update
    (set anim-frame-counter (inc anim-frame-counter))
    (jay/update-model-animation model (anims 0) anim-frame-counter)
    (when (>= anim-frame-counter ((anims 0) :frame-count)) (set anim-frame-counter 0))

    # Draw
    (jay/begin-drawing)
    (jay/clear-background :ray-white)

    (jay/with-mode-3d camera
      (jay/draw-model-ex model @{:x 0 :y 0 :z 0} @{:x 1 :y 0 :z 0} -90.0 @{:x 1 :y 1 :z 1} :white)
      (jay/draw-grid 10 1.0))

    (jay/draw-text "(c) Guy IQM 3D model by @culacant" (- screen-width 200) (- screen-height 20) 10 :gray)

    (jay/end-drawing))

  (jay/unload-model-animations anims)
  (jay/unload-texture texture)
  (jay/unload-model model)
  (jay/close-window)))
