(declare-project
  :name "snake"
  :source ["."]
  :dependencies [
    "https://github.com/janet-lang/jaylib.git"
    {:url "https://github.com/ianthehenry/judge.git"
     :tag "v2.9.0"}
  ])

(declare-executable
  :name "snake"
  :entry "main.janet")
