module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Page
import Pages.Home as Home
import Pages.Login as Login



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
    = Home
    | Login


type alias Model =
    { cur_page : Page
    }


init : Model
init =
    Model Login



-- UPDATE


type Msg
    = NavigateTo Page


update : Msg -> Model -> Model
update msg model =
    case msg of
        NavigateTo page ->
            { model | cur_page = page }



-- VIEW


view : Model -> Html msg
view model =
    case model.cur_page of
        Home ->
            Page.viewPage Home.view

        Login ->
            Page.viewPage Login.view
