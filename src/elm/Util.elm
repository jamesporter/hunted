module Util exposing (grid)


addCoordToAll : Int -> List Int -> List ( Int, Int )
addCoordToAll n coords =
    List.map (\c -> ( n, c )) coords


grid : Int -> Int -> List ( Int, Int )
grid n m =
    let
        coords =
            List.range 0 (m - 1)
    in
        List.map (\c -> addCoordToAll c coords) coords
            |> List.foldl (++) []
