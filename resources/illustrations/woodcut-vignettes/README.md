# Woodcut · виньетки

Профили: [vignette](../../../docs/illustrations/profiles/layouts/vignette/vignette.md), [effect-first](../../../docs/illustrations/profiles/stories/effect-first/effect-first.md), [woodcut](../../../docs/illustrations/profiles/aesthetics/woodcut/woodcut.md). Приложите «Пир» из woodcut/resources. Рисуйте отдельную широкую сцену около 3:1 на чисто белом фоне. Персонажи показаны целиком с одним читаемым действием. Оставьте землю под ногами, внешние края рисунка свободные. Чёрный контур карты и нижний отступ добавляет упаковщик. Название получает бордовый из style.json.

Список ID — в [тестовой книге](../../../books/illustrations-test.typ), готовые карты — в index.json. Ширина сцены по умолчанию 48,58 мм. На длинном тексте проверьте последнюю строку в деке и при необходимости уменьшите ширину. Перед публикацией уберите лишнее белое поле под сценой. Сюжет хранится в поле scene-prompt самого PNG; его можно восстановить и для другого лайаута.

```sh
id=scrying
mkdir -p build/art
python3 scripts/spell-art-prompt.py "$id" --layout vignette --story effect-first --aesthetic woodcut --scene "$(cat "build/art/$id.txt")"
python3 scripts/spell-plates.py woodcut-vignettes "build/art/$id.png" --vignette-width 48.58 --scene-file "build/art/$id.txt"
typst compile --root . books/illustrations-test.typ build/illustrations-test.pdf
```

При повторной генерации замените аргумент `--scene` на `--scene-from resources/illustrations/woodcut-vignettes/scrying.png`, подставив нужный ID.
