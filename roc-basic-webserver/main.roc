app "helloweb"
    packages { pf: "https://github.com/roc-lang/basic-webserver/releases/download/0.4.0/iAiYpbs5zdVB75golcg_YMtgexN3e2fwhsYPLPCeGzk.tar.br" }
    imports [
        pf.Stdout,
        pf.Task.{ Task },
        pf.Http.{ Request, Response },
        pf.Utc,
    ]
    provides [main] to pf

main : Request -> Task Response []
main = \req ->

    # Log request date, method and url
    date = Utc.now! |> Utc.toIso8601Str
    Stdout.line! "$(date) $(Http.methodToStr req.method) $(req.url)"

    Task.ok { status: 200, headers: [], body: Str.toUtf8 "<b>Hello, world!</b>\n" }
