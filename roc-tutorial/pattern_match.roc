app [main] { pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.12.0/Lb8EgiejTUzbggO2HVVuPJFkwvvsfW6LojkLR20kTVE.tar.br" }

import pf.Stdout
import pf.Task

main =
    Stdout.line! (stoplightStr Red)

stoplightStr : [Red, Green, Yellow, Custom Str] -> Str
stoplightStr = \stoplight ->
    when stoplight is
        Red -> "red"
        Green | Yellow -> "not red"
        Custom description -> description
