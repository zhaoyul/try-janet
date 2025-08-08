(import jaylib :as jay)

(def screen-width 800)
(def screen-height 600)

(def restart-button-rect @[(- (/ screen-width 2) 100) (- (/ screen-height 2) 25) 200 50])
(def exit-button-rect @[(- (/ screen-width 2) 100) (+ (/ screen-height 2) 50) 200 50])

(defn draw-game-over []
  (jay/draw-rectangle 0 0 screen-width screen-height [0 0 0 150])
  (let [text-width (jay/measure-text "GAME OVER" 40)]
    (jay/draw-text (string/format "Width: %d" text-width) 10 10 20 :white)
    (jay/draw-text "GAME OVER" (- (/ screen-width 2) (/ text-width 2)) (- (/ screen-height 2) 100) 40 :white))

  (jay/draw-rectangle-rec restart-button-rect :dark-gray)
  (jay/draw-text "Restart" (+ (get restart-button-rect 0) 60) (+ (get restart-button-rect 1) 15) 20 :white)

  (jay/draw-rectangle-rec exit-button-rect :dark-gray)
  (jay/draw-text "Exit" (+ (get exit-button-rect 0) 75) (+ (get exit-button-rect 1) 15) 20 :white))

(defn handle-input []
  (when (jay/mouse-button-pressed? :left)
    (let [mouse-point (jay/get-mouse-position)]
      (cond
        (jay/check-collision-point-rec mouse-point restart-button-rect) :restart
        (jay/check-collision-point-rec mouse-point exit-button-rect) :exit))))
