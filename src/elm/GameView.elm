module GameView exposing (..)

import Updates exposing (..)
import Models exposing (..)
import Html exposing (Html, text)
import Html.Attributes exposing (style)
import Html.Events
import Svg exposing (svg, polygon, circle, rect)
import Svg.Attributes exposing (version, viewBox, points, fill, width, height, x, y, opacity)
import Util exposing (grid)


view : Model -> Html Msg
view model =
    Html.div
        [ style
            [ ( "width", "100%" )
            , ( "height", "100%" )
            , ( "background", "#1f1f1f" )
            , ( "color", "white" )
            , ( "display", "flex" )
            , ( "align-items", "center" )
            , ( "justify-content", "center" )
            , ( "font-family", "Futura" )
            , ( "text-align", "center" )
            ]
        ]
        [ case model.state of
            Start ->
                viewStart model

            Game ->
                viewGame model

            Over ->
                viewOver model
        ]


viewGame : Model -> Html Msg
viewGame model =
    let
        size =
            100 // model.level.size
    in
        Html.div
            [ style [ ( "max-width", "400px" ), ( "min-width", "280px" ), ( "flex", "1" ) ] ]
            [ svg [ version "1.1", viewBox "0 0 100 100" ]
                (viewGridBackground size
                    ++ (viewEnemies model size)
                    ++ [ viewPlayer model size ]
                )
            ]


viewGridBackground : Int -> List (Html Msg)
viewGridBackground size =
    (grid 5 5)
        |> List.map
            (\( a, b ) ->
                rect
                    [ x (toString (a * size + 1))
                    , y (toString (b * size + 1))
                    , width (toString (size - 2))
                    , height (toString (size - 2))
                    ]
                    []
            )


viewPlayer : Model -> Int -> Html Msg
viewPlayer model size =
    rect
        [ x (toString (model.x * size + 1))
        , y (toString (model.y * size + 1))
        , width (toString (size - 2))
        , height (toString (size - 2))
        , fill "#d9d9d9"
        ]
        []


viewEnemies : Model -> Int -> List (Html Msg)
viewEnemies model size =
    (model.enemies
        |> List.map
            (\e ->
                rect
                    [ x (toString (e.x * size + 1))
                    , y (toString (e.y * size + 1))
                    , width (toString (size - 2))
                    , height (toString (size - 2))
                    , fill "#ff6666"
                    ]
                    []
            )
    )
        ++ (model.enemies
                |> List.map
                    (\e ->
                        rect
                            [ x (toString (e.targetX * size + 1))
                            , y (toString (e.targetY * size + 1))
                            , width (toString (size - 2))
                            , height (toString (size - 2))
                            , fill "#ffffff"
                            , opacity "0.3"
                            ]
                            []
                    )
           )


viewStart : Model -> Html Msg
viewStart model =
    Html.div
        [ style [ ( "max-width", "400px" ), ( "min-width", "280px" ), ( "flex", "1" ) ] ]
        [ Html.h1 [ style [ ( "font-size", "3em" ), ( "color", "#E31743" ) ] ]
            [ Html.text "Hunted" ]
        , Html.p []
            [ Html.text "Pacman/Snake/... ish game" ]
        , Html.p []
            [ Html.text "Use the arrow keys to move." ]
        , Html.h2 [ Html.Events.onClick StartGame ]
            [ Html.text "Start" ]
        ]


viewOver : Model -> Html Msg
viewOver model =
    Html.div
        [ style [ ( "max-width", "400px" ), ( "min-width", "280px" ), ( "flex", "1" ) ] ]
        [ Html.h1 [ style [ ( "font-size", "3em" ), ( "color", "#17e3b7" ) ] ]
            [ Html.text "Game Over" ]
        , Html.p []
            [ Html.text "Your score this time was:" ]
        , Html.h2 [ Html.Events.onClick StartGame ]
            [ Html.text "Restart" ]
        ]
