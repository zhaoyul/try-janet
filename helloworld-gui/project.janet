(declare-project
  :name "helloworld"
  :dependencies ["https://github.com/janet-lang/jaylib.git"])

(declare-executable
  :name "helloworld"
  :entry "main.janet")
