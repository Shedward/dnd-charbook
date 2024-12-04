#let supportedLang = ("en", "ru")
#let defaultLang = "en"

#let setLocale(lang) = [
  #metadata(lang) <locale>
]

#let loc(..args) = context {
  let localeRecords = query(<locale>)
  let locale = if localeRecords.len() > 0 {
    localeRecords.first().value
  } else {
    "en"
  }

  let str = args.at(locale)
  if str != none {
    str
  } else if args.at(defaultLang) != none {
    args.at(defaultLang)
  } else if args.pos().len() != 0 {
    args.pos().first()
  } else {
    panic("Localization not found")
  }
}
