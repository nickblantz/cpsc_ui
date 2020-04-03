module Page exposing (..)

import Browser exposing (Document)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


type Page
    = Home
    | Login
    | RecallPriority



-- MAIN (DO NOT USE)


main : Html ()
main =
    text ""


viewPage : Page -> { title : String, content : Html msg } -> Html msg
viewPage page { title, content } =
    div []
        [ viewHeader
        , content
        , viewFooter
        ]


viewHeader : Html msg
viewHeader =
    nav [ class "navbar navbar-expand-lg navbar-light bg-light justify-content-between" ]
        [ a [ class "navbar-brand", href "#" ]
            [ img [ src "https://www.cpsc.gov/sites/all/themes/cpsc/images/logo.png", alt "Logo", height 30, width 30 ] []
            , text " CPSC Site"
            ]
        , button [ class "navbar-toggler", type_ "button", attribute "data-toggle" "collapse", attribute "data-target" "#navbarNavDropdown", attribute "aria-controls" "navbarNavDropdown", attribute "aria-expanded" "false", attribute "aria-label" "Toggle navigation" ]
            [ span [ class "navbar-toggler-icon" ]
                []
            ]
        , div [ class "collapse navbar-collapse", id "navbarNavDropdown" ]
            [ ul [ class "navbar-nav" ]
                [ li [ class "nav-item active" ]
                    [ a [ class "nav-link", href "#" ]
                        [ text "Home"
                        , span
                            [ class "sr-only" ]
                            [ text "(current)" ]
                        ]
                    ]
                , li [ class "nav-item" ]
                    [ a [ class "nav-link", href "#" ]
                        [ text "Prioritize Recalls" ]
                    ]
                , li [ class "nav-item" ]
                    [ a [ class "nav-link", href "#" ]
                        [ text "Manage Investigators" ]
                    ]
                ]
            ]
        , span [ class "navbar-text" ]
            [ text "Logout" ]
        ]


viewFooter : Html msg
viewFooter =
    footer [] []
