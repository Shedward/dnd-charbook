# Сборка карточек и книги

Для колоды выберите набор фонов параметром `illustration-set`. По умолчанию собирается текстовая колода. Для локальных виньеток укажите `--input illustration-set=woodcut-vignettes`. Если заклинания нет в выбранном наборе, Typst выводит обычную текстовую карту.

```sh
mkdir -p build
typst compile --root . --input illustration-set=woodcut-frames books/deck-test.typ build/frames.pdf
```

В книге укажите `--input book-illustration-set=woodcut-vignettes`, чтобы включить локальный набор виньеток. Подробнее о [формате PNG и цветовой схеме](plate-format.md), [масках и вылете](masks.md) и [генерации новых иллюстраций](../illustrations/README.md).

Для сравнения всех опубликованных наборов соберите `typst compile --root . books/illustrations-test.typ build/illustrations-test.pdf`. Это печатный лист A4 с вылетом 2 мм вокруг каждой карты и внешними метками реза. В тестовом PDF белая вуаль с непрозрачностью 66 % осветляет только вылет за серой линией; это служебное оформление пробы. Печатайте в масштабе 100 %. По строкам идут одни и те же 12 заклинаний, по столбцам — наборы. Список наборов в `resources/illustrations/sets.json` обновляет скрипт публикации.
