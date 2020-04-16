module Page exposing (..)

import Browser exposing (Document)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Route exposing (Route, routeToString)
import Session exposing (Session)


type Page
    = Other
    | Home
    | Register
    | Login
    | Logout
    | RecallPriority
    | Violation



-- MAIN (DO NOT USE)


main : Html ()
main =
    text ""


viewPage : Session -> Page -> { title : String, content : Html msg } -> Document msg
viewPage session page { title, content } =
    { title = title
    , body =
        [ viewHeader session page
        , content
        , viewFooter
        ]
    }


viewHeader : Session -> Page -> Html msg
viewHeader session page =
    nav [ class "navbar navbar-expand-md navbar-light bg-light justify-content-between" ]
        (a [ class "navbar-brand", href "#" ]
            [ img [ class "my-0", src "https://www.cpsc.gov/sites/all/themes/cpsc/images/logo.png", alt "Logo", height 30, width 30 ] []
            , text " CPSC Site"
            ]
            :: viewNavbar session page
        )


viewNavbar : Session -> Page -> List (Html msg)
viewNavbar session page =
    let
        menuItems =
            case session of
                Session.Anonymous _ ->
                    [ ( page, Route.Home, [ text "Home" ] ) ]

                Session.Manager _ _ ->
                    [ ( page, Route.Home, [ text "Home" ] )
                    , ( page, Route.RecallPriority, [ text "Recall Prioritization" ] )
                    , ( page, Route.Violation, [ text "Violations" ] )
                    ]

                Session.Investigator _ _ ->
                    [ ( page, Route.Home, [ text "Home" ] )
                    , ( page, Route.Violation, [ text "Violations" ] )
                    ]

                Session.Vendor _ _ ->
                    [ ( page, Route.Home, [ text "Home" ] ) ]
    in
    [ button [ class "navbar-toggler", type_ "button", attribute "data-toggle" "collapse", attribute "data-target" "#navbarNavDropdown", attribute "aria-controls" "navbarNavDropdown", attribute "aria-expanded" "false", attribute "aria-label" "Toggle navigation" ]
        [ span [ class "navbar-toggler-icon" ]
            []
        ]
    , div [ class "collapse navbar-collapse", id "navbarNavDropdown" ]
        [ ul [ class "navbar-nav" ]
            (List.map navbarLink menuItems)
        ]
    , viewAccountInfo session
    ]


navbarLink : ( Page, Route, List (Html msg) ) -> Html msg
navbarLink ( page, route, linkContent ) =
    li [ classList [ ( "nav-item", True ), ( "active", isActive page route ) ] ]
        [ a [ class "nav-link", href (routeToString route) ]
            linkContent
        ]


isActive : Page -> Route -> Bool
isActive page route =
    case ( page, route ) of
        ( Home, Route.Home ) ->
            True

        ( Register, Route.Register ) ->
            True

        ( Login, Route.Login ) ->
            True

        ( Logout, Route.Logout ) ->
            True

        ( RecallPriority, Route.RecallPriority ) ->
            True

        ( Violation, Route.Violation ) ->
            True

        _ ->
            False


viewAccountInfo : Session -> Html msg
viewAccountInfo session =
    case session of
        Session.Anonymous _ ->
            div []
                [ a [ class "navbar-text", href (routeToString Route.Register) ]
                    [ text "Register" ]
                , text " / "
                , a [ class "navbar-text", href (routeToString Route.Login) ]
                    [ text "Login" ]
                ]

        _ ->
            div []
                [ a [ class "navbar-text", href (routeToString Route.Logout) ]
                    [ text "Logout" ]
                ]


viewFooter : Html msg
viewFooter =
    footer [] []
