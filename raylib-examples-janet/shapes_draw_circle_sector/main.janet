(import jaylib :as jay)
(import raygui :as gui)
(import string)

(def screen-width 800)
(def screen-height 450)

(defn main [& args]
  (jay/init-window screen-width screen-height "raylib [shapes] example - draw circle sector")

  (var center @{:x (/ screen-width 2.0) :y (/ screen-height 2.0)})
  (var radius 100.0)
  (var start-angle 0.0)
  (var end-angle 90.0)
  (var segments 0)
  (var draw-sector true)
  (var draw-sector-lines false)

  (jay/set-target-fps 60)

  (while (not (jay/window-should-close))
    # Draw
    (jay/begin-drawing)
    (jay/clear-background :ray-white)

    (jay/draw-line 400 0 400 screen-height :light-gray)
    (jay/draw-rectangle 400 0 screen-width 400 :light-gray)

    (if draw-sector (jay/draw-circle-sector center radius start-angle end-angle segments (jay/fade :red 0.3)))
    (if draw-sector-lines (jay/draw-circle-sector-lines center radius start-angle end-angle segments :maroon))

    # GUI controls
    (set radius (gui/slider-bar @{:x 500 :y 40 :width 120 :height 20} "Radius" (string/format "%.2f" radius) radius 0 200))
    (set start-angle (gui/slider-bar @{:x 500 :y 70 :width 120 :height 20} "StartAngle" (string/format "%.2f" start-angle) start-angle 0 360))
    (set end-angle (gui/slider-bar @{:x 500 :y 100 :width 120 :height 20} "EndAngle" (string/format "%.2f" end-angle) end-angle 0 360))
    (set segments (gui/slider-bar @{:x 500 :y 130 :width 120 :height 20} "Segments" (string/format "%d" segments) segments 0 100))

    (set draw-sector (gui/check-box @{:x 500 :y 180 :width 20 :height 20} "Draw Sector" draw-sector))
    (set draw-sector-lines (gui/check-box @{:x 500 :y 210 :width 20 :height 20} "Draw SectorLines" draw-sector-lines))

    (jay/draw-fps 10 10)
    (jay/end-drawing))

  (jay/close-window)))
