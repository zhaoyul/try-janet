(import jaylib :as jay)
(import spork/randgen :as r)

(def round math/round)

(def screen-width "屏幕宽度" 800)
(def screen-height "评估高度" 600)
(def line-num "每行线的数量" 20)
(def grid-num "每行格子数量" (dec line-num))
(def grid-count "总格子数量" (* grid-num grid-num))
(def margian "屏幕边缘空白" 10)
(def grid-margian "格子之间的空白" 2)
(def canvas-width (- screen-width (* 2 margian)))
(def canvas-height (- screen-height (* 2 margian)))
(def grid-width (-> canvas-width (/ grid-num)))
(def grid-height (-> canvas-height (/ grid-num)))
(def grids (map (fn [i] @[(round (+ margian (* (% i grid-num) grid-width)
                                    grid-margian))
                          (round (+ margian (* (math/floor (/ i grid-num)) grid-height)
                                    grid-margian))
                          (round (- grid-width grid-margian))
                          (round (- grid-height grid-margian))
                          :yellow])
                (range  (* grid-num grid-num))))

(defn idx->xy [idx]
  [(% idx grid-num) (math/floor (/ idx grid-num))])

(defn xy->idx [[x y]]
  (+ x (* y grid-num)))

(defn grid-by-xy [x y]
  (get grids (xy->idx [x y])))

(defn grid-neighbour [[x1 y1] [x2 y2]]
  (match [(<= (math/abs (- x1 x2)) 1) (<= (math/abs (- y1 y2)) 1)]
    [1 0] true
    [0 1] true
    false))

(def moves [[1 0] [-1 0] [0 1] [0 -1]])

(defn valid-xy [[x y]]
  (and (<= 0 x grid-num)
       (<= 0 y grid-num)))

(defn gen-neighbour [idx]
  (let [[x y] (idx->xy idx)]
    (->> moves
         (map (fn [[a b]] [(+ x a) (+ y b)]))
         (filter (fn [xy] (valid-xy xy))))))

(def random-grid (r/rand-int 0 grid-count))

(defn set-color [xs color]
  (put-in xs [4] color))

(defn f [snake l]
  (if (zero? l)
    snake
    (let [tail (last snake)
          next-to-tail (last (drop -1 snake))
          ns    (gen-neighbour tail)
          valid-ns (filter |(deep-not= next-to-tail $) ns)
          rand-n   (xy->idx (get valid-ns (r/rand-index valid-ns)))]
      (f (array/push snake rand-n) (dec l)))))

(defn gen-snake [len]
  (let []
    (f @[random-grid] 3)))

(comment

  )



(defn main [& args]
  (jay/init-window screen-width screen-height "raylib [core] example - 2d camera")

  (jay/set-target-fps 60)

  (while (not (jay/window-should-close))

    # Draw
    (jay/begin-drawing)
    (jay/clear-background :ray-white)
    (jay/draw-fps 100 100)

    (map |(apply jay/draw-rectangle (tuple (splice $))) grids)
    (apply jay/draw-rectangle (tuple (splice (put-in (get grids random-grid) [4] :blue))))
    (->> (gen-snake 1)
         (map |(get grids $))
         (map |(set-color $ :red))
         (take 2)
         (map |(apply jay/draw-rectangle (tuple (splice $)))))




    (jay/end-drawing))

  (jay/close-window))

(comment
  (main)
  )
