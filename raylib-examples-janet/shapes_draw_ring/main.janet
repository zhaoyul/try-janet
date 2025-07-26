(import jaylib :as jay)
(import raygui :as gui)
(import string)

(def screen-width 800)
(def screen-height 450)

(defn main [& args]
  (jay/init-window screen-width screen-height "raylib [shapes] example - draw ring")

  (var center @{:x (/ (- screen-width 300) 2.0) :y (/ screen-height 2.0)})
  (var inner-radius 80.0)
  (var outer-radius 190.0)
  (var start-angle 0.0)
  (var end-angle 360.0)
  (var segments 0.0)
  (var draw-ring true)
  (var draw-ring-lines false)
  (var draw-circle-lines false)

  (jay/set-target-fps 60)

  (while (not (jay/window-should-close))
    # Draw
    (jay/begin-drawing)
    (jay/clear-background :ray-white)

    (jay/draw-line 500 0 500 screen-height (jay/fade :light-gray 0.6))
    (jay/draw-rectangle 500 0 (- screen-width 500) screen-height (jay/fade :light-gray 0.3))

    (if draw-ring (jay/draw-ring center inner-radius outer-radius start-angle end-angle (math/floor segments) (jay/fade :maroon 0.3)))
    (if draw-ring-lines (jay/draw-ring-lines center inner-radius outer-radius start-angle end-angle (math/floor segments) (jay/fade :black 0.4)))
    (if draw-circle-lines (jay/draw-circle-sector-lines center outer-radius start-angle end-angle (math/floor segments) (jay/fade :black 0.4)))

    # GUI controls
    (set start-angle (gui/slider-bar @{:x 600 :y 40 :width 120 :height 20} "StartAngle" (string/format "%.2f" start-angle) start-angle -450 450))
    (set end-angle (gui/slider-bar @{:x 600 :y 70 :width 120 :height 20} "EndAngle" (string/format "%.2f" end-angle) end-angle -450 450))
    (set inner-radius (gui/slider-bar @{:x 600 :y 140 :width 120 :height 20} "InnerRadius" (string/format "%.2f" inner-radius) inner-radius 0 100))
    (set outer-radius (gui/slider-bar @{:x 600 :y 170 :width 120 :height 20} "OuterRadius" (string/format "%.2f" outer-radius) outer-radius 0 200))
    (set segments (gui/slider-bar @{:x 600 :y 240 :width 120 :height 20} "Segments" (string/format "%.2f" segments) segments 0 100))

    (set draw-ring (gui/check-box @{:x 600 :y 320 :width 20 :height 20} "Draw Ring" draw-ring))
    (set draw-ring-lines (gui/check-box @{:x 600 :y 350 :width 20 :height 20} "Draw RingLines" draw-ring-lines))
    (set draw-circle-lines (gui/check-box @{:x 600 :y 380 :width 20 :height 20} "Draw CircleLines" draw-circle-lines))

    (def min-segments (math/ceil (/ (- end-angle start-angle) 90)))
    (jay/draw-text (string/format "MODE: %s" (if (>= segments min-segments) "MANUAL" "AUTO")) 600 270 10 (if (>= segments min-segments) :maroon :dark-gray))

    (jay/draw-fps 10 10)
    (jay/end-drawing))

  (jay/close-window)))
