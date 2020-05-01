module Pages.Violation exposing (Model, Msg(..), init, toSession, update, view)

import Data.Email exposing (Email, createEmail)
import Data.Violation exposing (Violation, searchViolations, updateViolation)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Regex
import Route exposing (replaceUrl)
import Session exposing (Session, getUser, navKey)



-- MAIN (DO NOT USE)


main : Html ()
main =
    text ""



-- MODEL


type alias Model =
    { session : Session
    , violationList : List Violation
    , detailsModal : Maybe Violation
    , confirmationModal : Maybe ( Violation, ConfirmationForm, ConfirmationFormErrors )
    }


type alias ConfirmationForm =
    { investigatorId : Int
    , violationId : Int
    , contactEmail : String
    , fullName : String
    , marketplace : String
    }


type alias ConfirmationFormErrors =
    { contactEmail : Maybe String
    , fullName : Maybe String
    , marketplace : Maybe String
    }


blankConfirmationFormErrors : ConfirmationFormErrors
blankConfirmationFormErrors =
    ConfirmationFormErrors Nothing Nothing Nothing


type ConfirmationFormField
    = ContactEmail
    | FullName
    | Marketplace


initConfirmationForm : Session -> Int -> ConfirmationForm
initConfirmationForm session violationId =
    case getUser session of
        Just user ->
            ConfirmationForm user.userId violationId "" "" ""

        Nothing ->
            ConfirmationForm 0 violationId "" "" ""


init : Session -> ( Model, Cmd Msg )
init session =
    case session of
        Session.Investigator _ _ ->
            ( Model session [] Nothing Nothing
            , searchViolations "Possible" UpdateViolationList
            )

        Session.Manager _ _ ->
            ( Model session [] Nothing Nothing
            , searchViolations "Possible" UpdateViolationList
            )

        _ ->
            ( Model session [] Nothing Nothing
            , replaceUrl (navKey session) Route.Home
            )



-- UPDATE


type Msg
    = OpenDetails Violation
    | CloseDetails
    | OpenConfirmationForm Violation
    | CloseConfirmationForm
    | UpdateConfirmationForm ConfirmationFormField String
    | UpdateViolationList (Result Http.Error (List Violation))
    | SetViolationStatus Violation String
    | UpdateViolation (Result Http.Error Violation)
    | MarkViolationAsConfirmed Violation ConfirmationForm ConfirmationFormErrors
    | AndCreateEmail Int ConfirmationForm (Result Http.Error Violation)
    | CreateEmailResult (Result Http.Error Email)


update : Msg -> Model -> ( Model, Cmd Msg )
update cmd model =
    case cmd of
        OpenDetails violation ->
            ( { model | detailsModal = Just violation }, Cmd.none )

        CloseDetails ->
            ( { model | detailsModal = Nothing }, Cmd.none )

        OpenConfirmationForm violation ->
            ( { model | confirmationModal = Just ( violation, initConfirmationForm (toSession model) violation.violationId, blankConfirmationFormErrors ) }, Cmd.none )

        CloseConfirmationForm ->
            ( { model | confirmationModal = Nothing }, Cmd.none )

        UpdateConfirmationForm updateField value ->
            case updateField of
                ContactEmail ->
                    updateConfirmationModal
                        (\form -> { form | contactEmail = value })
                        (\errorForm -> { errorForm | contactEmail = validateEmail value })
                        model

                FullName ->
                    updateConfirmationModal
                        (\form -> { form | fullName = value })
                        (\errorForm -> { errorForm | fullName = validateFullName value })
                        model

                Marketplace ->
                    updateConfirmationModal
                        (\form -> { form | marketplace = value })
                        (\errorForm -> { errorForm | marketplace = validateMarketplace value })
                        model

        UpdateViolationList result ->
            case result of
                Ok violationList ->
                    ( { model | violationList = violationList }, Cmd.none )

                Err _ ->
                    ( { model | violationList = [ Data.Violation.blankViolation ] }, Cmd.none )

        SetViolationStatus violation status ->
            ( model, updateViolation { violation | violationStatus = status } UpdateViolation )

        UpdateViolation result ->
            case result of
                Ok violation ->
                    let
                        updateViolations oldViolation =
                            if oldViolation.violationId == violation.violationId then
                                violation

                            else
                                oldViolation
                    in
                    ( { model | violationList = List.map updateViolations model.violationList }, Cmd.none )

                Err _ ->
                    ( model, Cmd.none )

        MarkViolationAsConfirmed violation confirmationForm confirmationFormErrors ->
            if isFormValid confirmationFormErrors then
                ( model
                , updateViolation { violation | violationStatus = "Confirmed" } (AndCreateEmail violation.violationId confirmationForm)
                )

            else
                ( model, Cmd.none )

        AndCreateEmail violationId confirmationForm result ->
            case result of
                Ok violation ->
                    let
                        updateViolations oldViolation =
                            if oldViolation.violationId == violation.violationId then
                                violation

                            else
                                oldViolation

                        newEmail =
                            Email -1 confirmationForm.contactEmail confirmationForm.fullName confirmationForm.marketplace violationId
                    in
                    ( { model | violationList = List.map updateViolations model.violationList }
                    , createEmail newEmail CreateEmailResult
                    )

                Err _ ->
                    ( model, Cmd.none )

        CreateEmailResult _ ->
            ( { model | confirmationModal = Nothing }, Cmd.none )


isFormValid : ConfirmationFormErrors -> Bool
isFormValid confirmationFormErrors =
    let
        isFieldValid field =
            Maybe.withDefault "" field == ""
    in
    isFieldValid confirmationFormErrors.contactEmail
        && isFieldValid confirmationFormErrors.fullName
        && isFieldValid confirmationFormErrors.marketplace


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


validateFullName : String -> Maybe String
validateFullName string =
    let
        regex =
            "^[a-zA-Z.\\s]+$"
                |> Regex.fromStringWith { caseInsensitive = True, multiline = False }
                |> Maybe.withDefault Regex.never
    in
    if Regex.contains regex string then
        Nothing

    else
        Just "Invalid Name"


validateMarketplace : String -> Maybe String
validateMarketplace string =
    let
        regex =
            "^[0-9a-zA-Z.\\s\\/]+$"
                |> Regex.fromStringWith { caseInsensitive = True, multiline = False }
                |> Maybe.withDefault Regex.never
    in
    if Regex.contains regex string then
        Nothing

    else
        Just "Invalid Marketplace"


updateConfirmationModal : (ConfirmationForm -> ConfirmationForm) -> (ConfirmationFormErrors -> ConfirmationFormErrors) -> Model -> ( Model, Cmd Msg )
updateConfirmationModal transformForm transformFormErrors model =
    case model.confirmationModal of
        Just ( violation, confirmationForm, confirmationFormErrors ) ->
            ( { model | confirmationModal = Just ( violation, transformForm confirmationForm, transformFormErrors confirmationFormErrors ) }, Cmd.none )

        Nothing ->
            ( model, Cmd.none )



-- VIEW


view : Model -> { title : String, content : Html Msg }
view model =
    { title = "Possible Violations"
    , content =
        div []
            [ br [] []
            , br [] []
            , div [ class "container" ]
                [ viewSearchControls model
                ]
            , div [ class "container" ]
                (if List.length model.violationList == 0 then
                    [ br [] []
                    , h2 [ class "text-danger text-center" ] [ text "No Violations Found" ]
                    ]

                 else
                    List.map viewViolation model.violationList
                )
            , case model.detailsModal of
                Just violation ->
                    viewDetailsModal violation

                Nothing ->
                    text ""
            , case model.confirmationModal of
                Just ( violation, confirmationForm, confirmationFormErrors ) ->
                    viewConfirmationModal violation confirmationForm confirmationFormErrors

                Nothing ->
                    text ""
            ]
    }


viewSearchControls : Model -> Html Msg
viewSearchControls _ =
    div [ id "search-row", class "row align-items-center bg-primary rounded justify-content-between", style "height" "65px" ]
        [-- div [ class "input-group md-form form-sm form-2 pl-3", style "width" "300px" ]
         --     [ input [ class "form-control my-0 py-1 red-border", type_ "text", placeholder "Search", attribute "ariaLabel" "Search", value model.searchForm.search, onInput SetSearch ]
         --         []
         --     , div [ class "input-group-append" ]
         --         [ button
         --             [ type_ "button", class "btn btn-secondary", onClick SubmitSearch ]
         --             [ text "Search" ]
         --         ]
         --     ]
         -- , div [ class "dropdown pr-3" ]
         --     [ button [ class "btn btn-light dropdown-toggle", type_ "button", id "dropdownMenu2", attribute "data-toggle" "dropdown", attribute "aria-haspopup" "true", attribute "aria-expanded" "false" ]
         --         [ text
         --             (case model.searchForm.sortBy of
         --                 "sortable_date" ->
         --                     "Publish Date"
         --                 "recall_number" ->
         --                     "Recall Number"
         --                 "high_priority" ->
         --                     "High Priority"
         --                 _ ->
         --                     "Sort By"
         --             )
         --         ]
         --     , div [ class "dropdown-menu", attribute "aria-labelledby" "dropdownMenu2" ]
         --         [ button [ class "dropdown-item", type_ "button", onClick (SetSortBy "sortable_date") ]
         --             [ text "Publish Date" ]
         --         , button [ class "dropdown-item", type_ "button", onClick (SetSortBy "recall_number") ]
         --             [ text "Recall Number" ]
         --         , button [ class "dropdown-item", type_ "button", onClick (SetSortBy "high_priority") ]
         --             [ text "High Priority" ]
         --         , button [ class "dropdown-item", type_ "button", onClick (SetSortBy "") ]
         --             [ text "None" ]
         --        ]
         --    ]
        ]


viewViolation : Violation -> Html Msg
viewViolation violation =
    div [ class "mx-5 my-3" ]
        [ div [ class "row justify-content-between" ]
            [ div [ class "w-75" ]
                [ h3 [ class "d-inline" ] [ a [ href violation.url, target "_blank" ] [ text violation.title ] ] ]
            , div [ class "w-25 float-right text-center" ]
                (if violation.violationStatus == "Possible" then
                    [ button [ class "btn btn-secondary m-1", type_ "button", onClick (OpenDetails violation) ] [ text "Details" ]
                    , button [ class "btn btn-success m-1", type_ "button", onClick (SetViolationStatus violation "Passed") ] [ text "Pass Listing" ]
                    , button [ class "btn btn-danger m-1", type_ "button", onClick (OpenConfirmationForm violation) ] [ text "Confirm Violation" ]
                    ]

                 else
                    [ button [ class "btn btn-secondary mx-1", type_ "button", onClick (OpenDetails violation) ] [ text "Details" ] ]
                )
            ]
        , hr [] []
        ]


viewDetailsModal : Violation -> Html Msg
viewDetailsModal violation =
    div []
        [ div [ attribute "style" "background-color: rgba(0,0,0,0.5);", class "modal fade show", id "exampleModal", tabindex -1, attribute "role" "dialog", attribute "aria-labelledby" "exampleModalLabel", attribute "aria-hidden" "false", style "display" "block" ]
            [ div [ class "modal-dialog modal-lg", attribute "role" "document" ]
                [ div [ class "modal-content" ]
                    [ div [ class "modal-header" ]
                        [ h5 [ class "modal-title", id "exampleModalLabel" ]
                            [ text "Recall Details" ]
                        , button [ type_ "button", class "close", attribute "data-dismiss" "modal", attribute "aria-label" "Close", onClick CloseDetails ]
                            [ span [ attribute "aria-hidden" "true" ]
                                [ text "×" ]
                            ]
                        ]
                    , div [ class "modal-body" ] (viewViolationDetails violation)
                    ]
                ]
            ]
        ]


viewViolationDetails : Violation -> List (Html Msg)
viewViolationDetails violation =
    [ h2 [] [ text violation.title ]
    , p [] [ text violation.url ]
    , h4 [] [ text "Investigator ID" ]
    , p []
        [ text
            (case violation.investigatorId of
                Just id ->
                    String.fromInt id

                Nothing ->
                    "n/a"
            )
        ]
    , h4 [] [ text "Product ID" ]
    , p [] [ text (String.fromInt violation.recallId) ]
    ]


viewConfirmationModal : Violation -> ConfirmationForm -> ConfirmationFormErrors -> Html Msg
viewConfirmationModal violation confirmationForm confirmationFormErrors =
    div []
        [ div [ attribute "style" "background-color: rgba(0,0,0,0.5);", class "modal fade show", id "exampleModal", tabindex -1, attribute "role" "dialog", attribute "aria-labelledby" "exampleModalLabel", attribute "aria-hidden" "false", style "display" "block" ]
            [ div [ class "modal-dialog modal-lg", attribute "role" "document" ]
                [ div [ class "modal-content" ]
                    [ div [ class "modal-header" ]
                        [ h5 [ class "modal-title", id "exampleModalLabel" ]
                            [ text "Recall Details" ]
                        , button [ type_ "button", class "close", attribute "data-dismiss" "modal", attribute "aria-label" "Close", onClick CloseConfirmationForm ]
                            [ span [ attribute "aria-hidden" "true" ]
                                [ text "×" ]
                            ]
                        ]
                    , div [ class "modal-body" ] (viewConfirmationDetails violation confirmationForm confirmationFormErrors)
                    ]
                ]
            ]
        ]



-- (SetViolationStatus violation "Passed")


viewConfirmationDetails : Violation -> ConfirmationForm -> ConfirmationFormErrors -> List (Html Msg)
viewConfirmationDetails violation confirmationForm confirmationFormErrors =
    [ div [ class "row justify-content-center" ]
        [ h2 [ class "col-xl-6 col-lg-10 col-sm-12" ] [ text "Violation Information" ]
        ]
    , div [ class "row form-group justify-content-center" ]
        [ label [ for "inputEmail", class "col-sm-2 col-form-label" ]
            [ text "Contact Email" ]
        , div [ class "col-xl-3 col-lg-5 col-sm-10" ]
            [ input [ type_ "text", class "form-control", id "inputContactEmail", placeholder "email@example.com", value confirmationForm.contactEmail, onInput (UpdateConfirmationForm ContactEmail) ] []
            , case confirmationFormErrors.contactEmail of
                Just errorMessage ->
                    span [ class "text-danger" ] [ text errorMessage ]

                Nothing ->
                    text ""
            ]
        ]
    , div [ class "row form-group justify-content-center" ]
        [ label [ for "inputFullName", class "col-sm-2 col-form-label" ]
            [ text "Full Name" ]
        , div [ class "col-xl-3 col-lg-5 col-sm-10" ]
            [ input [ type_ "text", class "form-control", id "inputFullName", placeholder "John Doe", value confirmationForm.fullName, onInput (UpdateConfirmationForm FullName) ] []
            , case confirmationFormErrors.fullName of
                Just errorMessage ->
                    span [ class "text-danger" ] [ text errorMessage ]

                Nothing ->
                    text ""
            ]
        ]
    , div [ class "row form-group justify-content-center" ]
        [ label [ for "inputMarketplace", class "col-sm-2 col-form-label" ]
            [ text "Marketplace" ]
        , div [ class "col-xl-3 col-lg-5 col-sm-10" ]
            [ input [ type_ "text", class "form-control", id "inputMarketplace", placeholder "Amazon, amazon.com, etc", value confirmationForm.marketplace, onInput (UpdateConfirmationForm Marketplace) ] []
            , case confirmationFormErrors.marketplace of
                Just errorMessage ->
                    span [ class "text-danger" ] [ text errorMessage ]

                Nothing ->
                    text ""
            ]
        ]
    , div [ class "row form-group justify-content-center" ]
        [ button [ type_ "button", class "btn btn-primary mx-5", onClick (MarkViolationAsConfirmed violation confirmationForm confirmationFormErrors) ] [ text "Register" ]
        , button [ type_ "button", class "btn btn-danger mx-5", onClick CloseConfirmationForm ] [ text "Cancel" ]
        ]
    ]



-- EXPORTS


toSession : Model -> Session
toSession model =
    model.session
