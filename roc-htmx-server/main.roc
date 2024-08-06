app [main] {
    # pf: platform "https://github.com/roc-lang/basic-webserver/releases/download/0.6.0/LQS_Avcf8ogi1SqwmnytRD4SMYiZ4UcRCZwmAjj1RNY.tar.gz",
    pf: platform "https://github.com/roc-lang/basic-webserver/releases/download/0.5.0/Vq-iXfrRf-aHxhJpAh71uoVUlC-rsWvmjzTYOJKhu4M.tar.br",
    html: "https://github.com/Hasnep/roc-html/releases/download/v0.6.0/IOyNfA4U_bCVBihrs95US9Tf5PGAWh3qvrBN4DRbK5c.tar.br",
    pg: "https://github.com/agu-z/roc-pg/releases/download/0.1.0/nb1q6kN1pu1xvv45w2tE7JjbQ60hOyR1NMxxhRMCVFc.tar.br",
}

import pf.Stdout
import pf.Stderr
import pf.Task exposing [Task]
import pf.Http exposing [Request, Response]
import pf.Command
import pf.Env
import pf.Url
import pf.Utc
import html.Html
import pg.Pg.Client
import pg.Pg.Cmd
import pg.Pg.Result

main : Request -> Task Response []
main = \req ->

    responseTask =
        logRequest! req
        #dbPath = readEnvVar! "DB_PATH"

        splitUrl =
            req.url
            |> Url.fromStr
            |> Url.path
            |> Str.split "/"

        dbg splitUrl

        # Route to handler based on url path
        when splitUrl is
            #["", ""] -> byteResponse 200 todoHtml
            ["", "books", ..] -> routeBooks req
            _ -> htmlResponse (Html.h1 [] [Html.text "URL Not Found (404)"])

    # Handle any application errors
    responseTask |> Task.onErr handleErr

routeBooks : Request -> Task Response _
routeBooks = \req ->
    Stdout.line! "routeBooks"
    dbg req.method

    when req.method is
        Get ->
            Stdout.line! "Get"
            listBooks
        _ ->
            Stdout.line! "Other"
            Task.ok {
                status: 405,
                headers: [],
                body: Str.toUtf8 "Method Not Allowed",
            }
    
listBooks : Task Response []_
listBooks =
    Stdout.line! "listBooks"
    view = Html.div [] [
        Html.h1 [] [Html.text "Books"]
    ]
    htmlResponse view

AppError : [
    EnvVarNotSet Str,
]

Book : {
    id: Str,
    name: Str,
}

queryBooks : Task (List Book) []_
queryBooks =
    Stdout.line! "queryBooks"
    Pg.Cmd.new "SELECT id, name FROM grokkr.books"
    |> Pg.Cmd.expectN (
        Pg.Result.succeed { 
            id: <- Pg.Result.str "id" |> Pg.Result.apply, 
            name: <- Pg.Result.str "name" |> Pg.Result.apply
        }
    ) 
    |> runDb

runDb : Pg.Cmd.Cmd a err -> Task a _
runDb = \cmd ->
    client <- Pg.Client.withConnect {
            host: "localhost",
            port: 5432,
            user: "postgres",
            database: "grokkr",
        }
        
    Stdout.line! (Pg.Cmd.inspect cmd)

    Pg.Client.command cmd client

htmlResponse : Html.Node -> Task Response []_
htmlResponse = \html ->
    Stdout.line! "htmlResponse"

    Task.ok {
        status: 200,
        headers: [
            { name: "Content-Type", value: Str.toUtf8 "text/html; charset=utf-8" },
        ],
        body: Str.toUtf8 (Html.render html),
    }


readEnvVar : Str -> Task Str [EnvVarNotSet Str]_
readEnvVar = \envVarName ->
    Env.var envVarName
    |> Task.mapErr \_ -> EnvVarNotSet envVarName

logRequest : Request -> Task {} _
logRequest = \req ->
    datetime = Utc.now! |> Utc.toIso8601Str

    Stdout.line "$(datetime) $(Http.methodToStr req.method) $(req.url)"

handleErr : AppError -> Task Response _
handleErr = \appErr ->
    # Build error message
    errMsg =
        when appErr is
            EnvVarNotSet varName -> "Environment variable \"$(varName)\" was not set. Please set it to the path of todos.db"
    # Log error to stderr
    Stderr.line! "Internal Server Error:\n\t$(errMsg)"
    _ <- Stderr.flush |> Task.attempt

    # Respond with Http 500 Error
    Task.ok {
        status: 500,
        headers: [],
        body: Str.toUtf8 "Internal Server Error.\n",
    }