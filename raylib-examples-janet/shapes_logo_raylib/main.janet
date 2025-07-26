(import jaylib :as jay)

(def screen-width 800)
(def screen-height 450)

(defn main [& args]
  (jay/init-window screen-width screen-height "raylib [shapes] example - raylib logo using shapes")
  (jay/set-target-fps 60)

  (while (not (jay/window-should-close))
    (jay/begin-drawing)
    (jay/clear-background :ray-white)
    (jay/draw-rectangle (- (/ screen-width 2) 128) (- (/ screen-height 2) 128) 256 256 :black)
    (jay/draw-rectangle (- (/ screen-width 2) 112) (- (/ screen-height 2) 112) 224 224 :ray-white)
    (jay/draw-text "raylib" (- (/ screen-width 2) 44) (+ (/ screen-height 2) 48) 50 :black)
    (jay/draw-text "this is NOT a texture!" 350 370 10 :gray)
    (jay/end-drawing))

  (jay/close-window)))
