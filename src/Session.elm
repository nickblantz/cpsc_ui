port module Session exposing (..)

import Browser.Navigation as Nav
import Data.User exposing (User, userEncoder)
import Html exposing (Html, text)
import Json.Encode as JE



-- MAIN (DO NOT USE)


main : Html ()
main =
    text ""


type Session
    = Anonymous Nav.Key
    | Manager Nav.Key User
    | Investigator Nav.Key User
    | Vendor Nav.Key User


init : Nav.Key -> Maybe User -> Session
init key maybeUser =
    case maybeUser of
        Just user ->
            case user.userType of
                "Manager" ->
                    Manager key user

                "Investigator" ->
                    Investigator key user

                "Vendor" ->
                    Vendor key user

                _ ->
                    Anonymous key

        Nothing ->
            Anonymous key


navKey : Session -> Nav.Key
navKey session =
    case session of
        Anonymous key ->
            key

        Manager key _ ->
            key

        Investigator key _ ->
            key

        Vendor key _ ->
            key


getUser : Session -> Maybe User
getUser session =
    case session of
        Anonymous _ ->
            Nothing

        Manager _ user ->
            Just user

        Investigator _ user ->
            Just user

        Vendor _ user ->
            Just user


loginUser : Session -> User -> Session
loginUser curSession newUser =
    case newUser.userType of
        "Manager" ->
            Manager (navKey curSession) newUser

        "Investigator" ->
            Investigator (navKey curSession) newUser

        "Vendor" ->
            Vendor (navKey curSession) newUser

        _ ->
            Anonymous (navKey curSession)


logoutUser : Session -> Session
logoutUser curSession =
    Anonymous (navKey curSession)



-- PORTS


port storeUser : String -> Cmd msg
