
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

 #let  mapOrNone(v, t) = if v == none {
  none
} else {
  t(v)
}


 #let todo(caption) = block(fill: yellow, radius: 4pt, inset: 0.5em)[
  #raw("[" + valueOrDefault(caption, "TODO") + "]")
 ]

 #let contentToString(content) = {
   if content.has("text") {
     content.text
   } else if content.has("children") {
     content.children.map(to-string).join("")
   } else if content.has("body") {
     to-string(content.body)
   } else if content == [ ] {
     " "
   } else {
     ""
   }
 }

 #let matchedSize(source, data) = {
   let n = source.len();
   if data.len() == 0 {
     (auto,) * n
   } else {
     let tail = (data.last(),) * n
     (data + tail).slice(0, n)
   }
 }

 #let method(o, f) = {
   if o == none or f(o) == none {
     none
   } else if type(f(o)) == "function" {
     f(o)(o)
   } else {
     f(o)
   }
 }
