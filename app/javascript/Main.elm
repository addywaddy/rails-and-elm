module Main exposing (..)

import Browser
import Html exposing (Html, button, div, h3, hr, input, p, text, textarea)
import Html.Attributes exposing (placeholder, style)


-- MODEL


type alias Model =
    {}



-- INIT


init : () -> ( Model, Cmd Message )
init _ =
    ( Model, Cmd.none )



-- VIEW


view : Model -> Html Message
view model =
    -- The inline style is being used for example purposes in order to keep this example simple and
    -- avoid loading additional resources. Use a proper stylesheet when building your own app.
    div []
        [ h3 []
            [ text "New Message" ]
        , div []
            [ p []
                [ input [ placeholder "Your name" ] []
                ]
            , textarea [ placeholder "Your message" ] []
            , p []
                [ button [] [ text "Post" ]
                ]
            ]
        , div []
            [ h3 [] [ text "Preview" ]
            , p [] [ text "A preview of your message will appear here" ]
            ]
        ]



-- MESSAGE


type Message
    = None



-- UPDATE


update : Message -> Model -> ( Model, Cmd Message )
update message model =
    ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Message
subscriptions model =
    Sub.none



-- MAIN


main : Program () Model Message
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
