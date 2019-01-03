module MortyAPI.Utilities exposing
    ( kanbanLaneStageList
    , allKanbanLanesProblems
    )

{-| Provides utility functions for MortyAPI.Types.

@docs kanbanLaneStageList
@docs allKanbanLanesProblems

-}

import MortyAPI.Types


{-| Returns a list of stages from a lane
-}
kanbanLaneStageList : MortyAPI.Types.KanbanLane -> List MortyAPI.Types.KanbanStage
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
allKanbanLanesProblems : MortyAPI.Types.KanbanLanes -> List String
allKanbanLanesProblems kanbanLanes =
    List.concatMap (\lane -> allKanbanLaneProblems lane) kanbanLanes.kanbanLanes


allKanbanLaneProblems : MortyAPI.Types.KanbanLane -> List String
allKanbanLaneProblems lane =
    List.filterMap
        (\stage ->
            case stage.status of
                MortyAPI.Types.Ok ->
                    Nothing

                MortyAPI.Types.Problem message ->
                    Just message
        )
        (kanbanLaneStageList lane)
