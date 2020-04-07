module Route exposing (..)

import Browser.Navigation as Nav
import Html exposing (Attribute, Html, text)
import Html.Attributes as Attr
import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser, oneOf, s, string)



-- MAIN (DO NOT USE)


main : Html ()
main =
    text ""


type Route
    = Root
    | Home
    | Register
    | Login
    | Logout
    | RecallPriority


parser : Parser (Route -> a) a
parser =
    oneOf
        [ Parser.map Root Parser.top
        , Parser.map Home (s "home")
        , Parser.map Register (s "register")
        , Parser.map Login (s "login")
        , Parser.map Logout (s "logout")
        , Parser.map RecallPriority (s "recall-priority")
        ]



-- PUBLIC


href : Route -> Attribute msg
href targetRoute =
    Attr.href (routeToString targetRoute)


replaceUrl : Nav.Key -> Route -> Cmd msg
replaceUrl key route =
    Nav.replaceUrl key (routeToString route)


fromUrl : Url -> Maybe Route
fromUrl url =
    { url | path = url.path, fragment = Nothing }
        |> Parser.parse parser



-- PRIVATE


routeToString : Route -> String
routeToString route =
    "/" ++ String.join "/" (routeToPieces route)


routeToPieces : Route -> List String
routeToPieces route =
    case route of
        Root ->
            []

        Home ->
            [ "home" ]

        Register ->
            [ "register" ]

        Login ->
            [ "login" ]

        Logout ->
            [ "logout" ]

        RecallPriority ->
            [ "recall-priority" ]
