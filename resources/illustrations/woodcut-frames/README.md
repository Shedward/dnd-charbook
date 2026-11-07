# Woodcut · рамки

Профили: [full-face](../../../docs/illustrations/profiles/layouts/full-face/full-face.md), [effect-first](../../../docs/illustrations/profiles/stories/effect-first/effect-first.md), [woodcut](../../../docs/illustrations/profiles/styles/woodcut/woodcut.md). Эталон рисовки — «Пир» из папки woodcut/resources. Печатный холст 70,67 × 99,67 мм включает 2 мм вылета. Тон бумаги тёплый, ориентир #F5EDDF.

Экспортируйте маску одного заклинания. Передайте её и «Пир» генератору. Оставьте светлый центр для настоящего текста. Основное действие занимает нижнее связное поле; землю доведите до бокового окружения и через вылет до нижнего края холста. Рассмотрите низ исходного PNG до обрезки и проверьте отсутствие пустой полосы бумаги. Стопы, лица и жест оставьте внутри безопасной линии. Пунктиры в арт не переносятся. Внутреннее обрамление включено. Сверьте верх и обе стороны с фиолетовыми отрезками маски (4 мм внутрь от реза). На свободном отрезке поставьте лёгкий мотив; занятый может обыгрывать деталь сцены на той же линии. Декор вдоль самого среза относится к окружению. При увеличении проверьте конечности, суставы, хват и положение глаз в профиль или три четверти, затем посмотрите на жест и обрамление при печатном размере. Сведите намёк на магию к одному читаемому жесту.

Список 12 ID зафиксирован в [тестовой книге](../../../books/illustrations-test.typ). В index.json перечислены опубликованные карты. Для scrying используйте body-scale 0.78, для spirit-shroud и mordenkainens-magnificent-mansion — 0.84; остальные — 1. Укажите один и тот же масштаб при экспорте маски и публикации. Сюжет берите из поля scene-prompt любой готовой карты с тем же ID.

```sh
id=scrying
scale=0.78
mkdir -p build/art
typst compile --root . --input spell="$id" --input mode=mask --input body-scale="$scale" books/debug/full-face-card.typ "build/art/$id-mask.png"
python3 scripts/spell-art-prompt.py "$id" --layout full-face --story effect-first --style woodcut --mask "build/art/$id-mask.png" --scene "$(cat "build/art/$id.txt")"
python3 scripts/spell-plates.py woodcut-frames "build/art/$id.png" --body-scale "$scale" --scene-file "build/art/$id.txt"
typst compile --root . books/illustrations-test.typ build/illustrations-test.pdf
```

При повторной генерации замените аргумент `--scene` на `--scene-from resources/illustrations/woodcut-frames/scrying.png`, подставив нужный ID.

Проверку допусков для отдельной карты можно повторить по [инструкции и эталонному листу](../../../docs/cards/masks.md#приёмка-при-смещении-реза). Если тесно, сместите или умеренно уменьшите всю нижнюю группу, сохраняя пропорции фигур и свободное поле под последней строкой. Дорисуйте землю вокруг новой постановки до обоих углов. Сверьте карточку с окончательным текстом.
