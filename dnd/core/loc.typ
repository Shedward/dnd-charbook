#let supportedLang = ("en", "ru")
#let defaultLang = "en"

#let setLocale(lang) = [
  #metadata(lang) <locale>
]

#let _locData = json("/resources/data/localization.json")

#let _applySubstitutions(template, subs) = {
  let parts = (template,)
  for (k, v) in subs {
    let marker = "{" + k + "}"
    let newParts = ()
    for part in parts {
      if type(part) == str {
        let segments = part.split(marker)
        for i in range(segments.len()) {
          if segments.at(i) != "" { newParts.push(segments.at(i)) }
          if i < segments.len() - 1 { newParts.push(v) }
        }
      } else {
        newParts.push(part)
      }
    }
    parts = newParts
  }
  parts.join()
}

#let loc(..args) = context {
  let records = query(<locale>)
  let locale = if records.len() > 0 { records.first().value } else { defaultLang }

  if args.pos().len() > 0 and type(args.pos().at(0)) == str {
    // New API: loc("key") or loc("key", subs: (...))
    let key = args.pos().at(0)
    let subs = args.named().at("subs", default: (:))
    let entry = _locData.at(key, default: none)
    if entry == none { panic("Missing localization key: " + key) }
    let template = entry.at(locale, default: entry.at(defaultLang))
    if subs == (:) { template } else { _applySubstitutions(template, subs) }
  } else {
    // Old API: loc(en: ..., ru: ...) — kept for backward compatibility during migration
    let str = args.named().at(locale, default: none)
    if str != none {
      str
    } else if args.named().at(defaultLang, default: none) != none {
      args.named().at(defaultLang)
    } else if args.pos().len() != 0 {
      args.pos().first()
    } else {
      panic("Localization not found")
    }
  }
}
