module App exposing (..)

import Browser
import Browser.Navigation as Nav
import Html exposing (Attribute, Html, text)
import Html.Attributes as Attr
import Json.Decode as JD
import Json.Encode as JE
import Url exposing (Url)



-- MAIN (DO NOT USE)


main : Html ()
main =
    text ""



-- SERIALIZATION
-- application :
--     JD.Decoder (Cred -> viewer)
--     ->
--         { init : Maybe viewer -> Url -> Nav.Key -> ( model, Cmd msg )
--         , onUrlChange : Url -> msg
--         , onUrlRequest : Browser.UrlRequest -> msg
--         , subscriptions : model -> Sub msg
--         , update : msg -> model -> ( model, Cmd msg )
--         , view : model -> Browser.Document msg
--         }
--     -> Program Value model msg
-- application viewerDecoder config =
--     let
--         init flags url navKey =
--             let
--                 maybeViewer =
--                     Decode.decodeValue Decode.string flags
--                         |> Result.andThen (Decode.decodeString (storageDecoder viewerDecoder))
--                         |> Result.toMaybe
--             in
--             config.init maybeViewer url navKey
--     in
--     Browser.application
--         { init = init
--         , onUrlChange = config.onUrlChange
--         , onUrlRequest = config.onUrlRequest
--         , subscriptions = config.subscriptions
--         , update = config.update
--         , view = config.view
--         }
