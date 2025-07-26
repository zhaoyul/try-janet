(import jaylib :as jay)

(def screen-width 800)
(def screen-height 450)

(defn main [& args]
  (jay/init-window screen-width screen-height "raylib [textures] example - draw tiled")

  (def texture (jay/load-texture "resources/cyberpunk_street_map.png"))
  (jay/set-texture-wrap texture :repeat)

  (var frame-rec @{:x 0.0 :y 0.0 :width (texture :width) :height (texture :height)})
  (var position @{:x 0.0 :y 0.0})

  (jay/set-target-fps 60)

  (while (not (jay/window-should-close))
    # Update
    (if (jay/is-key-down :right) (update frame-rec :width (fn [w] (+ w 2.0))))
    (if (jay/is-key-down :left) (update frame-rec :width (fn [w] (- w 2.0))))
    (if (jay/is-key-down :up) (update frame-rec :height (fn [h] (+ h 2.0))))
    (if (jay/is-key-down :down) (update frame-rec :height (fn [h] (- h 2.0))))

    # Draw
    (jay/begin-drawing)
    (jay/clear-background :ray-white)

    (jay/draw-texture-rec texture frame-rec position :white)
    (jay/draw-text "Use arrow keys to change tile size" 10 10 20 :gray)

    (jay/end-drawing))

  (jay/unload-texture texture)
  (jay/close-window)))
