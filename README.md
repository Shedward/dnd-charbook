# D&D Charbook

Typst-шаблоны для настольной D&D 5e. Из описания персонажа получается книга A5 с характеристиками, атаками, инвентарём, заклинаниями и биографией. Для игры можно отдельно напечатать двустороннюю колоду заклинаний персонажа или целого класса.

## Первая сборка

Понадобится Typst CLI (проверено с 0.15.1). Для исходного оформления используются шрифты Mookmania, Alegreya SC и Nodesto Cyrillic. Из корня репозитория выполните:

```sh
mkdir -p build
typst compile books/marek-grivachov.typ --root . build/marek-grivachov.pdf
```

PDF появится в `build/`. Параметр `--root .` нужен для доступа к ресурсам проекта. Команда `./scripts/buildAll.sh` собирает каждый документ из `books/*.typ`. На macOS команда `./scripts/watch.sh marek-grivachov` откроет PDF в Skim и будет пересобирать его при изменениях.

## Свой персонаж

Создайте файл в `books/`. Функция `introduce` задаёт исходные данные, а каждый `upgrade` объединяет изменения от одного источника. Например, получение уровня может одновременно увеличить запас хитов и добавить заклинание.

```typ
#import "../dnd/builder/builder.typ": *
#import "../dnd/game/game.typ": CHA, spellcasting

#let hero = build(
  introduce(name: "Мира", stats: (STR: 8, DEX: 14, CON: 12, INT: 10, WIS: 13, CHA: 16)),
  upgrade("Колдун 1 ур.",
    setClass("Колдун"), levelUp(), addMaxHP(9),
    setSpellcasting(spellcasting(stat: CHA)),
    addSpellById("eldritch-blast"),
  ),
)
#charbook(hero, locale: "ru")
```

Полный пример с биографией, ячейками заклинаний и развитием по уровням — [книга Марека](books/marek-grivachov.typ). Если нужен свой порядок страниц, их можно компоновать вручную через `dnd.page`, как в [книге Эдны](books/edna-zeenhoffer.typ).

## Карточки заклинаний

Для колоды Миры замените последнюю строку примера на `#deckOfSpells(hero)` и задайте язык через `#setLocale("ru")`, импортировав `setLocale` из `../dnd/core/core.typ`. Для колоды класса достаточно отдельного файла:

```typ
#import "../dnd/core/core.typ": setLocale
#import "../dnd/builder/builder.typ": deckOfClassSpells

#setLocale("ru")
#deckOfClassSpells("жрец", subclass: "домен кузни")
```

Эта колода включает общие заклинания жреца и заклинания указанного подкласса. По умолчанию на лист A4 помещаются девять карточек. На лицевой стороне указаны игровые параметры, на обороте — описание. Для двусторонней печати переворачивайте лист по длинной стороне: порядок карточек на обороте уже отражён по горизонтали.
