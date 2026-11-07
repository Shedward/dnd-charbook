# Нижняя виньетка · `vignette`

Художник создаёт горизонтальный PNG приблизительно 3:1. На этапе публикации скрипт добавляет контур и помещает виньетку на полный холст с вылетом 2 мм. Typst накладывает текст. Рисунок лежит по центру у нижней линии; зазор 2 мм измеряется от видимого штриха. Края рисунка естественно переходят в фон страницы. Для текущей книги и колоды фон белый.

Компактный сюжет на [первом эталоне](resources/spell-card-front-layout.png) размещён при ширине исходника 35 мм. В [полной серии](resources/spell-card-series-reference.png) земля и окружение расширяют полосу до 48,58 мм (около 16 мм высотой). Контролируйте рост фигуры на карте. При длинном описании упростите окружение и проверьте зазор до последней строки.

## Фрагмент промпта

```prompt
Deliver a separate horizontal 3:1 spot illustration. Compose one low group near a common baseline for a printed area of about 48 × 16 mm. Give figures clear, normally full-length silhouettes at comparable scale across the series; allow natural differences of size and pose. Keep ordinary props in proportion. Carry sparse secondary details outward, and let all edges merge into the page color. Leave out lettering, UI, border and card mockup. Deliver this horizontal scene for the plate publishing step.
```

## Опубликовать и проверить

1. Обрежьте пустые строки ниже последнего штриха. Положите исходник в `build/art/<id>.png`.
2. Из корня проекта выполните команду ниже с Python и Pillow. Она запишет полноразмерный PNG в выбранный набор и обновит его индекс. Ширина задаётся в миллиметрах, скрипт рассчитывает холст под разрешение исходника и переносит пиксели без ресэмплинга. Для плотного текста можно уменьшить физическую ширину виньетки.
3. Метаданные PNG содержат прямоугольник книжной виньетки. При сборке книга показывает эту область того же файла. Переиндексировать набор после удаления PNG можно командой `python3 scripts/spell-plates.py woodcut-vignettes`.

```sh
python3 scripts/spell-plates.py woodcut-vignettes build/art/alarm.png --vignette-width 48.58
```

Для сравнения шести виньеток на одном листе используйте `books/deck-frame-test.typ`. Обычная пробная колода собирается из `books/deck-test.typ`.

```sh
typst compile --root . --input illustration-set=woodcut-vignettes books/deck-frame-test.typ build/deck-frame-test.pdf
typst compile --root . --input illustration-set=woodcut-vignettes books/deck-test.typ build/deck-test.pdf
```
