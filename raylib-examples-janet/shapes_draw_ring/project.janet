(declare-project
  :name "shapes_draw_ring"
  :dependencies ["https://github.com/janet-lang/jaylib.git"
                 "https://github.com/janet-lang/raygui.git"])

(declare-executable
  :name "shapes_draw_ring"
  :entry "main.janet")
