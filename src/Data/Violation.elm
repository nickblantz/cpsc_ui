module Data.Violation exposing (..)

import Html exposing (Html)
import Http exposing (expectJson, jsonBody, request)
import Json.Decode as JD
import Json.Encode as JE



-- MAIN (DO NOT USE)


main : Html ()
main =
    Html.text ""


type alias Violation =
    { violationId : Int
    , violationDate : String
    , url : String
    , title : String
    , investigatorId : Maybe Int
    , recallId : Int
    , violationStatus : String
    }


blankViolation : Violation
blankViolation =
    Violation 0 "" "" "" Nothing 0 ""


violationEncoder : Violation -> JE.Value
violationEncoder violation =
    JE.object
        [ ( "violation_id", JE.int violation.violationId )
        , ( "violation_date", JE.string violation.violationDate )
        , ( "url", JE.string violation.url )
        , ( "title", JE.string violation.title )
        , ( "investigator_id"
          , case violation.investigatorId of
                Just id ->
                    JE.int id

                Nothing ->
                    JE.null
          )
        , ( "recall_id", JE.int violation.recallId )
        , ( "violation_status", JE.string violation.violationStatus )
        ]


required : String -> JD.Decoder a -> JD.Decoder (a -> b) -> JD.Decoder b
required key valDecoder decoder =
    JD.map2 (|>) (JD.field key valDecoder) decoder


violationDecoder : JD.Decoder Violation
violationDecoder =
    JD.succeed Violation
        |> required "violation_id" JD.int
        |> required "violation_date" JD.string
        |> required "url" JD.string
        |> required "title" JD.string
        |> required "investigator_id" (JD.nullable JD.int)
        |> required "recall_id" JD.int
        |> required "violation_status" JD.string


violationListDecoder : JD.Decoder (List Violation)
violationListDecoder =
    JD.list violationDecoder


searchViolations : String -> (Result Http.Error (List Violation) -> msg) -> Cmd msg
searchViolations violation_status msg =
    Http.request
        { method = "POST"
        , headers = []
        , url = "http://api.cpscraper.com/violation/search"
        , body = Http.jsonBody (searchEncoder violation_status)
        , expect = Http.expectJson msg violationListDecoder
        , timeout = Nothing
        , tracker = Nothing
        }


searchEncoder : String -> JE.Value
searchEncoder violation_status =
    JE.object
        [ ( "violation_status", JE.string violation_status )
        ]


updateViolation : Violation -> (Result Http.Error Violation -> msg) -> Cmd msg
updateViolation violation msg =
    Http.request
        { method = "PUT"
        , headers = []
        , url = "http://api.cpscraper.com/violation/" ++ String.fromInt violation.violationId
        , body = Http.jsonBody (violationEncoder violation)
        , expect = Http.expectJson msg violationDecoder
        , timeout = Nothing
        , tracker = Nothing
        }
