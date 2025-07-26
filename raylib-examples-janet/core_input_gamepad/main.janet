(import jaylib :as jay)
(import string)

(def screen-width 800)
(def screen-height 450)

(def xbox-alias-1 "xbox")
(def xbox-alias-2 "x-box")
(def ps-alias "playstation")

(defn main [& args]
  (jay/set-config-flags :msaa-4x-hint)
  (jay/init-window screen-width screen-height "raylib [core] example - gamepad input")

  (def tex-ps3-pad (jay/load-texture "resources/ps3.png"))
  (def tex-xbox-pad (jay/load-texture "resources/xbox.png"))

  (var gamepad 0)

  (jay/set-target-fps 60)

  (while (not (jay/window-should-close))
    # Update
    (when (and (jay/is-key-pressed :left) (> gamepad 0))
      (set gamepad (- gamepad 1)))
    (when (jay/is-key-pressed :right)
      (set gamepad (+ gamepad 1)))

    # Draw
    (jay/begin-drawing)
    (jay/clear-background :ray-white)

    (if (jay/is-gamepad-available gamepad)
      (do
        (jay/draw-text (string/format "GP%d: %s" gamepad (jay/get-gamepad-name gamepad)) 10 10 10 :black)

        (def gamepad-name (string/ascii-lower (jay/get-gamepad-name gamepad)))

        (if (or (string/find xbox-alias-1 gamepad-name) (string/find xbox-alias-2 gamepad-name))
          (do
            (jay/draw-texture tex-xbox-pad 0 0 :dark-gray)
            # Draw buttons
            (when (jay/is-gamepad-button-down gamepad :middle) (jay/draw-circle 394 89 19 :red))
            (when (jay/is-gamepad-button-down gamepad :middle-right) (jay/draw-circle 436 150 9 :red))
            (when (jay/is-gamepad-button-down gamepad :middle-left) (jay/draw-circle 352 150 9 :red))
            (when (jay/is-gamepad-button-down gamepad :right-face-left) (jay/draw-circle 501 151 15 :blue))
            (when (jay/is-gamepad-button-down gamepad :right-face-down) (jay/draw-circle 536 187 15 :lime))
            (when (jay/is-gamepad-button-down gamepad :right-face-right) (jay/draw-circle 572 151 15 :maroon))
            (when (jay/is-gamepad-button-down gamepad :right-face-up) (jay/draw-circle 536 115 15 :gold))
            # Draw d-pad
            (jay/draw-rectangle 317 202 19 71 :black)
            (jay/draw-rectangle 293 228 69 19 :black)
            (when (jay/is-gamepad-button-down gamepad :left-face-up) (jay/draw-rectangle 317 202 19 26 :red))
            (when (jay/is-gamepad-button-down gamepad :left-face-down) (jay/draw-rectangle 317 (+ 202 45) 19 26 :red))
            (when (jay/is-gamepad-button-down gamepad :left-face-left) (jay/draw-rectangle 292 228 25 19 :red))
            (when (jay/is-gamepad-button-down gamepad :left-face-right) (jay/draw-rectangle (+ 292 44) 228 26 19 :red))
            # Draw triggers
            (when (jay/is-gamepad-button-down gamepad :left-trigger-1) (jay/draw-circle 259 61 20 :red))
            (when (jay/is-gamepad-button-down gamepad :right-trigger-1) (jay/draw-circle 536 61 20 :red))
            # Draw joysticks
            (def left-stick-x (jay/get-gamepad-axis-movement gamepad :left-x))
            (def left-stick-y (jay/get-gamepad-axis-movement gamepad :left-y))
            (def right-stick-x (jay/get-gamepad-axis-movement gamepad :right-x))
            (def right-stick-y (jay/get-gamepad-axis-movement gamepad :right-y))
            (jay/draw-circle 259 152 39 :black)
            (jay/draw-circle 259 152 34 :light-gray)
            (jay/draw-circle (+ 259 (* left-stick-x 20)) (+ 152 (* left-stick-y 20)) 25 (if (jay/is-gamepad-button-down gamepad :left-thumb) :red :black))
            (jay/draw-circle 461 237 38 :black)
            (jay/draw-circle 461 237 33 :light-gray)
            (jay/draw-circle (+ 461 (* right-stick-x 20)) (+ 237 (* right-stick-y 20)) 25 (if (jay/is-gamepad-button-down gamepad :right-thumb) :red :black)))
          (if (string/find ps-alias gamepad-name)
            (do
              (jay/draw-texture tex-ps3-pad 0 0 :dark-gray)
              # Draw buttons
              (when (jay/is-gamepad-button-down gamepad :middle) (jay/draw-circle 396 222 13 :red))
              (when (jay/is-gamepad-button-down gamepad :middle-left) (jay/draw-rectangle 328 170 32 13 :red))
              (when (jay/is-gamepad-button-down gamepad :middle-right) (jay/draw-triangle [436 168] [436 185] [464 177] :red))
              (when (jay/is-gamepad-button-down gamepad :right-face-up) (jay/draw-circle 557 144 13 :lime))
              (when (jay/is-gamepad-button-down gamepad :right-face-right) (jay/draw-circle 586 173 13 :red))
              (when (jay/is-gamepad-button-down gamepad :right-face-down) (jay/draw-circle 557 203 13 :violet))
              (when (jay/is-gamepad-button-down gamepad :right-face-left) (jay/draw-circle 527 173 13 :pink))
              # Draw d-pad
              (jay/draw-rectangle 225 132 24 84 :black)
              (jay/draw-rectangle 195 161 84 25 :black)
              (when (jay/is-gamepad-button-down gamepad :left-face-up) (jay/draw-rectangle 225 132 24 29 :red))
              (when (jay/is-gamepad-button-down gamepad :left-face-down) (jay/draw-rectangle 225 (+ 132 54) 24 30 :red))
              (when (jay/is-gamepad-button-down gamepad :left-face-left) (jay/draw-rectangle 195 161 30 25 :red))
              (when (jay/is-gamepad-button-down gamepad :left-face-right) (jay/draw-rectangle (+ 195 54) 161 30 25 :red))
              # Draw triggers
              (when (jay/is-gamepad-button-down gamepad :left-trigger-1) (jay/draw-circle 239 82 20 :red))
              (when (jay/is-gamepad-button-down gamepad :right-trigger-1) (jay/draw-circle 557 82 20 :red))
              # Draw joysticks
              (def left-stick-x (jay/get-gamepad-axis-movement gamepad :left-x))
              (def left-stick-y (jay/get-gamepad-axis-movement gamepad :left-y))
              (def right-stick-x (jay/get-gamepad-axis-movement gamepad :right-x))
              (def right-stick-y (jay/get-gamepad-axis-movement gamepad :right-y))
              (jay/draw-circle 319 255 35 :black)
              (jay/draw-circle 319 255 31 :light-gray)
              (jay/draw-circle (+ 319 (* left-stick-x 20)) (+ 255 (* left-stick-y 20)) 25 (if (jay/is-gamepad-button-down gamepad :left-thumb) :red :black))
              (jay/draw-circle 475 255 35 :black)
              (jay/draw-circle 475 255 31 :light-gray)
              (jay/draw-circle (+ 475 (* right-stick-x 20)) (+ 255 (* right-stick-y 20)) 25 (if (jay/is-gamepad-button-down gamepad :right-thumb) :red :black)))
            (do # Generic gamepad
              (jay/draw-text "GENERIC GAMEPAD" 280 180 20 :gray))))

        (jay/draw-text (string/format "DETECTED AXIS [%d]:" (jay/get-gamepad-axis-count gamepad)) 10 50 10 :maroon)
        (for i 0 (jay/get-gamepad-axis-count gamepad)
          (jay/draw-text (string/format "AXIS %d: %.02f" i (jay/get-gamepad-axis-movement gamepad i)) 20 (+ 70 (* i 20)) 10 :dark-gray))

        (def button (jay/get-gamepad-button-pressed))
        (if (not= button :unknown)
          (jay/draw-text (string/format "DETECTED BUTTON: %s" button) 10 430 10 :red)
          (jay/draw-text "DETECTED BUTTON: NONE" 10 430 10 :gray)))
      (do
        (jay/draw-text (string/format "GP%d: NOT DETECTED" gamepad) 10 10 10 :gray)
        (jay/draw-texture tex-xbox-pad 0 0 :light-gray)))

    (jay/end-drawing))

  (jay/unload-texture tex-ps3-pad)
  (jay/unload-texture tex-xbox-pad)
  (jay/close-window)))
