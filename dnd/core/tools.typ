
#let arrayOrNone(v) = if bottom == none {
   ()
 } else if type(bottom) == array {
   bottom
 } else {
   (bottom,)
 }
