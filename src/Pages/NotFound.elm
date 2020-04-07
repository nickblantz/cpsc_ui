module Pages.NotFound exposing (view)

import Html exposing (Html, div, h1, img, main_, text)
import Html.Attributes exposing (alt, class, id, src, style, tabindex)



-- MAIN (DO NOT USE)


main : Html ()
main =
    text ""



-- VIEW


view : { title : String, content : Html msg }
view =
    { title = "Page Not Found"
    , content =
        main_ [ id "content", class "container", tabindex -1 ]
            [ h1 [] [ text "Not Found" ]
            , h1 [ style "color" "grey" ] [ text " 404" ]
            ]
    }
