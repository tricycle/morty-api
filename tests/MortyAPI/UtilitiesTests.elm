module Tests.MortyAPI.UtilitiesTests exposing (..)

import Expect
import MortyAPI.Utilities
import Test exposing (..)
import Tests.MortyAPI.Factories


suite : Test
suite =
    describe "MortyAPI.Utilities"
        [ describe "allKanbanLanesProblems"
            [ test "problems are collated correctly" <|
                \() ->
                    let
                        successResponse =
                            Tests.MortyAPI.Factories.kanbanLanesSuccessResponse

                        kanbanLanes =
                            successResponse.data.attributes

                        functionOutput =
                            MortyAPI.Utilities.allKanbanLanesProblems kanbanLanes

                        expectedResult =
                            [ "Carlos Negros does not have anything queued up" ]
                    in
                        Expect.equal functionOutput expectedResult
            ]
        ]
