module Main exposing (..)

import Browser
import Browser.Navigation as Nav
import Html exposing (Html, a, b, div, h4, span, text, ul)
import Html.Attributes exposing (href)
import Router
import Url


type alias Model =
    { key : Nav.Key
    , route : Router.Route
    }


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url


main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none -- not used here
        , onUrlRequest = LinkClicked
        , onUrlChange = UrlChanged
        }


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url key =
    ( Model key (Router.fromUrl url)
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.External url ->
                    ( model, Nav.load url )

                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

        UrlChanged url ->
            ( { model | route = Router.fromUrl url }
            , Cmd.none
            )


view : Model -> Browser.Document Msg
view { route } =
    { title = "My App: " ++ Router.routeName route
    , body =
        [ div []
            [ span [] [ text "Current route: " ]
            , b [] [ text <| Router.routeName route ]
            ]
        , div []
            [ h4 [] [ text "Internal links" ]
            , ul []
                [ viewLink "/"
                , viewLink "/home"
                , viewLink "/profile/42"
                , viewLink "/reviews"
                , viewLink "/reviews/the-century-of-the-self"
                ]
            ]
        , div []
            [ h4 [] [ text "External links" ]
            , ul []
                [ viewLink "http://google.de" ]
            ]
        ]
    }


viewLink : String -> Html msg
viewLink path =
    div [] [ a [ href path ] [ text path ] ]
