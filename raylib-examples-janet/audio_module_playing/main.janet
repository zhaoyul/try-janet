(import jaylib :as jay)

(def screen-width 800)
(def screen-height 450)

(defn main [& args]
  (jay/init-window screen-width screen-height "raylib [audio] example - module playing")
  (jay/init-audio-device)

  (def music (jay/load-music-stream "resources/mini1111.xm"))
  (jay/play-music-stream music)

  (var time-played 0.0)
  (var pause false)

  (jay/set-target-fps 60)

  (while (not (jay/window-should-close))
    # Update
    (jay/update-music-stream music)

    (when (jay/key-pressed? :space)
      (set pause (not pause))
      (if pause (jay/pause-music-stream music) (jay/resume-music-stream music)))

    (set time-played (/ (jay/get-music-time-played music) (jay/get-music-time-length music)))
    (when (> time-played 1.0) (set time-played 1.0))

    # Draw
    (jay/begin-drawing)
    (jay/clear-background :ray-white)

    (jay/draw-text "MUSIC SHOULD BE PLAYING!" 255 150 20 :light-gray)
    (jay/draw-rectangle 200 200 400 12 :light-gray)
    (jay/draw-rectangle 200 200 (math/round (* time-played 400.0)) 12 :maroon)
    (jay/draw-rectangle-lines 200 200 400 12 :gray)

    (jay/draw-text "PRESS SPACE TO PAUSE/RESUME MUSIC" 215 250 20 :light-gray)

    (jay/end-drawing))

  (jay/unload-music-stream music)
  (jay/close-audio-device)
  (jay/close-window))

(comment
  (main)

  )
