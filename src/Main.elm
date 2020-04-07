module Main exposing (..)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Json.Decode as JD
import Page exposing (viewPage)
import Pages.Blank as Blank
import Pages.Home as Home
import Pages.Login as Login exposing (Msg(..))
import Pages.Logout as Logout
import Pages.NotFound as NotFound
import Pages.RecallPriority as RecallPriority
import Pages.Register as Register
import Route exposing (Route, replaceUrl)
import Session exposing (Session, loginUser, logoutUser)
import Url exposing (Url)
import Url.Parser exposing ((</>), Parser, int, map, oneOf, s, string)



-- MAIN


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = ChangedUrl
        , onUrlRequest = ClickedLink
        }



-- MODEL


type Model
    = Redirect Session
    | NotFound Session
    | Home Home.Model
    | Login Login.Model
    | Logout Logout.Model
    | Register Register.Model
    | RecallPriority RecallPriority.Model


init : blank -> Url -> Nav.Key -> ( Model, Cmd Msg )
init maybeAuth url navKey =
    changeRouteTo
        (Route.fromUrl url)
        (Redirect (Session.init navKey Nothing))



-- UPDATE


type Msg
    = GotHomeMsg Home.Msg
    | GotRegisterMsg Register.Msg
    | GotLoginMsg Login.Msg
    | GotLogoutMsg Logout.Msg
    | GotRecallPriorityMsg RecallPriority.Msg
    | UserLoggedIn
    | ChangedUrl Url
    | ClickedLink Browser.UrlRequest


update : Msg -> Model -> ( Model, Cmd Msg )
update mainMsg mainModel =
    let
        session =
            toSession mainModel
    in
    case ( mainMsg, mainModel ) of
        ( GotHomeMsg msg, Home model ) ->
            ( Home (Home.update msg model), Cmd.none )

        ( GotRegisterMsg msg, Register model ) ->
            Register.update msg model
                |> updateWith Register GotRegisterMsg mainModel

        ( GotLoginMsg msg, Login model ) ->
            case msg of
                Login.LoginCompleted result ->
                    case result of
                        Ok user ->
                            ( Home { session = loginUser session user }, replaceUrl (Session.navKey session) Route.Home )

                        Err _ ->
                            Login.update msg model
                                |> updateWith Login GotLoginMsg mainModel

                _ ->
                    Login.update msg model
                        |> updateWith Login GotLoginMsg mainModel

        ( GotLogoutMsg msg, Logout model ) ->
            ( Logout (Logout.update msg model), Cmd.none )

        ( GotRecallPriorityMsg msg, RecallPriority model ) ->
            RecallPriority.update msg model
                |> updateWith RecallPriority GotRecallPriorityMsg mainModel

        ( ClickedLink urlRequest, _ ) ->
            case urlRequest of
                Browser.Internal url ->
                    ( mainModel
                    , Nav.pushUrl (Session.navKey session) (Url.toString url)
                    )

                Browser.External href ->
                    ( mainModel
                    , Nav.load href
                    )

        ( ChangedUrl url, _ ) ->
            changeRouteTo (Route.fromUrl url) mainModel

        ( _, _ ) ->
            ( mainModel, Cmd.none )


changeRouteTo : Maybe Route -> Model -> ( Model, Cmd Msg )
changeRouteTo maybeRoute model =
    let
        session =
            toSession model
    in
    case maybeRoute of
        Nothing ->
            ( NotFound session, Cmd.none )

        Just Route.Root ->
            ( model, replaceUrl (Session.navKey session) Route.Home )

        Just Route.Home ->
            Home.init session
                |> updateWith Home GotHomeMsg model

        Just Route.Login ->
            Login.init session
                |> updateWith Login GotLoginMsg model

        Just Route.Logout ->
            ( Home { session = logoutUser session }, replaceUrl (Session.navKey session) Route.Home )

        Just Route.Register ->
            Register.init session
                |> updateWith Register GotRegisterMsg model

        Just Route.RecallPriority ->
            RecallPriority.init session
                |> updateWith RecallPriority GotRecallPriorityMsg model


updateWith : (subModel -> Model) -> (subMsg -> Msg) -> Model -> ( subModel, Cmd subMsg ) -> ( Model, Cmd Msg )
updateWith toModel toMsg model ( subModel, subCmd ) =
    ( toModel subModel
    , Cmd.map toMsg subCmd
    )


toSession : Model -> Session
toSession mainModel =
    case mainModel of
        Redirect session ->
            session

        NotFound session ->
            session

        Home model ->
            Home.toSession model

        Login model ->
            Login.toSession model

        Logout model ->
            Logout.toSession model

        Register model ->
            Register.toSession model

        RecallPriority model ->
            RecallPriority.toSession model



-- VIEW


view : Model -> Browser.Document Msg
view mainModel =
    let
        session =
            toSession mainModel

        viewPage page toMsg { title, content } =
            Page.viewPage session page { title = title, content = Html.map toMsg content }
    in
    case mainModel of
        Redirect _ ->
            Page.viewPage session Page.Other Blank.view

        NotFound _ ->
            Page.viewPage session Page.Other NotFound.view

        Home model ->
            viewPage Page.Home GotHomeMsg (Home.view model)

        Register model ->
            viewPage Page.Register GotRegisterMsg (Register.view model)

        Login model ->
            viewPage Page.Login GotLoginMsg (Login.view model)

        Logout model ->
            viewPage Page.Logout GotLogoutMsg (Logout.view model)

        RecallPriority model ->
            viewPage Page.RecallPriority GotRecallPriorityMsg (RecallPriority.view model)



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
