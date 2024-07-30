app [main] { 
    pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.12.0/Lb8EgiejTUzbggO2HVVuPJFkwvvsfW6LojkLR20kTVE.tar.br" ,
    pg: "https://github.com/agu-z/roc-pg/releases/download/0.1.0/nb1q6kN1pu1xvv45w2tE7JjbQ60hOyR1NMxxhRMCVFc.tar.br",
}

import pf.Stdout
import pf.Task
import pg.Pg.Client
import pg.Pg.Cmd

main =
    Pg.Cmd.new "select id, name from products"
    |> runDb
    |> Stdout.line!

runDb : Pg.Cmd.Cmd a err -> Task a _
runDb = \cmd ->
    # Currently creating a connection per request.
    # We will support pooling in the future, but we need to come up with some new platform primitives.
    client <- Pg.Client.withConnect {
            host: "localhost",
            port: 5432,
            user: "postgres",
            database: "roc_pg_example",
        }

    Stdout.line! (Pg.Cmd.inspect cmd)

    Pg.Client.command cmd client
