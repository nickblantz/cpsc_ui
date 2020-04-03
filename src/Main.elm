module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Page
import Pages.Home as Home
import Pages.Login as Login
import Pages.RecallPriority as RecallPriority



-- MAIN


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }



-- MODEL


type Page
    = Home Home.Model
    | Login Login.Model
    | RecallPriority RecallPriority.Model


type alias Model =
    { cur_page : Page
    }


init : Model
init =
    Model (RecallPriority RecallPriority.init)



-- UPDATE


type Msg
    = GotHomeMsg Home.Msg
    | GotLoginMsg Login.Msg
    | GotRecallPriorityMsg RecallPriority.Msg


update : Msg -> Model -> Model
update msgType modelType =
    case ( msgType, modelType.cur_page ) of
        ( GotHomeMsg msg, Home model ) ->
            { modelType | cur_page = Home (Home.update msg model) }

        ( GotLoginMsg msg, Login model ) ->
            { modelType | cur_page = Login (Login.update msg model) }

        ( GotRecallPriorityMsg msg, RecallPriority model ) ->
            { modelType | cur_page = RecallPriority (RecallPriority.update msg model) }

        ( _, _ ) ->
            modelType



-- VIEW


view : Model -> Html Msg
view mainModel =
    let
        viewPage page toMsg { title, content } =
            Page.viewPage page { title = title, content = Html.map toMsg content }
    in
    case mainModel.cur_page of
        Home model ->
            viewPage Page.Home GotHomeMsg (Home.view model)

        Login model ->
            viewPage Page.Login GotLoginMsg (Login.view model)

        RecallPriority model ->
            viewPage Page.RecallPriority GotRecallPriorityMsg (RecallPriority.view model)
