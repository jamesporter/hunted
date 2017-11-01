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
    , enemies = [ Enemy 0 0 0 1 0.0, Enemy 4 3 2 4 0.5, Enemy 3 4 4 4 0.7 ]
    , level = LevelSpec 5 1.0
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
        if newEnergy > model.level.threshold then
            updateEnemyPosition enemy model
        else
            { enemy | energy = newEnergy }


updateEnemyPosition : Enemy -> Model -> Enemy
updateEnemyPosition enemy { x, y, enemies } =
    let
        desiredX =
            moveTowards enemy.targetX x

        desiredY =
            moveTowards enemy.targetY y

        occupied =
            isOccupied ( desiredX, desiredY ) enemies
    in
        if occupied then
            enemy
        else
            { enemy | x = enemy.targetX, y = enemy.targetY, targetX = desiredX, targetY = desiredY, energy = 0 }


isOccupied : ( Int, Int ) -> List Enemy -> Bool
isOccupied ( x, y ) enemies =
    enemies
        |> List.any (\e -> (e.targetX == x) && (e.targetY == y))


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
            if model.y < 4 then
                { model | y = model.y + 1 }
            else
                model

        37 ->
            if model.x > 0 then
                { model | x = model.x - 1 }
            else
                model

        39 ->
            if model.x < 4 then
                { model | x = model.x + 1 }
            else
                model

        27 ->
            { model
                | state = Start
            }

        _ ->
            model
