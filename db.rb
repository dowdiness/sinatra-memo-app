require "json"

DATA = '
[
  {
    "title": "タイトル",
    "content": "メモの中身"
  },
  {
    "title": "タイトル2",
    "content": "メモの中身2"
  }
]'

def memo_decode path
  DATA
end

def memo_encode path
  JSON.parse('[1,2,{"name":"tanaka","age":19}]')
end
