# Полноформатная рамка · `full-face`

В полноформатной серии сюжет занимает нижнюю часть карты, продолжается по бокам и достигает верхнего края. Светлое поле оставляет место для чёрного текста. Внешний силуэт задают элементы самой сцены. Текст и разделитель поверх иллюстрации рисует Typst.

[Эталон трёх готовых карт](../../styles/woodcut/resources/woodcut-scenes.png) показывает масштаб сцены после обрезки. [Маска и наложение текста](../../../../cards/resources/ornament-guides.png) показывают назначение направляющих. Для генерации экспортируйте отдельную маску нужного заклинания.

Экспорт маски, параметры Typst и назначение линий описаны в [инструкции по маскам](../../../../cards/masks.md).

## Внутреннее обрамление по выбору стиля

Фиолетовый пунктир показывает примерное положение оси орнамента: короткий отрезок над шапкой и два вдоль текстового блока, по умолчанию в 4 мм от реза. Боковые отрезки подстраиваются под высоту текста. Художник выбирает нужные участки и оставляет между мотивами воздух. Сам пунктир в рисунок не переносится. Для стиля без обрамления можно скрыть его в маске и наложении через `--input ornament-guide=off`.

Если стиль использует обрамление, наметьте части прежнего контура карты там, где боковые поля или верх выглядят пустыми. Для текущего размера ориентир — около 4–5 мм внутрь от линии реза. Удерживайте акценты внутри точечной направляющей и за пределами белого поля. Оставляйте разрывы около уже занятого угла и там, где сценка сама замыкает низ. После наложения текста проверьте, что между штрихами и буквами виден просвет. Если места мало, пропустите акцент.

Для проверки положите маску поверх готового арта в одинаковом масштабе и совместите края холста с вылетом. Если стиль использует обрамление, проверьте верхний и оба боковых отрезка. На свободных участках ось мотива должна примерно следовать пунктиру; занятый участок может обыгрывать сама сцена. Ветка у линии реза учитывается как фон вылета. На печатном листе проверьте, что внутренние акценты видны и после обрезки.

Конкретный мотив задаёт профиль стиля. По возможности он поддерживает уже показанное действие или связывает поля с его окружением. Если возникает вторая история или ложная подсказка об эффекте заклинания, выберите нейтральную деталь. Без указания стиля поле остаётся свободным.

## Что можно срезать

На всех четырёх сторонах синяя полоса означает допуск реза. Декор, который входит в эту полосу, продолжайте через номинальную линию до внешнего края PNG. Крупную кладку или ветку лучше провести через полосу поперёк либо наискосок: при смещении ножа сохранится узнаваемый фрагмент. Для ствола, идущего вдоль края, оставьте внутри достаточно его ширины, чтобы после среза он не превратился в тонкую неровную полоску.

Внутренний орнамент целиком помещается внутри точечной линии, включая крайние точки и листья. Такое же правило действует для значимых силуэтов: подошва, кисть и остриё сюжетного предмета должны целиком помещаться внутри с видимым просветом. Перед публикацией посмотрите, что останется при резе на 2 мм внутрь с каждой стороны, включая углы. Если срез отнимает часть ступни или меняет характер орнамента, правьте композицию.

## Поставить сцену

- По [выбранному сюжету](../../../README.md) выберите эффект, его видимый признак и одну реакцию. Рисовку для полноформатной серии задайте отдельно.
- Работайте с **одной маской одного заклинания**. Цвет показывает, где разместить основную массу изображения. Нижнее связное поле отдайте действию и предмету, от которого зависит шутка. На боковые полосы вынесите второстепенные части того же места. Верхнюю полосу свяжите с ними архитектурой, ветвями или тканью.
- Постройте переход в светлое поле через разрывы контуров, редкие листья и просветы. Можно оставить воздух внутри цветной области и вынести мелкий кончик за её границу. Под буквами, значками и разделителем оставьте чистое поле. Контрольное изображение с текстом используйте при проверке.
- Подбирайте размер фигур по высоте нижней области конкретной маски. Поставьте стопы с запасом внутри линии безопасности и проверьте верхнюю точку силуэта, включая перо, оружие и след эффекта. В печатном размере должны читаться жест и реакция, а под последней строкой оставаться просвет. На утверждённой «Пляске Отто» до пера около 3 мм. Это наблюдение по готовой карте; защитный запас маски сохраняется.
- Продолжите поверхность под персонажами до окружения у боковых краёв. На «Брызгах кислоты» мостовая доходит до стен, на «Пляске Отто» те же плиты лежат под сапогом и колоннами, на «Предзнаменовании» ручей у моста выходит к боковым камышам. Продолжите поверхность также вниз, через линию реза до самого нижнего края холста с вылетом. Проверьте в исходном PNG последние миллиметры под ногами и в обоих углах: полоса бумаги между землёй и краем требует правки. Достаточно одной такой связи. Просветы в верхней части рамки помогают удержать внимание на действии.
- Если текст почти заполняет карту, выберите более низкий силуэт сцены и уменьшите число фигур. Если их уже трудно различить при печати, используйте обычную нижнюю виньетку.

### Фрагмент промпта

Приложите маску этого заклинания, подписав её как spatial guide. Для контроля сделайте также наложение с текстом. Цвета маски определяют плотность рисунка. Тон бумаги и художественный приём в переходной полосе выбирайте в профиле стилистики.

```prompt
Deliver one portrait edge-to-edge art plate. Use the attached spatial guide {mask} for placement. Match its canvas proportions and orientation. Put the main action in the uninterrupted lower red area. Size full-length figures to the available height on this particular card so the key gesture reads at print size. Anchor their feet inside trim safety and keep the highest silhouette clear of the last line of type. Continue the surface supporting the figures into the scenery at the side edges: the same paving, bank or other feature should visibly connect the action to its frame. Extend that surface downward through the trim and all the way to the bottom row of the bleed image, including both corners. Keep the feet safely above the cut. Do not leave a strip of bare paper below the ground. Extend secondary elements of the same setting along the sides and top to all four outer edges. Amber is a sparse transition. White reserves quiet uniform paper for black type, including the safety strip below the last line. If the brief specifies a flat content color, reserve that area for the theme’s content-fill layer and leave it clear of painted detail. Use the selected style and paper tone; omit all guide colors, lettering, registration marks and additional card outlines. Keep faces and dense ink in the red area. Fine tips may enter the transition with natural gaps. The blue-tinted perimeter is the cutter tolerance band. Every edge must tolerate a cut displaced by up to 2 mm in either direction. Carry scenery entering this band across the trim and off the canvas; avoid tips or narrow parallel strips terminating in the band. Keep whole soles, hands, story props and inset ornaments comfortably inside the dotted boundary. The dashed line is the nominal trim; the dotted line is 2 mm further inside. Keep essential gestures, faces and spell cues inside the dotted line. Extend expendable scenery across the trim through the full 2 mm bleed. Vary edge shapes and interrupt their contours; avoid mirrored strips, thin rectangular rules and long lines parallel to the cut. Omit both guides from the art. Short violet dashed segments are optional ornament centerlines. Never reproduce these marks or their color. Only if the style calls for inner framing, align separated accents along available side or top margins roughly 4–5 mm inside trim. Keep each accent fully inside the dotted safe line and outside the white text reserve. Leave a gap where the scene already occupies that inset guide. Treat outer-edge scenery separately from the inner accents. Prefer a motif that reinforces the established action or setting; use neutral marks if a motif suggests another effect. Omit any accent that crowds the type.
```

## Проверить на карте

Рабочий арт создавайте в `build/art/<id>.png` по маске с вылетом 2 мм. Опубликуйте его в набор и проверьте карту с тем же размером текста, что и при создании маски:

```sh
python3 scripts/spell-plates.py woodcut-frames build/art/augury.png
mkdir -p build/full-face
typst compile --root . --input spell=augury --input mode=front \
  --input illustration-set=woodcut-frames \
  books/debug/full-face-card.typ build/full-face/augury-front.pdf
```

Параметр публикации `--body-scale 0.84` сохраняет масштаб текста в индексе, когда это требуется конкретной карте. Для пробы рабочего арта до публикации укажите `--input art=/build/art/augury.png`.

Откройте PDF в печатном размере. Проверьте нижнюю строку описания, материальные компоненты, места около заголовка и стыки по краям. Генератор интерпретирует маску свободно. Если ветка или складка касается букв, поправьте локально рисунок и повторите наложение. Для «Необнаружимости» должны читаться занятая скамья и та же пустая скамья в чаше.

## Хранение оригиналов

В `resources/illustrations/` у каждого набора своя папка с готовыми фонами по ID заклинания и индексом. Для полноформатной ксилографии используется набор `woodcut-frames`. Маски, промежуточные версии и PDF собираются в `build/`.
