module Pages.Register exposing (Model, Msg, init, subscriptions, toSession, update, view)

import Data.User exposing (User, createUser)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http exposing (..)
import Regex exposing (Regex)
import Route exposing (Route, replaceUrl)
import Session exposing (Session, navKey)



-- MAIN (DO NOT USE)


main : Html ()
main =
    text ""



-- MODEL


type alias Model =
    { session : Session
    , form : Form
    , formErrors : FormErrors
    }


type alias Form =
    { email : String
    , firstName : String
    , password : String
    , passwordAgain : String
    , userType : String
    }


type alias FormErrors =
    { email : Maybe String
    , firstName : Maybe String
    , password : Maybe String
    , passwordAgain : Maybe String
    , userType : Maybe String
    }


init : Session -> ( Model, Cmd Msg )
init session =
    ( { session = session
      , form =
            { email = ""
            , firstName = ""
            , password = ""
            , passwordAgain = ""
            , userType = ""
            }
      , formErrors =
            { email = Nothing
            , firstName = Nothing
            , password = Nothing
            , passwordAgain = Nothing
            , userType = Nothing
            }
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = GotSession Session
    | UpdateEmail String
    | UpdateFirstName String
    | UpdatePassword String
    | UpdatePasswordAgain String
    | UpdateUserType String
    | SubmitRegistration
    | CancelRegistration
    | RegistrationCompleted (Result Http.Error User)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotSession session ->
            ( { model | session = session }, Cmd.none )

        UpdateEmail email ->
            updateForm
                (\form -> { form | email = email })
                (\errorForm -> { errorForm | email = validateEmail email })
                model

        UpdateFirstName firstName ->
            updateForm
                (\form -> { form | firstName = firstName })
                (\errorForm -> { errorForm | firstName = validateFirstName firstName })
                model

        UpdatePassword password ->
            updateForm
                (\form -> { form | password = password })
                (\errorForm -> { errorForm | password = validatePassword password })
                model

        UpdatePasswordAgain passwordAgain ->
            updateForm
                (\form -> { form | passwordAgain = passwordAgain })
                (\errorForm -> { errorForm | passwordAgain = validatePasswordAgain model.form.password passwordAgain })
                model

        UpdateUserType userType ->
            updateForm
                (\form -> { form | userType = userType })
                (\errorForm -> { errorForm | userType = validateUserType userType })
                model

        SubmitRegistration ->
            if isValid model.formErrors then
                ( model, createUser (convertToUser model.form) RegistrationCompleted )

            else
                ( model, Cmd.none )

        CancelRegistration ->
            ( model, Cmd.none )

        RegistrationCompleted result ->
            case result of
                Ok _ ->
                    ( model, replaceUrl (navKey model.session) Route.Login )

                Err e ->
                    ( model, Cmd.none )


isValid : FormErrors -> Bool
isValid formErrors =
    if
        Maybe.withDefault "" formErrors.email
            == ""
            && Maybe.withDefault "" formErrors.firstName
            == ""
            && Maybe.withDefault "" formErrors.password
            == ""
            && Maybe.withDefault "" formErrors.passwordAgain
            == ""
            && Maybe.withDefault "" formErrors.userType
            == ""
    then
        True

    else
        False


convertToUser : Form -> User
convertToUser form =
    User 0 form.email form.password form.firstName form.userType


updateForm : (Form -> Form) -> (FormErrors -> FormErrors) -> Model -> ( Model, Cmd Msg )
updateForm transformForm transformFormErrors model =
    ( { model | form = transformForm model.form, formErrors = transformFormErrors model.formErrors }, Cmd.none )


validateEmail : String -> Maybe String
validateEmail email =
    let
        regex =
            "^[a-zA-Z0-9.!#$%&'*+\\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
                |> Regex.fromStringWith { caseInsensitive = True, multiline = False }
                |> Maybe.withDefault Regex.never
    in
    if Regex.contains regex email then
        Nothing

    else
        Just "Invalid Email"


validateFirstName : String -> Maybe String
validateFirstName firstName =
    let
        regex =
            "^[a-zA-Z]+$"
                |> Regex.fromStringWith { caseInsensitive = True, multiline = False }
                |> Maybe.withDefault Regex.never
    in
    if Regex.contains regex firstName then
        Nothing

    else
        Just "Invalid First Name"


validatePassword : String -> Maybe String
validatePassword password =
    let
        regex =
            "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$"
                |> Regex.fromStringWith { caseInsensitive = False, multiline = False }
                |> Maybe.withDefault Regex.never
    in
    if Regex.contains regex password then
        Nothing

    else
        Just "Invalid Password"


validatePasswordAgain : String -> String -> Maybe String
validatePasswordAgain password passwordAgain =
    if password == passwordAgain then
        Nothing

    else
        Just "Passwords do not match"


validateUserType : String -> Maybe String
validateUserType userType =
    if userType == "Manager" || userType == "Investigator" || userType == "Vendor" then
        Nothing

    else
        Just "Invalid User Type"



-- VIEW


view : Model -> { title : String, content : Html Msg }
view model =
    { title = "Register"
    , content =
        div [ class "container" ]
            [ div [ class "row justify-content-center" ]
                [ h2 [ class "col-xl-6 col-lg-10 col-sm-12" ] [ text "Registration" ]
                ]
            , div [ class "row form-group justify-content-center" ]
                [ label [ for "inputEmail", class "col-sm-2 col-form-label" ]
                    [ text "Email" ]
                , div [ class "col-xl-3 col-lg-5 col-sm-10" ]
                    [ input [ type_ "text", class "form-control", id "inputEmail", placeholder "email@example.com", value model.form.email, onInput UpdateEmail ] []
                    , case model.formErrors.email of
                        Just errorMessage ->
                            span [ class "text-danger" ] [ text errorMessage ]

                        Nothing ->
                            text ""
                    ]
                ]
            , div [ class "row form-group justify-content-center" ]
                [ label [ for "inputFirstName", class "col-sm-2 col-form-label" ]
                    [ text "First Name" ]
                , div [ class "col-xl-3 col-lg-5 col-sm-10" ]
                    [ input [ type_ "text", class "form-control", id "inputFirstName", placeholder "First Name", value model.form.firstName, onInput UpdateFirstName ] []
                    , case model.formErrors.firstName of
                        Just errorMessage ->
                            span [ class "text-danger" ] [ text errorMessage ]

                        Nothing ->
                            text ""
                    ]
                ]
            , div [ class "row form-group justify-content-center" ]
                [ label [ for "inputPassword", class "col-sm-2 col-form-label" ]
                    [ text "Password" ]
                , div [ class "col-xl-3 col-lg-5 col-sm-10" ]
                    [ input [ type_ "password", class "form-control", id "inputPassword", placeholder "Password", value model.form.password, onInput UpdatePassword ] []
                    , case model.formErrors.password of
                        Just errorMessage ->
                            span [ class "text-danger" ] [ text errorMessage ]

                        Nothing ->
                            text ""
                    ]
                ]
            , div [ class "row form-group justify-content-center" ]
                [ label [ for "inputPasswordAgain", class "col-sm-2 col-form-label" ]
                    [ text "Password Again" ]
                , div [ class "col-xl-3 col-lg-5 col-sm-10" ]
                    [ input [ type_ "password", class "form-control", id "inputPasswordAgain", placeholder "Password", value model.form.passwordAgain, onInput UpdatePasswordAgain ] []
                    , case model.formErrors.passwordAgain of
                        Just errorMessage ->
                            span [ class "text-danger" ] [ text errorMessage ]

                        Nothing ->
                            text ""
                    ]
                ]
            , div [ class "row form-group justify-content-center" ]
                [ label [ for "inputUserType", class "col-sm-2 col-form-label" ]
                    [ text "User Type" ]
                , div [ class "col-xl-3 col-lg-5 col-sm-10" ]
                    [ input [ class "form-control", id "inputUserType", Html.Attributes.list "userTypeList", onInput UpdateUserType ] []
                    , datalist [ id "userTypeList" ]
                        [ option [ value "Manager", selected True ] []
                        , option [ value "Investigator" ] []
                        , option [ value "Vendor" ] []
                        ]
                    , case model.formErrors.userType of
                        Just errorMessage ->
                            span [ class "text-danger" ] [ text errorMessage ]

                        Nothing ->
                            text ""
                    ]
                ]
            , div [ class "row form-group justify-content-center" ]
                [ button [ type_ "button", class "btn btn-primary mx-5", onClick SubmitRegistration ] [ text "Register" ]
                , button [ type_ "button", class "btn btn-danger mx-5", onClick CancelRegistration ] [ text "Cancel" ]
                ]
            ]
    }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- EXPORTS


toSession : Model -> Session
toSession model =
    model.session
