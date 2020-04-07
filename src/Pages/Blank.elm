module Pages.Blank exposing (view)

import Html exposing (Html, text)



-- MAIN (DO NOT USE)


main : Html ()
main =
    text ""


view : { title : String, content : Html msg }
view =
    { title = ""
    , content = Html.text ""
    }
