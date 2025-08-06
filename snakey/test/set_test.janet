# test/set_test.janet
(use judge)
(import ../set :as s)

# Helper to make test outputs predictable
(defn- sorted-array [set]
  (-> (s/to-array set)
      (sort)))

(deftest "new sets"
  (test (s/size (s/new nil)) 0)
  (test (sorted-array (s/new @[1 2 3 2])) @[1 2 3]))

(deftest "add items"
  (def s1 (s/new @[:a :b]))
  (s/add s1 :c)
  (test (sorted-array s1) @[:a :b :c])
  # Adding an existing item shouldn't change it
  (s/add s1 :a)
  (test (sorted-array s1) @[:a :b :c]))

(deftest "remove items"
  (def s1 (s/new @[:a :b :c]))
  (s/remove s1 :b)
  (test (sorted-array s1) @[:a :c])
  # Removing a non-existent item shouldn't change it
  (s/remove s1 :d)
  (test (sorted-array s1) @[:a :c]))

(deftest "has? predicate"
  (def s1 (s/new @[10 20]))
  (test (s/has? s1 10) true)
  (test (s/has? s1 30) nil))

(deftest "size"
  (test (s/size (s/new @[])) 0)
  (test (s/size (s/new @[1 2 3])) 3))

(deftest "to-array"
  (def s1 (s/new @[:c :a :b]))
  (test (sorted-array s1) @[:a :b :c]))

(deftest "set union"
  (def s1 (s/new @[1 2 3]))
  (def s2 (s/new @[3 4 5]))
  (def s-union (s/union s1 s2))
  (test (sorted-array s-union) @[1 2 3 4 5]))

(deftest "set intersection"
  (def s1 (s/new @[1 2 3]))
  (def s2 (s/new @[3 4 5]))
  (def s-intersect (s/intersection s1 s2))
  (test (sorted-array s-intersect) @[3]))

(deftest "set difference"
  (def s1 (s/new @[1 2 3]))
  (def s2 (s/new @[3 4 5]))
  (def s-diff (s/difference s1 s2)) # s1 - s2
  (test (sorted-array s-diff) @[1 2]))
