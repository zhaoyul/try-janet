(import jaylib :as jay)
(import string)

(def screen-width 800)
(def screen-height 450)

(defn main [& args]
  (jay/init-window screen-width screen-height "raylib [core] example - vr simulator")

  (jay/init-vr-simulator)

  (def cubes (array/new-filled 10 @{}))
  (for i 0 10
    (put cubes i @{:x (jay/get-random-value -32 32)
                    :y (jay/get-random-value 0 16)
                    :z (jay/get-random-value -32 32)}))

  (jay/set-target-fps 90)

  (while (not (jay/window-should-close))
    # Update
    (jay/update-vr-tracking)

    (when (jay/is-key-pressed :space)
      (jay/toggle-vr-mode))

    # Draw
    (jay/begin-drawing)
    (jay/clear-background :ray-white)

    (if (jay/is-vr-simulator-ready)
      (do
        (jay/begin-vr-drawing)
        (jay/draw-grid 10 1.0)
        (for i 0 10
          (jay/draw-cube (cubes i) 2.0 2.0 2.0 :red))
        (jay/end-vr-drawing))
      (jay/draw-text "VR Simulator not ready" 10 10 20 :maroon))

    (jay/end-drawing))

  (jay/close-vr-simulator)
  (jay/close-window)))
