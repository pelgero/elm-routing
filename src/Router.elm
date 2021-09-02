module Router exposing (..)

import String.Extra exposing (humanize)
import Url
import Url.Parser exposing ((</>), Parser, int, map, oneOf, parse, s, string, top)


type alias Id =
    Int


type alias Name =
    String


type Route
    = Home
    | Profile Id
    | ReviewList
    | Review Name
    | NotFound


router : Parser (Route -> a) a
router =
    oneOf
        [ map Home top
        , map Home (s "home")
        , map ReviewList (s "reviews")
        , map Review (s "reviews" </> string)
        , map Profile (s "profile" </> int)
        ]


fromUrl : Url.Url -> Route
fromUrl url =
    Maybe.withDefault NotFound (parse router url)


routeName : Route -> String
routeName route =
    case route of
        Home ->
            "Home"

        Profile id ->
            "Profile - " ++ String.fromInt id

        ReviewList ->
            "All Reviews"

        Review name ->
            "Review - " ++ humanize name

        NotFound ->
            "Not Found"
