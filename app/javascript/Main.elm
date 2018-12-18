module Main exposing (..)

import Browser
import Html exposing (Html, b, button, div, h3, h5, hr, input, p, text, textarea)
import Html.Attributes exposing (placeholder, style, value)
import Html.Events exposing (onInput)
import Http
import Json.Decode exposing (Decoder, field, list, map2, string)


-- DECODERS


messageDecoder : Decoder Message
messageDecoder =
    map2 Message
        (field "name" string)
        (field "content" string)



-- HTTP


getMessages : Cmd Msg
getMessages =
    Http.get
        { url = "/messages"
        , expect = Http.expectJson GotMessages (list messageDecoder)
        }



-- MODEL


type alias Message =
    { name : String, content : String }


type alias Model =
    { name : String, content : String, messages : List Message, hasErrors : Maybe Bool }



-- INIT


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model "John" "My fascinating message" [ Message "Frank" "Hi there!" ] Nothing, getMessages )



-- VIEW


viewMessage : Message -> Html Msg
viewMessage message =
    div [ style "padding" "5px" ]
        [ b [] [ text message.name ]
        , p [] [ text message.content ]
        , hr [] []
        ]


viewErrorMessage : Model -> Html Msg
viewErrorMessage model =
    case model.hasErrors of
        Just bool ->
            p [] [ text "CANT LOAD MESSAGES!!!" ]

        Nothing ->
            text ""


view : Model -> Html Msg
view model =
    -- The inline style is being used for example purposes in order to keep this example simple and
    -- avoid loading additional resources. Use a proper stylesheet when building your own app.
    div []
        [ div [ style "background" "#eee", style "display" "flex" ]
            [ div []
                [ h3 [] [ text "New Message" ]
                , p []
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
        , div []
            [ h3 []
                [ text "Messages" ]
            , viewErrorMessage model
            , div [] (List.map viewMessage model.messages)
            ]
        ]



-- MESSAGE


type Msg
    = ChangeName String
    | ChangeContent String
    | GotMessages (Result Http.Error (List Message))



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        ChangeName name ->
            ( { model | name = name }, Cmd.none )

        ChangeContent name ->
            ( { model | content = name }, Cmd.none )

        GotMessages result ->
            case result of
                Ok messages ->
                    ( { model | messages = messages }, Cmd.none )

                Err error ->
                    let
                        _ =
                            Debug.log "errors" error
                    in
                    ( { model | hasErrors = Just True }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- MAIN


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
