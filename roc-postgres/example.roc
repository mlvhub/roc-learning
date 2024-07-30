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
            auth: None,
            database: "postgres",
        }

    Stdout.line! "Connected!"

    rows =
        Pg.Cmd.new
            """
            select $1 as name, $2 as age
            union all
            select 'Julio' as name, 23 as age
            """
            |> Pg.Cmd.bind [Pg.Cmd.str "John", Pg.Cmd.u8 32]
            |> Pg.Cmd.expectN
                (
                    Pg.Result.succeed
                        (\name -> \age ->
                                ageStr = Num.toStr age

                                "$(name): $(ageStr)"
                        )
                    |> Pg.Result.with (Pg.Result.str "name")
                    |> Pg.Result.with (Pg.Result.u8 "age")
                )
            |> Pg.BasicCliClient.command! client

    Stdout.line (Str.joinWith rows "\n")
