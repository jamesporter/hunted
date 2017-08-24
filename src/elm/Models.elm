module Models exposing (..)


type State
    = Game
    | Start
    | Over


type alias Model =
    { state : State
    , x : Int
    , y : Int
    }
