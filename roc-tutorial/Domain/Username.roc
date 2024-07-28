module [Username, fromStr, toStr]

Username := Str

fromStr : Str -> Username
fromStr = \str ->
    @Username str

toStr : Username -> Str
toStr = \@Username str ->
    str

expect fromStr "roc" |> toStr == "roc"
