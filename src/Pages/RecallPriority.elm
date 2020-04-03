module Pages.RecallPriority exposing (..)

import Browser
import Data.Recall exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)



-- MAIN (DO NOT USE)


main : Html ()
main =
    text ""



-- MODEL


type alias Model =
    { recallList : List Recall
    , detailsModal : Maybe Recall
    }


init : Model
init =
    Model [ stubRecall, stubRecall2 ] Nothing



-- UPDATE


type Msg
    = OpenDetails Recall
    | CloseDetails
    | ToggleHighPriority Recall


update : Msg -> Model -> Model
update cmd model =
    case cmd of
        OpenDetails recall ->
            { model | detailsModal = Just recall }

        CloseDetails ->
            { model | detailsModal = Nothing }

        ToggleHighPriority updatedRecall ->
            case model.detailsModal of
                Just recall ->
                    let
                        toggleHighPriority r =
                            if r.recallId == updatedRecall.recallId then
                                { r | isHighPriority = not updatedRecall.isHighPriority }

                            else
                                recall
                    in
                    { model | recallList = List.map toggleHighPriority model.recallList }

                Nothing ->
                    model



-- VIEW


view : Model -> { title : String, content : Html Msg }
view model =
    { title = "Recall Prioritization Page"
    , content =
        div []
            [ br [] []
            , br [] []
            , div [ class "container" ]
                [ viewSearchControls
                ]
            , div [ class "container" ]
                (List.map viewRecall model.recallList)
            , div []
                [ case model.detailsModal of
                    Just recall ->
                        viewDetailsModal recall

                    Nothing ->
                        p [] []
                ]
            ]
    }


viewSearchControls : Html msg
viewSearchControls =
    div [ id "search-row", class "row align-items-center bg-primary rounded justify-content-between", style "height" "65px" ]
        [ div [ class "input-group md-form form-sm form-2 pl-3", style "width" "300px" ]
            [ input [ class "form-control my-0 py-1 red-border", type_ "text", placeholder "Search", attribute "ariaLabel" "Search" ]
                []
            , div [ class "input-group-append" ]
                [ span [ class "input-group-text red lighten-3", id "basic-text1" ]
                    [ i [ class "text-grey", attribute "ariaHidden" "true" ]
                        [ text "Search" ]
                    ]
                ]
            ]
        , div [ class "dropdown pr-3" ]
            [ button [ class "btn btn-light dropdown-toggle", type_ "button", id "dropdownMenu2", attribute "data-toggle" "dropdown", attribute "aria-haspopup" "true", attribute "aria-expanded" "false" ]
                [ text "Sort By" ]
            , div [ class "dropdown-menu", attribute "aria-labelledby" "dropdownMenu2" ]
                [ button [ class "dropdown-item", type_ "button" ]
                    [ text "Publish Date" ]
                , button [ class "dropdown-item", type_ "button" ]
                    [ text "Recall Number" ]
                , button [ class "dropdown-item", type_ "button" ]
                    [ text "High Priority" ]
                ]
            ]
        ]


viewRecall : Recall -> Html Msg
viewRecall recall =
    div [ class "mx-5 my-3" ]
        [ div [ class "row justify-content-between" ]
            [ h3 [ class "d-inline w-75" ] [ text recall.title ]
            , div [ class "float-right w-25" ]
                [ button [ class "btn btn-secondary mx-1", type_ "button", onClick (OpenDetails recall) ] [ text "Details" ]
                , if recall.isHighPriority then
                    button [ class "btn btn-danger mx-1", type_ "button", onClick (ToggleHighPriority recall) ] [ text "Unmark High Priority" ]

                  else
                    button [ class "btn btn-primary mx-1", type_ "button", onClick (ToggleHighPriority recall) ] [ text "Mark High Priority" ]
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
    [ h3 [] [ text ("Title: " ++ recall.title) ]
    , p []
        [ a []
            [ text ("Description: " ++ recall.description) ]
        ]
    , p [] [ text ("Description: " ++ recall.description) ]
    , p [] [ text ("Publish Date: " ++ recall.recallDate) ]
    , p [] [ text ("Hazards: " ++ mapHazards recall.hazards) ]
    , p [] [ text ("Remedies: " ++ mapRemedies recall.remedies) ]
    ]


mapHazards : List Data.Recall.Hazard -> String
mapHazards hazard =
    let
        list =
            List.map .name hazard
    in
    String.join " | " list


mapRemedies : List Data.Recall.Remedy -> String
mapRemedies remedies =
    let
        list =
            List.map .name remedies
    in
    String.join " | " list
