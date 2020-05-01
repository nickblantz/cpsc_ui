module Data.Email exposing (..)

import Html exposing (Html)
import Http exposing (expectJson, jsonBody, request)
import Json.Decode as JD
import Json.Encode as JE



-- MAIN (DO NOT USE)


main : Html ()
main =
    Html.text ""


type alias Email =
    { emailId : Int
    , emailAddress : String
    , fullName : String
    , marketplace : String
    , violationId : Int
    }


blankEmail : Email
blankEmail =
    Email 0 "" "" "" 0


emailEncoder : Email -> JE.Value
emailEncoder email =
    JE.object
        [ ( "email_id", JE.int email.emailId )
        , ( "email_address", JE.string email.emailAddress )
        , ( "full_name", JE.string email.fullName )
        , ( "marketplace", JE.string email.marketplace )
        , ( "violation_id", JE.int email.violationId )
        ]


required : String -> JD.Decoder a -> JD.Decoder (a -> b) -> JD.Decoder b
required key valDecoder decoder =
    JD.map2 (|>) (JD.field key valDecoder) decoder


emailDecoder : JD.Decoder Email
emailDecoder =
    JD.succeed Email
        |> required "email_id" JD.int
        |> required "email_address" JD.string
        |> required "full_name" JD.string
        |> required "marketplace" JD.string
        |> required "violation_id" JD.int


createEmail : Email -> (Result Http.Error Email -> msg) -> Cmd msg
createEmail email msg =
    Http.request
        { method = "POST"
        , headers = []
        , url = "http://api.cpscraper.com/email"
        , body = Http.jsonBody (emailEncoder email)
        , expect = Http.expectJson msg emailDecoder
        , timeout = Nothing
        , tracker = Nothing
        }
