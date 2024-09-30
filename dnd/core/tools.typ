
#let arrayOrNone(v) = if v == none {
  ()
 } else if type(v) == array {
  v
 } else {
  (v,)
 }

 #let valueOrDefault(v, default) = if v == none {
  default
 } else {
  v
 }

 #let todo(caption) = block(fill: yellow, radius: 4pt, inset: 0.5em)[
  #raw("[" + valueOrDefault(caption, "TODO") + "]")
 ]
