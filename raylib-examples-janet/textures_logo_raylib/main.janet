(import jaylib :as jay)

(def screen-width 800)
(def screen-height 450)

(defn main [& args]
  (jay/init-window screen-width screen-height "raylib [textures] example - logo texture")

  (def texture (jay/load-texture "resources/raylib_logo.png"))

  (jay/set-target-fps 60)

  (while (not (jay/window-should-close))
    (jay/begin-drawing)
    (jay/clear-background :ray-white)

    (jay/draw-texture texture (- (/ screen-width 2) (/ (texture :width) 2)) (- (/ screen-height 2) (/ (texture :height) 2)) :white)
    (jay/draw-text "this is a texture!" 360 370 10 :gray)

    (jay/end-drawing))

  (jay/unload-texture texture)
  (jay/close-window)))
