# Сборка карточек и книги

Для колоды выберите набор фонов параметром `illustration-set`. По умолчанию собирается текстовая колода. Для локальных виньеток укажите `--input illustration-set=woodcut-vignettes`. Если заклинания нет в выбранном наборе, Typst выводит обычную текстовую карту.

```sh
mkdir -p build
typst compile --root . --input illustration-set=woodcut-frames books/deck-test.typ build/frames.pdf
```

В книге укажите `--input book-illustration-set=woodcut-vignettes`, чтобы включить локальный набор виньеток. Подробнее о [формате PNG и цветовой схеме](plate-format.md), [масках и вылете](masks.md) и [генерации новых иллюстраций](../illustrations/README.md).

Для сравнения всех опубликованных наборов соберите `typst compile --root . books/illustrations-test.typ build/illustrations-test.pdf`. По строкам идут одни и те же 12 заклинаний, по столбцам — наборы. Список наборов в `resources/illustrations/sets.json` обновляет скрипт публикации.
