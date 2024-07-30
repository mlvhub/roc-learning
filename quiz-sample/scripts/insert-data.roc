app [main] { 
    pf: platform"https://github.com/roc-lang/basic-webserver/releases/download/0.5.0/Vq-iXfrRf-aHxhJpAh71uoVUlC-rsWvmjzTYOJKhu4M.tar.br",
    json: "https://github.com/lukewilliamboswell/roc-json/releases/download/0.10.0/KbIfTNbxShRX1A1FgXei1SpO5Jn8sgP6HP6PXbi-xyA.tar.br",
}

import pf.Stdout
import pf.Task

insertBook : { path: Str, id: Uuid, name: Str } -> Task {} [SqlError _]_
insertBook = \{ path, id, name } ->
        SQLite3.execute {
            path,
            query: "INSERT INTO tasks (id, name) VALUES (:id, :name);",
            bindings: [
                { name: ":id", value: id },
                { name: ":name", value: name },
            ],
        }
        |> Task.mapErr SqlError
        |> Task.map \_ -> {}

main =
    dbPath = Env.var "DB_PATH" |> Task.mapErr! UnableToReadDbPATH
    