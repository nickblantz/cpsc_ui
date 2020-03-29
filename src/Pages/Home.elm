module Pages.Home exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)



-- MAIN (DO NOT USE)


main : Html ()
main =
    text ""



-- MODEL


type alias Model =
    { some_content : String
    , some_flag : Bool
    }


init : String -> Model
init _ =
    Model "Not important" True



-- UPDATE


type Msg
    = PlaceHolder


update : Msg -> Model -> Model
update msg model =
    case msg of
        PlaceHolder ->
            { model | some_flag = not model.some_flag }



-- VIEW


view : Html msg
view =
    div [ class "container" ]
        [ div [ class "row" ]
            [ div [ class "col-12" ]
                [ text "This is the homepage"
                ]
            ]
        ]
