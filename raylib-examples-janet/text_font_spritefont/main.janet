(import jaylib :as jay)

(def screen-width 800)
(def screen-height 450)

(defn main [& args]
  (jay/init-window screen-width screen-height "raylib [text] example - sprite font loading")

  (def msg1 "THIS IS A custom SPRITE FONT...")
  (def msg2 "...and this is ANOTHER CUSTOM font...")
  (def msg3 "...and a THIRD one! GREAT! :D")

  (def font1 (jay/load-font "resources/fonts/custom_mecha.png"))
  (def font2 (jay/load-font "resources/fonts/custom_alagard.png"))
  (def font3 (jay/load-font "resources/fonts/custom_jupiter_crash.png"))

  (def font-position1
    @{:x (- (/ screen-width 2.0) (/ ((jay/measure-text-ex font1 msg1 (font1 :base-size) -3) :x) 2))
      :y (- (/ screen-height 2.0) (/ (font1 :base-size) 2.0) 80.0)})

  (def font-position2
    @{:x (- (/ screen-width 2.0) (/ ((jay/measure-text-ex font2 msg2 (font2 :base-size) -2) :x) 2.0))
      :y (- (/ screen-height 2.0) (/ (font2 :base-size) 2.0) 10.0)})

  (def font-position3
    @{:x (- (/ screen-width 2.0) (/ ((jay/measure-text-ex font3 msg3 (font3 :base-size) 2) :x) 2.0))
      :y (+ (/ screen-height 2.0) (- (/ (font3 :base-size) 2.0)) 50.0)})

  (jay/set-target-fps 60)

  (while (not (jay/window-should-close))
    (jay/begin-drawing)
    (jay/clear-background :ray-white)

    (jay/draw-text-ex font1 msg1 font-position1 (font1 :base-size) -3 :white)
    (jay/draw-text-ex font2 msg2 font-position2 (font2 :base-size) -2 :white)
    (jay/draw-text-ex font3 msg3 font-position3 (font3 :base-size) 2 :white)

    (jay/end-drawing))

  (jay/unload-font font1)
  (jay/unload-font font2)
  (jay/unload-font font3)
  (jay/close-window)))
