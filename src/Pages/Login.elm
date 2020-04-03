module Pages.Login exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)



-- MAIN (DO NOT USE)


main : Html ()
main =
    text ""



-- MODEL


type alias Model =
    { email : String
    , password : String
    , login_attempts : Int
    }


init : Model
init =
    Model "" "" 0



-- UPDATE


type Msg
    = LoginAttempt
    | EmailUpdate String
    | PasswordUpdate String


update : Msg -> Model -> Model
update msg model =
    case msg of
        LoginAttempt ->
            { model | login_attempts = model.login_attempts + 1 }

        EmailUpdate s ->
            { model | email = s }

        PasswordUpdate s ->
            { model | password = s }



-- VIEW


view : Model -> { title : String, content : Html Msg }
view model =
    { title = "Login Page"
    , content =
        div []
            [ div [ class "container" ]
                [ div [ id "login-row", class "row justify-content-center align-items-center" ]
                    [ div [ id "login-column", class "col-md-6" ]
                        [ div [ id "login-box", class "col-md-12" ]
                            [ Html.form [ class "form" ]
                                [ h3 [ class "text-center text-info" ]
                                    [ text "Login" ]
                                , div [ class "form-group" ]
                                    [ label [ for "username", class "text-info" ]
                                        [ text "Username:" ]
                                    , br []
                                        []
                                    , input [ type_ "text", name "username", class "form-control" ]
                                        []
                                    ]
                                , div [ class "form-group" ]
                                    [ label [ for "password", class "text-info" ]
                                        [ text "Password:" ]
                                    , br []
                                        []
                                    , input [ type_ "password", name "password", class "form-control" ]
                                        []
                                    ]
                                , div [ class "form-group" ]
                                    [ label [ for "remember-me", class "text-info" ]
                                        [ span []
                                            [ text "Remember me" ]
                                        , span []
                                            [ input [ name "remember-me", type_ "checkbox" ]
                                                []
                                            ]
                                        ]
                                    , br []
                                        []
                                    , input [ type_ "submit", name "submit", class "btn btn-info btn-md", value "submit" ]
                                        []
                                    ]
                                , div [ class "text-right" ]
                                    [ a [ href "#", class "text-info" ]
                                        [ text "Register here" ]
                                    ]
                                ]
                            ]
                        ]
                    ]
                ]
            ]
    }
