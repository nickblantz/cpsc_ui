module Pages.RecallPriority exposing (..)

import Browser
import Data.Recall exposing (Recall, searchRecalls, updateRecall)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Http
import Route exposing (Route, replaceUrl)
import Session exposing (Session, navKey)



-- MAIN (DO NOT USE)


main : Html ()
main =
    text ""



-- MODEL


type alias Model =
    { session : Session
    , recallList : List Recall
    , detailsModal : Maybe Recall
    , searchForm : SearchForm
    }


type alias SearchForm =
    { search : String
    , sortBy : String
    , limit : String
    , offset : String
    }


init : Session -> ( Model, Cmd Msg )
init session =
    let
        blankSearch =
            { search = ""
            , sortBy = ""
            , limit = "10"
            , offset = ""
            }
    in
    case session of
        Session.Manager _ _ ->
            ( Model session [] Nothing blankSearch
            , searchRecalls
                blankSearch
                UpdateRecallList
            )

        _ ->
            ( Model session [] Nothing blankSearch
            , replaceUrl (navKey session) Route.Home
            )



-- UPDATE


type Msg
    = OpenDetails Recall
    | CloseDetails
    | ToggleHighPriority Recall
    | UpdateRecallList (Result Http.Error (List Recall))
    | UpdateRecallPriority (Result Http.Error Recall)
    | SetSearch String
    | SetSortBy String
    | SubmitSearch


update : Msg -> Model -> ( Model, Cmd Msg )
update cmd model =
    case cmd of
        OpenDetails recall ->
            ( { model | detailsModal = Just recall }, Cmd.none )

        CloseDetails ->
            ( { model | detailsModal = Nothing }, Cmd.none )

        ToggleHighPriority updatedRecall ->
            ( model, updateRecall (toggleHighPriority updatedRecall) UpdateRecallPriority )

        UpdateRecallList result ->
            case result of
                Ok recallList ->
                    ( { model | recallList = recallList }, Cmd.none )

                Err _ ->
                    ( { model | recallList = [] }, Cmd.none )

        UpdateRecallPriority result ->
            case result of
                Ok recall ->
                    let
                        updateRecalls oldRecall =
                            if oldRecall.recallId == recall.recallId then
                                recall

                            else
                                oldRecall
                    in
                    ( { model | recallList = List.map updateRecalls model.recallList }, Cmd.none )

                Err _ ->
                    ( model, Cmd.none )

        SetSearch search ->
            let
                oldSearchForm =
                    model.searchForm

                updateSearchForm newSearch =
                    { oldSearchForm | search = newSearch }
            in
            ( { model | searchForm = updateSearchForm search }
            , Cmd.none
            )

        SetSortBy sortBy ->
            let
                oldSearchForm =
                    model.searchForm

                updateSearchForm newSortBy =
                    { oldSearchForm | sortBy = newSortBy }

                updatedModel =
                    { model | searchForm = updateSearchForm sortBy }
            in
            ( updatedModel
            , searchRecalls
                (updateSearchForm sortBy)
                UpdateRecallList
            )

        SubmitSearch ->
            ( model
            , searchRecalls
                model.searchForm
                UpdateRecallList
            )


toggleHighPriority : Recall -> Recall
toggleHighPriority recall =
    { recall | highPriority = not recall.highPriority }



-- VIEW


view : Model -> { title : String, content : Html Msg }
view model =
    { title = "Recall Prioritization Page"
    , content =
        div []
            [ br [] []
            , br [] []
            , div [ class "container" ]
                [ viewSearchControls model
                ]
            , div [ class "container" ]
                (if List.length model.recallList == 0 then
                    [ br [] []
                    , h2 [ class "text-danger text-center" ] [ text "No recalls found" ]
                    ]

                 else
                    List.map viewRecall model.recallList
                )
            , div []
                [ case model.detailsModal of
                    Just recall ->
                        viewDetailsModal recall

                    Nothing ->
                        text ""
                ]
            ]
    }


viewSearchControls : Model -> Html Msg
viewSearchControls model =
    div [ id "search-row", class "row align-items-center bg-primary rounded justify-content-between", style "height" "65px" ]
        [ div [ class "input-group md-form form-sm form-2 pl-3", style "width" "300px" ]
            [ input [ class "form-control my-0 py-1 red-border", type_ "text", placeholder "Search", attribute "ariaLabel" "Search", value model.searchForm.search, onInput SetSearch ]
                []
            , div [ class "input-group-append" ]
                [ button
                    [ type_ "button", class "btn btn-secondary", onClick SubmitSearch ]
                    [ text "Search" ]
                ]
            ]
        , div [ class "dropdown pr-3" ]
            [ button [ class "btn btn-light dropdown-toggle", type_ "button", id "dropdownMenu2", attribute "data-toggle" "dropdown", attribute "aria-haspopup" "true", attribute "aria-expanded" "false" ]
                [ text
                    (case model.searchForm.sortBy of
                        "sortable_date" ->
                            "Publish Date"

                        "recall_number" ->
                            "Recall Number"

                        "high_priority" ->
                            "High Priority"

                        _ ->
                            "Sort By"
                    )
                ]
            , div [ class "dropdown-menu", attribute "aria-labelledby" "dropdownMenu2" ]
                [ button [ class "dropdown-item", type_ "button", onClick (SetSortBy "sortable_date") ]
                    [ text "Publish Date" ]
                , button [ class "dropdown-item", type_ "button", onClick (SetSortBy "recall_number") ]
                    [ text "Recall Number" ]
                , button [ class "dropdown-item", type_ "button", onClick (SetSortBy "high_priority") ]
                    [ text "High Priority" ]
                , button [ class "dropdown-item", type_ "button", onClick (SetSortBy "") ]
                    [ text "None" ]
                ]
            ]
        ]


viewRecall : Recall -> Html Msg
viewRecall recall =
    div [ class "mx-5 my-3" ]
        [ div [ class "row justify-content-between" ]
            [ h3 [ class "d-inline w-75" ] [ text recall.recallHeading ]
            , div [ class "float-right w-25" ]
                [ button [ class "btn btn-secondary mx-1", type_ "button", onClick (OpenDetails recall) ] [ text "Details" ]
                , if recall.highPriority then
                    button [ class "btn btn-danger mx-1", type_ "button", onClick (ToggleHighPriority recall) ] [ text "Unprioritize" ]

                  else
                    button [ class "btn btn-primary mx-1", type_ "button", onClick (ToggleHighPriority recall) ] [ text "Prioritize" ]
                ]
            ]
        , p [] [ text recall.description ]
        , hr [] []
        ]


viewDetailsModal : Recall -> Html Msg
viewDetailsModal recall =
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
                    , div [ class "modal-body" ] (viewRecallDetails recall)
                    ]
                ]
            ]
        ]


viewRecallDetails : Recall -> List (Html Msg)
viewRecallDetails recall =
    [ h2 [] [ text recall.recallHeading ]
    , p [] [ text recall.description ]
    , h4 [] [ text "Date" ]
    , p [] [ text recall.date ]
    , h4 [] [ text "Name of Product" ]
    , p [] [ text recall.nameOfProduct ]
    , h4 [] [ text "Units" ]
    , p [] [ text recall.units ]
    , h4 [] [ text "Manufactured In" ]
    , p [] [ text recall.hazard ]
    , h4 [] [ text "Hazard" ]
    , p [] [ text recall.hazard ]
    , h4 [] [ text "Remedy" ]
    , p [] [ text recall.remedy ]
    , h4 [] [ text "Incidents" ]
    , p [] [ text recall.incidents ]
    ]



-- EXPORTS


toSession : Model -> Session
toSession model =
    model.session
