module Updates exposing (..)

import Models exposing (..)
import Time exposing (Time, inSeconds)
import Keyboard exposing (KeyCode)


type Msg
    = TimeUpdate Time
    | KeyDown KeyCode
    | StartGame


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TimeUpdate dt ->
            ( timeUpdate dt model, Cmd.none )

        KeyDown keyCode ->
            ( keyDown keyCode model, Cmd.none )

        StartGame ->
            ( { model | state = Game }, Cmd.none )


initialModel : Model
initialModel =
    { state = Start
    , x = 2
    , y = 2
    , enemies =
        [ Enemy 0 0 (Just { x = 1, y = 0 }) 0.0
        , Enemy 4 3 (Just { x = 2, y = 4 }) 0.5
        , Enemy 3 6 (Just { x = 4, y = 7 }) 0.7
        ]
    , level = LevelSpec 8 1.0
    }


timeUpdate : Time -> Model -> Model
timeUpdate dt model =
    let
        ms =
            inSeconds dt

        updatedEnemies =
            model.enemies
                |> List.map (\e -> updateAndMoveEnemy e ms model)
    in
        { model | enemies = updatedEnemies }


updateAndMoveEnemy : Enemy -> Float -> Model -> Enemy
updateAndMoveEnemy enemy ms model =
    let
        newEnergy =
            enemy.energy + ms
    in
        case enemy.target of
            Just t ->
                if newEnergy > model.level.threshold then
                    updateEnemyPosition enemy t model
                else
                    { enemy | energy = newEnergy }

            Nothing ->
                --attempt to find target
                enemy


updateEnemyPosition : Enemy -> { x : Int, y : Int } -> Model -> Enemy
updateEnemyPosition enemy target { x, y, enemies } =
    let
        desiredX =
            moveTowards target.x x

        desiredY =
            moveTowards target.y y

        occupied =
            isOccupied ( desiredX, desiredY ) enemies
    in
        if occupied then
            { enemy | x = target.x, y = target.y, target = Nothing, energy = 0 }
        else
            { enemy | x = target.x, y = target.y, target = Just { x = desiredX, y = desiredY }, energy = 0 }


isOccupied : ( Int, Int ) -> List Enemy -> Bool
isOccupied ( x, y ) enemies =
    enemies
        |> List.any
            (\e ->
                case e.target of
                    Just t ->
                        (t.x == x) && (t.y == y)

                    Nothing ->
                        False
            )


moveTowards : Int -> Int -> Int
moveTowards current target =
    if current > target then
        current - 1
    else if current < target then
        current + 1
    else
        current


keyDown : KeyCode -> Model -> Model
keyDown keyCode model =
    case keyCode of
        38 ->
            if model.y > 0 then
                { model | y = model.y - 1 }
            else
                model

        40 ->
            if model.y < model.level.size - 1 then
                { model | y = model.y + 1 }
            else
                model

        37 ->
            if model.x > 0 then
                { model | x = model.x - 1 }
            else
                model

        39 ->
            if model.x < model.level.size - 1 then
                { model | x = model.x + 1 }
            else
                model

        27 ->
            { model
                | state = Start
            }

        _ ->
            model
