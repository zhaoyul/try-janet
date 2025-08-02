(import jaylib :as jay)

(def screen-width 800)
(def screen-height 450)

(defn main [& args]
  (jay/init-window screen-width screen-height "raylib [audio] example - multichannel sound")
  (jay/init-audio-device)

  (def fx-wav (jay/load-sound "resources/sound.wav"))

  (jay/set-target-fps 60)

  (while (not (jay/window-should-close))
    # Update
    (when (jay/mouse-button-pressed? :left)
      (jay/play-sound fx-wav))

    # Draw
    (jay/begin-drawing)
    (jay/clear-background :ray-white)

    (jay/draw-text "Click mouse to play a sound" 200 180 20 :light-gray)

    (jay/end-drawing))

  (jay/unload-sound fx-wav)
  (jay/close-audio-device)
  (jay/close-window))
