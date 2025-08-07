(import jaylib :as jay)
(import spork/randgen :as r)
(import ./set :as s)

(def round math/round)
(def screen-width "屏幕宽度" 800)
(def screen-height "评估高度" 600)

(def line-num "每行线的数量" 150)
(def grid-num "每行格子数量" (dec line-num))
(def grid-count "总格子数量" (* grid-num grid-num))
(def margian "屏幕边缘空白" 10)
(def grid-margian "格子之间" "格子之间的空白" 2)
(def canvas-width "画布宽度" (- screen-width (* 2 margian)))
(def canvas-height "画布高度" (- screen-height (* 2 margian)))
(def grid-width "格子宽度" (-> canvas-width (/ grid-num)))
(def grid-height "格子高度" (-> canvas-height (/ grid-num)))
(def grids "格子数据结构"
  (map (fn [i] @{:index i
                 :grid @[(round (+ margian (* (% i grid-num) grid-width)
                                   grid-margian))
                         (round (+ margian (* (math/floor (/ i grid-num)) grid-height)
                                   grid-margian))
                         (round (- grid-width grid-margian))
                         (round (- grid-height grid-margian))
                         :yellow]})
       (range  (* grid-num grid-num))))

(defn idx->xy [idx]
  [(% idx grid-num) (math/floor (/ idx grid-num))])

(defn xy->idx [[x y]]
  (+ x (* y grid-num)))

(defn grid-neighbour? "是否是邻居" [[x1 y1] [x2 y2]]
  (match [(<= (math/abs (- x1 x2)) 1) (<= (math/abs (- y1 y2)) 1)]
    [1 0] true
    [0 1] true
    false))

(def moves "合理的移动" [[1 0] [-1 0] [0 1] [0 -1]])

(defn valid-xy "是否是合理的[x y]坐标" [[x y]]
  (and (<= 0 x grid-num)
       (<= 0 y grid-num)))

(defn gen-neighbour "生成范围以内的邻居格子" [idx]
  (let [[x y] (idx->xy idx)]
    (->> moves
         (map (fn [[a b]] [(+ x a) (+ y b)]))
         (filter (fn [xy] (valid-xy xy))))))

(def random-grid "随机一个格子" (r/rand-int 0 grid-count))

(defn set-color "把`grid`的颜色设置为`color`" [color grid]
  (put-in grid [:grid 4] color))

(defn f [snake l]
  (if (zero? l)
    snake
    (let [tail (last snake)
          next-to-tail (last (drop -1 snake))
          ns    (gen-neighbour tail)
          valid-ns (filter |(not (s/has? (s/new snake) (xy->idx $))) ns)
          rand-n   (xy->idx (get valid-ns (r/rand-index valid-ns)))]
      (f (array/push snake rand-n) (dec l)))))

(defn gen-snake "根据长度, 生成一条贪吃蛇" [len]
  (let []
    (f @[random-grid] len)))

(var first-snake (gen-snake 15))

(defn tuple->array [t]
  (tuple (splice t)))

(defn draw-grid-number> [grid]
  (let [{:grid [x y _ _ _] :index index} grid]
    (jay/draw-text (string index) x y 15 :gray))
  grid)

(defn draw-grid> [g]
  (let [{:grid grid} g]
    (->> grid
         tuple->array
         (|(apply jay/draw-rectangle $))))
  g)

(var count 0)

(defn move-one-step [snake]
  (let [[head & _] snake
        rest (drop -1 snake)
        ns (gen-neighbour head)
        valid-ns (filter |(not (s/has? (s/new snake) (xy->idx $))) ns)
        rand-n   (xy->idx (get valid-ns (r/rand-index valid-ns)))]
    (set first-snake (array/concat @[rand-n] rest))))


(defn main [& args]

      (jay/init-window screen-width screen-height "raylib [core] example - 2d camera")

      (jay/set-target-fps 60)

      (while (not (jay/window-should-close))

        # Draw
        (jay/begin-drawing)
        (jay/clear-background :ray-white)
        #(jay/draw-fps 100 100)


        (->> grids
             (map |(set-color :yellow $))
             (map draw-grid>))

        (->> first-snake
             (map |(get grids $))
             (map |(set-color :red $))
             (map draw-grid>)
             )

        (set count (inc count))
        (when (zero? (mod count 6))
          (move-one-step first-snake))

        (jay/end-drawing))

      (jay/close-window))




(comment
  (main)


  )
