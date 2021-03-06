module Models exposing (..)


type State
    = Game
    | Start
    | Over


type alias LevelSpec =
    { size : Int
    , threshold : Float
    }


type alias Enemy =
    { x : Int
    , y : Int
    , target : Maybe { x : Int, y : Int }
    , energy : Float
    }



--type NoTarget | Target Int Int Float


type alias Model =
    { state : State
    , x : Int
    , y : Int
    , enemies : List Enemy
    , level : LevelSpec
    }



-- type alias LocationyThing a =
--     { a | x : Int, y : Int }
