app [main] { pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.12.0/Lb8EgiejTUzbggO2HVVuPJFkwvvsfW6LojkLR20kTVE.tar.br" }

import pf.Stdout
import pf.Task

total = addAndStringify { birds: 5, iguanas: 7 }

main =
    Stdout.line! "There are $(total) animals."

# addAndStringify = \counts ->
addAndStringify = \{ birds, iguanas } ->
    dbg birds

    dbg iguanas

    sum = birds + iguanas

    if sum == 0 then
        ""
    else if sum < 0 then
        "negative"
    else
        Num.toStr sum
