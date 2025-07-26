(import jaylib :as jay)

(def screen-width 800)
(def screen-height 450)

(defn main [& args]
  (jay/init-window screen-width screen-height "raylib [textures] example - texture rectangle")

  (def scarfy (jay/load-texture "resources/scarfy.png"))

  (def frame-width (/ (scarfy :width) 6.0))
  (def frame-height (scarfy :height))

  (var frame-rec @{:x 0.0 :y 0.0 :width frame-width :height frame-height})
  (var position @{:x 350.0 :y 280.0})

  (var frame-counter 0)
  (var current-frame 0)
  (var frame-speed 8)

  (jay/set-target-fps 60)

  (while (not (jay/window-should-close))
    # Update
    (set frame-counter (inc frame-counter))

    (when (>= frame-counter (/ 60 frame-speed))
      (set frame-counter 0)
      (set current-frame (if (> (inc current-frame) 5) 0 (inc current-frame)))
      (set (frame-rec :x) (* current-frame frame-width)))

    # Draw
    (jay/begin-drawing)
    (jay/clear-background :ray-white)

    (jay/draw-texture scarfy 15 40 :white)
    (jay/draw-rectangle-lines 15 40 (scarfy :width) (scarfy :height) :lime)
    (jay/draw-rectangle-lines (+ 15 (frame-rec :x)) (+ 40 (frame-rec :y)) (frame-rec :width) (frame-rec :height) :red)

    (jay/draw-text "FRAME SPEED: " 165 210 10 :dark-gray)
    (jay/draw-text (string/format "%02d FPS" frame-speed) 575 210 10 :dark-gray)

    (set frame-speed (jay/slider-bar @{:x 255 :y 205 :width 300 :height 20} "" "" frame-speed 1 25))

    (jay/draw-rectangle-rec @{:x 15 :y 310 :width (- screen-width 30) :height 100} (jay/fade :sky-blue 0.5))
    (jay/draw-rectangle-lines 15 310 (- screen-width 30) 100 :blue)

    (jay/draw-text "PRESS [<-] and [->] to CHANGE SPEED!" 240 330 10 :dark-gray)

    (jay/draw-texture-rec scarfy frame-rec position :white)

    (jay/end-drawing))

  (jay/unload-texture scarfy)
  (jay/close-window)))
