module Pages.Login exposing (Model, Msg(..), init, subscriptions, toSession, update, view)

import Data.User exposing (User, loginUser, userEncoder)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Encode as JE
import Session exposing (Session, storeUser)



-- MAIN (DO NOT USE)


main : Html ()
main =
    text ""



-- MODEL


type alias Model =
    { session : Session
    , form : Form
    , error : String
    }


type alias Form =
    { email : String
    , password : String
    }


init : Session -> ( Model, Cmd Msg )
init session =
    ( { session = session
      , form =
            { email = ""
            , password = ""
            }
      , error = ""
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = GotSession Session
    | UpdateEmail String
    | UpdatePassword String
    | SubmitLogin
    | CancelLogin
    | LoginCompleted (Result Http.Error User)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotSession session ->
            ( { model | session = session }, Cmd.none )

        UpdateEmail email ->
            updateForm
                (\form -> { form | email = email })
                model

        UpdatePassword password ->
            updateForm
                (\form -> { form | password = password })
                model

        SubmitLogin ->
            ( model, loginUser model.form LoginCompleted )

        CancelLogin ->
            ( model, Cmd.none )

        LoginCompleted result ->
            case result of
                Ok user ->
                    ( model, Cmd.none )

                Err e ->
                    ( { model | error = "Invalid email or password" }, Cmd.none )


updateForm : (Form -> Form) -> Model -> ( Model, Cmd Msg )
updateForm transformForm model =
    ( { model | form = transformForm model.form }, Cmd.none )



-- VIEW


view : Model -> { title : String, content : Html Msg }
view model =
    { title = "Login"
    , content =
        div [ class "" ]
            [ br [] []
            , br [] []
            , div [ class "container" ]
                [ div [ class "row justify-content-center" ]
                    [ h2 [ class "col-xl-6 col-lg-10 col-sm-12" ] [ text "Login" ]
                    ]
                , div [ class "row form-group justify-content-center" ]
                    [ label [ for "inputEmail", class "col-sm-2 col-form-label" ]
                        [ text "Email" ]
                    , div [ class "col-xl-3 col-lg-5 col-sm-10" ]
                        [ input [ type_ "text", class "form-control", id "inputEmail", placeholder "email@example.com", autofocus True, value model.form.email, onInput UpdateEmail ] []
                        ]
                    ]
                , div [ class "row form-group justify-content-center" ]
                    [ label [ for "inputPassword", class "col-sm-2 col-form-label" ]
                        [ text "Password" ]
                    , div [ class "col-xl-3 col-lg-5 col-sm-10" ]
                        [ input [ type_ "password", class "form-control", id "inputPassword", placeholder "Password", value model.form.password, onInput UpdatePassword ] []
                        ]
                    ]
                , div [ class "row form-group justify-content-center" ]
                    [ p [ class "text-danger justify-text" ] [ text model.error ]
                    ]
                , div [ class "row form-group justify-content-center" ]
                    [ button [ type_ "button", class "btn btn-primary mx-5", onClick SubmitLogin ] [ text "Login" ]
                    , button [ type_ "button", class "btn btn-danger mx-5", onClick CancelLogin ] [ text "Cancel" ]
                    ]
                ]
            ]
    }



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- EXPORTS


toSession : Model -> Session
toSession model =
    model.session
