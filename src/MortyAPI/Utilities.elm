module MortyAPI.Utilities exposing (kanbanLaneStageList, allKanbanLanesProblems)

{-| Provides utility functions for MortyAPI.Models.

@docs kanbanLaneStageList
@docs allKanbanLanesProblems

-}

import MortyAPI.Models


{-| Returns a list of stages from a lane
-}
kanbanLaneStageList : MortyAPI.Models.KanbanLane -> List MortyAPI.Models.KanbanStage
kanbanLaneStageList lane =
    [ lane.toEstimateStage
    , lane.toDoStage
    , lane.inProgressStage
    , lane.deliveredStage
    , lane.acceptedStage
    , lane.metaStage
    ]


{-| Returns a list of problem message strings from the entire board.
-}
allKanbanLanesProblems : MortyAPI.Models.KanbanLanes -> List String
allKanbanLanesProblems kanbanLanes =
    List.concatMap (\lane -> allKanbanLaneProblems lane) kanbanLanes.kanbanLanes


allKanbanLaneProblems : MortyAPI.Models.KanbanLane -> List String
allKanbanLaneProblems lane =
    List.filterMap
        (\stage ->
            case stage.status of
                MortyAPI.Models.Ok ->
                    Nothing

                MortyAPI.Models.Problem message ->
                    Just message
        )
        (kanbanLaneStageList lane)
