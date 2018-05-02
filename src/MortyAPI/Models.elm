module MortyAPI.Models
    exposing
        ( Approach
        , KanbanLanesData
        , KanbanLanesSuccessResponse
        , KanbanLane
        , KanbanLanes
        , KanbanStage
        , KanbanStageStatus(..)
        , KanbanStageStatusFields
        , KanbanTask
        , KanbanTaskPriority(..)
        , KanbanTaskType(..)
        , KanbanUser
        , Task
        , User
        )

{-| This library provides all the models you'll get back from the MortyAPI.


# Definition

@docs Approach
@docs KanbanLane
@docs KanbanLanes
@docs KanbanLanesData
@docs KanbanLanesSuccessResponse
@docs KanbanStage
@docs KanbanStageStatus
@docs KanbanStageStatusFields
@docs KanbanTask
@docs KanbanTaskPriority
@docs KanbanTaskType
@docs KanbanUser
@docs Task
@docs User

-}


{-| The Approach to a task. Used to create a new approach or return
a list of existing approaches when you retrieve a task.
-}
type alias Approach =
    { id : Int
    , taskId : Int
    , user : User
    , description : String
    , myHours : Maybe Float
    , seniorHours : Maybe Float
    , midLevelHours : Maybe Float
    , juniorHours : Maybe Float
    }


{-| A Kanban lane - effectively the lane representing a single user.
Returned as part of the `KanbanLanes` record.
-}
type alias KanbanLane =
    { acceptedStage : KanbanStage
    , deliveredStage : KanbanStage
    , inProgressStage : KanbanStage
    , metaStage : KanbanStage
    , toDoStage : KanbanStage
    , toEstimateStage : KanbanStage
    , user : KanbanUser
    }


{-| The whole Kanban board.
-}
type alias KanbanLanes =
    { label : String
    , kanbanLanes : List KanbanLane
    }


{-| The "data" content of the JSON API compliant response.
-}
type alias KanbanLanesData =
    { attributes : KanbanLanes
    , id : String
    , dataType : String
    }


{-| The full JSON compliant response.
-}
type alias KanbanLanesSuccessResponse =
    { data : KanbanLanesData
    }


{-| A task with only the properties required to render the Kanban board.
-}
type alias KanbanTask =
    { daysSinceLastChanged : Int
    , description : String
    , estimate : Maybe Int
    , mortyUrl : String
    , pivotalUrl : String
    , priority : KanbanTaskPriority
    , requestedBy : Maybe String
    , taskType : KanbanTaskType
    }


{-| The different task priorities with unique display properties
-}
type KanbanTaskPriority
    = HighestPriority
    | SecondHighestPriority
    | ThirdHighestPriority
    | LowerPriority


{-| The different types a kanban task can be.
-}
type KanbanTaskType
    = Feature
    | Bug
    | Chore


{-| A stage in the Kanban board - meta, to estimate, to do, in progress, delivered and accepted are
all instances of this.
-}
type alias KanbanStage =
    { status : KanbanStageStatus
    , tasks : List KanbanTask
    }


{-| The possible statuses a `KanbanStage` can have.
-}
type KanbanStageStatus
    = Ok
    | Problem String


{-| The raw fields from the API, just for decoding purposes.
-}
type alias KanbanStageStatusFields =
    { status : String
    , message : Maybe String
    }


{-| A Kanban board user, represented by a lane.
-}
type alias KanbanUser =
    { email : String
    , fullName : String
    }


{-| The record type returned by asking Morty for a Task via `MortyAPI.Commands.getTasksCommand` or
`MortyAPI.Commands.getTaskCommand`.
-}
type alias Task =
    { id : Int
    , title : String
    , description : String
    , taskType : String
    , externalIdentifier : String
    , status : String
    , secondsSinceStatusChanged : Int
    , ownedBy : Maybe User
    , requestedBy : Maybe String
    , taskApproaches : List Approach
    , predictionGroupId : Maybe Int
    , predictionJudgementAt : Maybe String
    , midLevelHourEstimate : Maybe Int
    }


{-| The record type returned by asking Morty for the current user via
`MortyAPI.Commands.getUserCommand`. It is also how the user is represented in the `Task` record.
-}
type alias User =
    { id : Int
    , fullName : String
    , email : String
    , seniority : String
    , predictionBookApiToken : Maybe String
    }
