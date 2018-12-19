module Main exposing (..)

{-
   Here we're importing all the dependencies needed by our application.
   Elm.core also has a number of default imports which are available implicitly to our application.
   See here: https://package.elm-lang.org/packages/elm/core/latest/ for details.

   All exposed functions and types are available to us without needing to be qualified via the
   namespace, so that we can write e.g. `field` instead of `Json.Decode.field`
-}

import Browser
import Html exposing (Html, b, button, div, h3, h5, hr, input, p, text, textarea)
import Html.Attributes exposing (disabled, placeholder, style, value)
import Html.Events exposing (onClick, onInput)
import Http
import Json.Decode exposing (Decoder, field, list, map2, string)


{-
   DECODERS
   Package: elm/json

   Whenever you want to use json data inside Elm, you need to first convert it to Elm data using a
   decoder.
   See here: https://guide.elm-lang.org/effects/json.html
-}


messageDecoder : Decoder Message



{-
   Decode our JSON representation of our Message instance from Rails:

   {name: "Peter", content: "My message to you", created_at: ...}

   into Elm data using our Message constructor. Note that we only need to specify the fields we are
   interested in.
-}


messageDecoder =
    map2 Message
        (field "name" string)
        (field "content" string)



{-
   HTTP
   Package: elm/http
   Enables us to make HTTP requests, decode the response, and pass the Result to a Msg contructor. This
   is then handled in our update function, enabling us to handle both successful and unsuccessful
   requests.
-}


getMessages : Cmd Msg



{-
   Here we're requesting the supplied URL and then using our messageDecoder to decode the list of
   messages in the response.
-}


getMessages =
    Http.get
        { url = "/messages.json"
        , expect = Http.expectJson GotMessages (list messageDecoder)
        }


postMessage : Model -> Cmd Msg



{-
   We
-}


postMessage model =
    Http.post
        { url = "/messages.json"
        , body = Http.emptyBody
        , expect = Http.expectJson MessageCreated messageDecoder
        }



-- MODELS
{-
   Elm is strongly typed and so we need to specify the types for the state held by our application.
   Type aliases are typed records which are similar to a schema: they define attribute
   names and the corresponding type.
-}


type alias Message =
    { name : String, content : String }


type alias Model =
    { name : String
    , content : String
    , messages : List Message
    , hasErrors : Bool
    , isSubmitting :
        Bool
    }



{-
   INITIAL FUCTION

   The following function defines the initial state of our application. The `()` below represents an
   empty value type. The returned tuple (..., ...) contains our initial state plus a command to get the
   messages.
-}


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model "John" "My fascinating message" [ Message "Frank" "Hi there!" ] False False, getMessages )



{-
   VIEWS

   This is where we render our application, as well as returning messages for updating our
   application's state, such as handling click events.
-}


viewMessage : Message -> Html Msg



{- Takes a message and return the corresponding HTML markup -}


viewMessage message =
    div [ style "padding" "5px" ]
        [ b [] [ text message.name ]
        , p [] [ text message.content ]
        , hr [] []
        ]


viewErrorMessage : Model -> Html Msg



{- Takes a model and displays an error message conditionally -}


viewErrorMessage model =
    if model.hasErrors then
        p [] [ text "CANT LOAD MESSAGES!!!" ]
    else
        text ""


view : Model -> Html Msg



{- Our main view function, which renders everything -}


view model =
    div []
        [ div [ style "background" "#eee", style "display" "flex" ]
            [ div []
                [ h3 [] [ text "New Message" ]
                , p []
                    [ input [ placeholder "Your name", value model.name, onInput ChangeName ] []
                    ]
                , textarea [ placeholder "Your message", value model.content, onInput ChangeContent ] []
                , p []
                    [ button [ onClick Submit, disabled model.isSubmitting ] [ text "Post" ]
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



{-
   MESSAGES
   Here we define a union type (called `Msg` here to avoid a conflict with our `Message` type alias
   above). A union type defines a set of types which belong to it, meaning that we can react to each
   of these in our update function.
-}


type Msg
    = ChangeName String
    | ChangeContent String
    | GotMessages (Result Http.Error (List Message))
    | MessageCreated (Result Http.Error Message)
    | Submit



{-
   UPDATE FUNCTION
   This is where we handle state change within our application, and where we can also trigger
   additional state changes if our returning tuple issues a command.
-}


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeName name ->
            ( { model | name = name }, Cmd.none )

        ChangeContent name ->
            ( { model | content = name }, Cmd.none )

        Submit ->
            ( { model | isSubmitting = True }, postMessage model )

        GotMessages result ->
            case result of
                Ok messages ->
                    ( { model | messages = messages }, Cmd.none )

                Err error ->
                    ( { model | hasErrors = True }, Cmd.none )

        MessageCreated result ->
            let
                submittedModel =
                    { model | isSubmitting = False }
            in
            case result of
                Ok message ->
                    ( { submittedModel | messages = message :: submittedModel.messages }, Cmd.none )

                Err error ->
                    ( { submittedModel | hasErrors = True }, Cmd.none )



{-
   SUBSCRIPTIONS FUNCTION

   Here we can set up one or more subscriptions for e.g. Websocket connections, ports (enabling
   communication with javascript outside of our Elm application). If you have a usecase for using
   setInterval in Javascript, this would also be a subscription (See `Time.every` in the elm/time
   package for details).
-}


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



{-
   MAIN FUNCTION

   Our entry point. Our application is taking over control of a single node in the DOM and so we setup
   our application here using `Browser.element`.
-}


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
