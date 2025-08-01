(import jaylib :as jay)

(def screen-width 800)
(def screen-height 450)

(ffi/context nil)
(ffi/defbind GetMouseDelta [:float :float] [])

(ffi/defbind Fade [:u8 :u8 :u8 :u8] [color [:u8 :u8 :u8 :u8] alpha :float])


(defn main [& args]
  (jay/init-window screen-width screen-height "raylib [shapes] example - rectangle scaling")

  (var rec @{:x 100.0 :y 100.0 :width 200.0 :height 80.0})
  (var mouse-scale-mode :none)

  (jay/set-target-fps 60)

  (while (not (jay/window-should-close))
         (def mouse-pos (jay/get-mouse-position))

         (if (and (jay/check-collision-point-rec mouse-pos (values rec))
                  (not= mouse-scale-mode :scale))
             (set mouse-scale-mode :move)
             (set mouse-scale-mode :none))

         (when (jay/check-collision-point-rec mouse-pos
                                              [(- (+ (rec :x) (rec :width)) 20)
                                               (- (+ (rec :y) (rec :height)  20))
                                               20  20])
           (set mouse-scale-mode :scale))

         (case mouse-scale-mode
           :move (when (jay/mouse-button-down? :left)
                   (update rec :x |(+ $ (get (GetMouseDelta) 0)))
                   (update rec :y |(+ $ (get (GetMouseDelta) 1))))
           :scale (when (jay/mouse-button-down? :left)
                    (update rec :width |(+ $ (get (GetMouseDelta) 0)))
                    (update rec :height |(+ $ (get (GetMouseDelta) 1)))))

         # Draw
         (jay/begin-drawing)
         (jay/clear-background :ray-white)

         (def green [25 25 0 0])

         (jay/draw-rectangle-rec (values rec) (Fade green 0.5))
         (jay/draw-rectangle-lines-ex (values rec) 2 :black)

         (when (= mouse-scale-mode :scale)
           (jay/draw-rectangle-rec [(- (+ (rec :x) (rec :width) 20))
                                    (- (+ (rec :y) (rec :height) 20))
                                    :width 20 :height 20] :red))

         (jay/draw-text "Scale rectangle with mouse" 10 10 20 :gray)
         (jay/end-drawing))

  (jay/close-window))


(main)
