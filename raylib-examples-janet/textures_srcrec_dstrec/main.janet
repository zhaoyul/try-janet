(import jaylib :as jay)

(def screen-width 800)
(def screen-height 450)

(defn main [& args]
  (jay/init-window screen-width screen-height "raylib [textures] example - source and destination rectangles")

  (def scarfy (jay/load-texture "resources/scarfy.png"))

  (def frame-width (/ (scarfy :width) 6.0))
  (def frame-height (scarfy :height))

  (def src-rec @{:x frame-width :y 0.0 :width frame-width :height frame-height})
  (def dest-rec @{:x (/ screen-width 2.0) :y (/ screen-height 2.0) :width (* frame-width 2) :height (* frame-height 2)})
  (def origin @{:x frame-width :y frame-height})

  (var rotation 0.0)

  (jay/set-target-fps 60)

  (while (not (jay/window-should-close))
    # Update
    (set rotation (inc rotation))

    # Draw
    (jay/begin-drawing)
    (jay/clear-background :ray-white)

    (jay/draw-texture-pro scarfy src-rec dest-rec origin rotation :white)

    (jay/draw-line (dest-rec :x) 0 (dest-rec :x) screen-height :gray)
    (jay/draw-line 0 (dest-rec :y) screen-width (dest-rec :y) :gray)

    (jay/draw-text "(c) Scarfy art by Eiden Marsal" (- screen-width 200) (- screen-height 20) 10 :gray)

    (jay/end-drawing))

  (jay/unload-texture scarfy)
  (jay/close-window)))
