module Pages.Logout exposing (Model, Msg, init, subscriptions, toSession, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Session exposing (Session)



-- MAIN (DO NOT USE)


main : Html ()
main =
    text ""



-- MODEL


type alias Model =
    { session : Session
    }


init : Session -> ( Model, Cmd Msg )
init session =
    ( Model session, Cmd.none )



-- UPDATE


type Msg
    = GotSession Session


update : Msg -> Model -> Model
update msg model =
    case msg of
        GotSession session ->
            { model | session = session }



-- VIEW


view : Model -> { title : String, content : Html Msg }
view model =
    { title = "Logout"
    , content =
        text ""
    }



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- EXPORTS


toSession : Model -> Session
toSession model =
    model.session
