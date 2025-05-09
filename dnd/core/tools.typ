
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

#let filterNone(shouldSkip: true, array) = {
  if shouldSkip {
    array.filter(i => i != none)
  } else {
    array
  }
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

 #let method(o, f, default: (o) => none) = {
   if o == none or f(o) == none {
     none
   } else if type(f(o)) == function {
     f(o)(o)
   } else if f(o) == auto {
     default(o)
   } else {
     f(o)
   }
 }

 #let switchInt(value, cases) = {
   let keys = cases.keys().map(int).filter(c => c <= value)
   if keys.len() > 0 {
     cases.at(str(keys.last()))
   }
 }

 #let roman(num) = {
     let result = ""
     let values = (1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1)
     let numerals = ("M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I")

     for (value, numeral) in values.zip(numerals) {
         while num >= value {
             result += numeral
             num -= value
         }
     }

     result
 }
