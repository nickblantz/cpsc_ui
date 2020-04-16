module Pages.Violation exposing (Model, Msg(..), init, toSession, update, view)

import Data.Violation exposing (Violation, searchViolations, updateViolation)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Encode as JE
import Route exposing (Route, replaceUrl)
import Session exposing (Session, navKey, storeUser)



-- MAIN (DO NOT USE)


main : Html ()
main =
    text ""



-- MODEL


type alias Model =
    { session : Session
    , violationList : List Violation
    , detailsModal : Maybe Violation
    }


init : Session -> ( Model, Cmd Msg )
init session =
    case session of
        Session.Investigator _ _ ->
            ( Model session [] Nothing
            , searchViolations "Possible" UpdateViolationList
            )

        Session.Manager _ _ ->
            ( Model session [] Nothing
            , searchViolations "Possible" UpdateViolationList
            )

        _ ->
            ( Model session [] Nothing
            , replaceUrl (navKey session) Route.Home
            )



-- UPDATE


type Msg
    = OpenDetails Violation
    | CloseDetails
    | UpdateViolationList (Result Http.Error (List Violation))
    | SetViolationStatus Violation String
    | UpdateViolation (Result Http.Error Violation)


update : Msg -> Model -> ( Model, Cmd Msg )
update cmd model =
    case cmd of
        OpenDetails violation ->
            ( { model | detailsModal = Just violation }, Cmd.none )

        CloseDetails ->
            ( { model | detailsModal = Nothing }, Cmd.none )

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
            , div []
                [ case model.detailsModal of
                    Just violation ->
                        viewDetailsModal violation

                    Nothing ->
                        text ""
                ]
            ]
    }


viewSearchControls : Model -> Html Msg
viewSearchControls model =
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
            [ h3 [ class "d-inline" ]
                [ a [ href violation.url, target "_blank" ] [ text violation.title ] ]
            , div [ class "float-right" ]
                (if violation.violationStatus == "Possible" then
                    [ button [ class "btn btn-secondary mx-1", type_ "button", onClick (OpenDetails violation) ] [ text "Details" ]
                    , button [ class "btn btn-success mx-1", type_ "button", onClick (SetViolationStatus violation "Passed") ] [ text "Pass Listing" ]
                    , button [ class "btn btn-danger mx-1", type_ "button", onClick (SetViolationStatus violation "Confirmed") ] [ text "Confirm Violation" ]
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
    , p [] [ text (String.fromInt violation.investigatorId) ]
    , h4 [] [ text "Product ID" ]
    , p [] [ text (String.fromInt violation.recallId) ]
    ]



-- EXPORTS


toSession : Model -> Session
toSession model =
    model.session
