app [main] {
    pg: "https://github.com/agu-z/roc-pg/releases/download/0.1.0/nb1q6kN1pu1xvv45w2tE7JjbQ60hOyR1NMxxhRMCVFc.tar.br",
    pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.10.0/vNe6s9hWzoTZtFmNkvEICPErI9ptji_ySjicO6CkucY.tar.br",
}

import pf.Task exposing [Task, await]
import pf.Stdout
import pg.Pg.Cmd
import pg.Pg.BasicCliClient
import pg.Pg.Result

main =
    client <- Pg.BasicCliClient.withConnect {
            host: "localhost",
            port: 5432,
            user: "postgres",
            auth: Password "postgres",
            database: "grokkr",
        }

    Stdout.line! "Connected!"

    rows =
        Pg.Cmd.new
            """
            select id, name from grokkr.books
            """
            |> Pg.Cmd.expectN
                (
                    Pg.Result.succeed
                        (\id -> \name ->
                                "$(id): $(name)"
                        )
                    |> Pg.Result.with (Pg.Result.str "id")
                    |> Pg.Result.with (Pg.Result.str "name")
                )
            |> Pg.BasicCliClient.command! client

    Stdout.line (Str.joinWith rows "\n")
