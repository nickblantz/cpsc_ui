module Page exposing (..)

import Browser exposing (Document)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)



-- MAIN (DO NOT USE)


main : Html ()
main =
    text ""


viewPage : Html msg -> Html msg
viewPage content =
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
                        [ text "Features" ]
                    ]
                , li [ class "nav-item" ]
                    [ a [ class "nav-link", href "#" ]
                        [ text "Pricing" ]
                    ]

                -- , li [ class "nav-item dropdown" ]
                --     [ a [ class "nav-link dropdown-toggle", href "#", id "navbarDropdownMenuLink", attribute "data-toggle" "dropdown", attribute "aria-haspopup" "true", attribute "aria-expanded" "false" ]
                --         [ text "Dropdown link" ]
                --     , div [ class "dropdown-menu", attribute "aria-labelledby" "navbarDropdownMenuLink" ]
                --         [ a [ class "dropdown-item", href "#" ]
                --             [ text "Action" ]
                --         , a [ class "dropdown-item", href "#" ]
                --             [ text "Another action" ]
                --         , a [ class "dropdown-item", href "#" ]
                --             [ text "Something else here" ]
                --         ]
                --     ]
                ]
            ]
        , span [ class "navbar-text" ]
            [ text "Login / Logout" ]
        ]


viewFooter : Html msg
viewFooter =
    footer [] []
