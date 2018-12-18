module Main exposing (..)

import Browser
import Html exposing (Html, button, div, h3, h5, hr, input, p, text, textarea)
import Html.Attributes exposing (placeholder, style, value)
import Html.Events exposing (onInput)


-- MODEL


type alias Model =
    { name : String, content : String }



-- INIT


init : () -> ( Model, Cmd Message )
init _ =
    ( Model "John" "My fascinating message", Cmd.none )



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
                [ input [ placeholder "Your name", value model.name, onInput ChangeName ] []
                ]
            , textarea [ placeholder "Your message", value model.content, onInput ChangeContent ] []
            , p []
                [ button [] [ text "Post" ]
                ]
            ]
        , div []
            [ h3 [] [ text "Preview" ]
            , h5 [] [ text model.name ]
            , p [] [ text model.content ]
            ]
        ]



-- MESSAGE


type Message
    = ChangeName String
    | ChangeContent String



-- UPDATE


update : Message -> Model -> ( Model, Cmd Message )
update message model =
    case message of
        ChangeName name ->
            ( { model | name = name }, Cmd.none )

        ChangeContent name ->
            ( { model | content = name }, Cmd.none )



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
