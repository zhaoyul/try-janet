# filename: set.janet
# A module for creating and manipulating sets.
# Implemented using tables where keys are elements and values are `true`.

# --- Private Helper Functions ---

# (no private helpers needed for this simple design)


# --- Public API Functions ---

# Creates a new set.
# If an iterable (like an array or tuple) is provided,
# the set is initialized with its elements.
(defn new [initial-items]
  (def s @{})
  (each item (or initial-items [])
    (put s item true))
  s)

# Adds an item to the set.
(defn add [s item]
  (put s item true))

# Removes an item from the set.
(defn remove [s item]
  (put s item nil))

# Checks if an item exists in the set.
# The '?' suffix is a Janet convention for predicates (functions returning boolean).
(defn has? [s item]
  (in s item))

# Returns the number of elements in the set.
(defn size [s]
  (length s))

# Returns an array of all elements in the set.
(defn to-array [s]
  (keys s))

# --- Set Operations ---

# Returns a new set that is the union of s1 and s2.
# (Contains all elements from both sets)
(defn union [s1 s2]
  (let [result (table/clone s1)] # Start with a copy of the first set
    (each item (keys s2)
      (put result item true)) # Add all items from the second set
    result))

# Returns a new set that is the intersection of s1 and s2.
# (Contains only elements that are in both sets)
(defn intersection [s1 s2]
  (let [result (new nil)
        # For efficiency, iterate over the smaller set
        [smaller larger] (if (< (length s1) (length s2))
                           [(keys s1) s2]
                           [(keys s2) s1])]
    (each item smaller
      (if (in larger item)
        (put result item true)))
    result))

# Returns a new set that is the difference of s1 and s2 (s1 - s2).
# (Contains elements that are in s1 but NOT in s2)
(defn difference [s1 s2]
  (let [result (table/clone s1)] # Start with a copy of the first set
    (each item (keys s2)
      (put result item nil)) # Remove any items that are in the second set
    result))
