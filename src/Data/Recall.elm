module Data.Recall exposing (..)

import Html exposing (Html)
import Http exposing (expectJson, jsonBody, request)
import Json.Decode as JD
import Json.Encode as JE



-- MAIN (DO NOT USE)


main : Html ()
main =
    Html.text ""


type alias Recall =
    { recallId : Int
    , recallNumber : String
    , highPriority : Bool
    , date : String
    , recallHeading : String
    , nameOfProduct : String
    , description : String
    , hazard : String
    , remedyType : String
    , units : String
    , conjunectionWith : String
    , incidents : String
    , remedy : String
    , soldAt : String
    , distributors : String
    , manufacturedIn : String
    }


blankRecall : Recall
blankRecall =
    Recall 0 "" False "" "" "" "" "" "" "" "" "" "" "" "" ""


recallEncoder : Recall -> JE.Value
recallEncoder recall =
    JE.object
        [ ( "recall_id", JE.int recall.recallId )
        , ( "recall_number", JE.string recall.recallNumber )
        , ( "high_priority", JE.bool recall.highPriority )
        , ( "date", JE.string recall.date )
        , ( "recall_heading", JE.string recall.recallHeading )
        , ( "name_of_product", JE.string recall.nameOfProduct )
        , ( "description", JE.string recall.description )
        , ( "hazard", JE.string recall.hazard )
        , ( "remedy_type", JE.string recall.remedyType )
        , ( "units", JE.string recall.units )
        , ( "conjunction_with", JE.string recall.conjunectionWith )
        , ( "incidents", JE.string recall.incidents )
        , ( "remedy", JE.string recall.remedy )
        , ( "sold_at", JE.string recall.soldAt )
        , ( "distributors", JE.string recall.distributors )
        , ( "manufactured_in", JE.string recall.manufacturedIn )
        ]


required : String -> JD.Decoder a -> JD.Decoder (a -> b) -> JD.Decoder b
required key valDecoder decoder =
    JD.map2 (|>) (JD.field key valDecoder) decoder


recallDecoder : JD.Decoder Recall
recallDecoder =
    JD.succeed Recall
        |> required "recall_id" JD.int
        |> required "recall_number" JD.string
        |> required "high_priority" JD.bool
        |> required "date" JD.string
        |> required "recall_heading" JD.string
        |> required "name_of_product" JD.string
        |> required "description" JD.string
        |> required "hazard" JD.string
        |> required "remedy_type" JD.string
        |> required "units" JD.string
        |> required "conjunction_with" JD.string
        |> required "incidents" JD.string
        |> required "remedy" JD.string
        |> required "sold_at" JD.string
        |> required "distributors" JD.string
        |> required "manufactured_in" JD.string


recallListDecoder : JD.Decoder (List Recall)
recallListDecoder =
    JD.list recallDecoder


searchRecalls : { search : String, sortBy : String, limit : String, offset : String } -> (Result Http.Error (List Recall) -> msg) -> Cmd msg
searchRecalls { search, sortBy, limit, offset } msg =
    Http.request
        { method = "POST"
        , headers = []
        , url = "http://localhost:3033/recall/search"
        , body = Http.jsonBody (searchEncoder search sortBy limit offset)
        , expect = Http.expectJson msg recallListDecoder
        , timeout = Nothing
        , tracker = Nothing
        }


searchEncoder : String -> String -> String -> String -> JE.Value
searchEncoder search sortBy limit offset =
    JE.object
        [ ( "search", JE.string search )
        , ( "sort_by", JE.string sortBy )
        , ( "limit", JE.string limit )
        , ( "offset", JE.string offset )
        ]


updateRecall : Recall -> (Result Http.Error Recall -> msg) -> Cmd msg
updateRecall recall msg =
    Http.request
        { method = "PUT"
        , headers = []
        , url = "http://localhost:3033/recall/" ++ String.fromInt recall.recallId
        , body = Http.jsonBody (recallEncoder recall)
        , expect = Http.expectJson msg recallDecoder
        , timeout = Nothing
        , tracker = Nothing
        }
