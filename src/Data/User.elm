module Data.User exposing (..)

import Html exposing (Html)
import Http exposing (expectJson, jsonBody, request)
import Json.Decode as JD
import Json.Encode as JE



-- MAIN (DO NOT USE)


main : Html ()
main =
    Html.text ""


type alias User =
    { userId : Int
    , email : String
    , password : String
    , firstName : String
    , userType : String
    }


blankUser : User
blankUser =
    User 0 "" "" "" ""


userEncoder : User -> JE.Value
userEncoder user =
    JE.object
        [ ( "user_id", JE.int user.userId )
        , ( "email", JE.string user.email )
        , ( "password", JE.string user.password )
        , ( "first_name", JE.string user.firstName )
        , ( "user_type", JE.string user.userType )
        ]


userDecoder : JD.Decoder User
userDecoder =
    JD.map5 User
        (JD.field "user_id" JD.int)
        (JD.field "email" JD.string)
        (JD.field "password" JD.string)
        (JD.field "first_name" JD.string)
        (JD.field "user_type" JD.string)


userListDecoder : JD.Decoder (List User)
userListDecoder =
    JD.list userDecoder


createUser : User -> (Result Http.Error User -> msg) -> Cmd msg
createUser user msg =
    Http.request
        { method = "POST"
        , headers = []
        , url = "http://localhost:3033/user"
        , body = Http.jsonBody (userEncoder user)
        , expect = Http.expectJson msg userDecoder
        , timeout = Nothing
        , tracker = Nothing
        }


loginUser : { email : String, password : String } -> (Result Http.Error User -> msg) -> Cmd msg
loginUser { email, password } msg =
    Http.request
        { method = "POST"
        , headers = []
        , url = "http://localhost:3033/user/login"
        , body = Http.jsonBody (loginEncoder email password)
        , expect = Http.expectJson msg userDecoder
        , timeout = Nothing
        , tracker = Nothing
        }


loginEncoder : String -> String -> JE.Value
loginEncoder email password =
    JE.object
        [ ( "email", JE.string email )
        , ( "password", JE.string password )
        ]
