module MortyAPI.Commands exposing
    ( ApproachParameters
    , CurrentUserParameters
    , KanbanLanesForTeamParameters
    , KanbanLanesForUserParameters
    , TasksParameters
    , TaskParameters
    , TeamsParameters
    , getCurrentUserCommand
    , getKanbanLanesForTeam
    , getKanbanLanesForUser
    , getTaskCommand
    , getTasksCommand
    , getTeams
    , postTaskApproachCommand
    , putTaskUpdateCommand
    )

{-| Provides commands and command parameters for making API calls.

@docs ApproachParameters
@docs CurrentUserParameters
@docs KanbanLanesForTeamParameters
@docs KanbanLanesForUserParameters
@docs TasksParameters
@docs TaskParameters
@docs TeamsParameters

@docs getCurrentUserCommand
@docs getKanbanLanesForTeam
@docs getKanbanLanesForUser
@docs getTaskCommand
@docs getTasksCommand
@docs getTeams
@docs postTaskApproachCommand
@docs putTaskUpdateCommand

-}

import Http
import Json.Decode
import Maybe
import MortyAPI.Decoders
import MortyAPI.Encoders
import MortyAPI.Types
import RemoteData


{-| Parameters required to POST a new Task Approach
-}
type alias ApproachParameters a =
    { mortyApiToken : String
    , mortyHost : String
    , msgType : RemoteData.WebData MortyAPI.Types.TaskApproach -> a
    }


{-| Parameters required to retrieve the current user
-}
type alias CurrentUserParameters a =
    { mortyApiToken : String
    , mortyHost : String
    , msgType : RemoteData.WebData MortyAPI.Types.User -> a
    }


{-| Parameters required to retrieve the kanban board for a full team
-}
type alias KanbanLanesForTeamParameters a =
    { mortyApiToken : String
    , mortyHost : String
    , teamId : Int
    , msgType : RemoteData.WebData MortyAPI.Types.KanbanLanesSuccessResponse -> a
    }


{-| Parameters required to retrieve the kanban board for a single user
-}
type alias KanbanLanesForUserParameters a =
    { mortyApiToken : String
    , mortyHost : String
    , userId : Int
    , msgType : RemoteData.WebData MortyAPI.Types.KanbanLanesSuccessResponse -> a
    }


{-| Parameters required to retrieve a task
-}
type alias TaskParameters a =
    { mortyApiToken : String
    , mortyHost : String
    , taskId : Int
    , msgType : RemoteData.WebData MortyAPI.Types.Task -> a
    }


{-| Parameters required to retrieve task matching owner and scope
-}
type alias TasksParameters a =
    { mortyApiToken : String
    , mortyHost : String
    , ownerType : Maybe String
    , ownerId : Maybe Int
    , taskScope : Maybe String
    , taskScopeParam : Maybe String
    , msgType : RemoteData.WebData (List MortyAPI.Types.Task) -> a
    }


{-| Parameters required to retrieve a list of teams
-}
type alias TeamsParameters a =
    { mortyApiToken : String
    , mortyHost : String
    , msgType : RemoteData.WebData MortyAPI.Types.TeamsSuccessResponse -> a
    }


{-| Gets the current user from the API
-}
getCurrentUserCommand : CurrentUserParameters a -> Cmd a
getCurrentUserCommand parameters =
    let
        url =
            parameters.mortyHost ++ "/api/v2/current_users/me.json?api_token=" ++ parameters.mortyApiToken
    in
    Http.get
        { url = url
        , expect = Http.expectJson (RemoteData.fromResult >> parameters.msgType) MortyAPI.Decoders.decodeUser
        }


{-| Gets a list of tasks matching the filter criteria from the API
-}
getTasksCommand : TasksParameters a -> Cmd a
getTasksCommand parameters =
    let
        ownerType =
            Maybe.withDefault "" parameters.ownerType

        ownerId =
            Maybe.withDefault -1 parameters.ownerId

        taskScope =
            Maybe.withDefault "active" parameters.taskScope

        taskScopeParam =
            Maybe.withDefault "" parameters.taskScopeParam

        url =
            parameters.mortyHost
                ++ "/api/v2/tasks.json?"
                ++ "owner_type="
                ++ ownerType
                ++ "&owner_id="
                ++ String.fromInt ownerId
                ++ "&scope="
                ++ taskScope
                ++ "&scope_param="
                ++ taskScopeParam
                ++ "&api_token="
                ++ parameters.mortyApiToken
    in
    Http.get
        { url = url
        , expect = Http.expectJson (RemoteData.fromResult >> parameters.msgType) (Json.Decode.list MortyAPI.Decoders.decodeTask)
        }


{-| Gets a task from the API
-}
getTaskCommand : TaskParameters a -> Cmd a
getTaskCommand parameters =
    let
        url =
            parameters.mortyHost
                ++ "/api/v2/tasks/"
                ++ String.fromInt parameters.taskId
                ++ ".json?api_token="
                ++ parameters.mortyApiToken
    in
    Http.get { url = url, expect = Http.expectJson (RemoteData.fromResult >> parameters.msgType) MortyAPI.Decoders.decodeTask }


{-| Updates the properties of a task using a PUT call to the API
-}
putTaskUpdateCommand : TaskParameters a -> MortyAPI.Types.Task -> Cmd a
putTaskUpdateCommand parameters updatedTask =
    let
        url =
            parameters.mortyHost
                ++ "/api/v2/tasks/"
                ++ String.fromInt parameters.taskId
                ++ ".json?api_token="
                ++ parameters.mortyApiToken

        requestBody =
            Http.jsonBody <| MortyAPI.Encoders.encodeTask updatedTask

        request_ =
            Http.request
                { method = "PUT"
                , headers = []
                , url = url
                , body = requestBody
                , expect = Http.expectJson (RemoteData.fromResult >> parameters.msgType) MortyAPI.Decoders.decodeTask
                , timeout = Just 30000.0
                , tracker = Nothing
                }
    in
    request_


{-| POSTs a new task approach to the API
-}
postTaskApproachCommand : ApproachParameters a -> MortyAPI.Types.TaskApproach -> Cmd a
postTaskApproachCommand parameters approach =
    let
        url =
            parameters.mortyHost
                ++ "/api/v2/task_approaches.json?api_token="
                ++ parameters.mortyApiToken
    in
    Http.post
        { url = url
        , body = Http.jsonBody <| MortyAPI.Encoders.encodeApproach approach
        , expect = Http.expectJson (RemoteData.fromResult >> parameters.msgType) MortyAPI.Decoders.decodeApproach
        }


{-| Retrieves all kanban lanes for a team
-}
getKanbanLanesForTeam : KanbanLanesForTeamParameters a -> Cmd a
getKanbanLanesForTeam parameters =
    let
        url =
            parameters.mortyHost ++ "/api/teams/" ++ String.fromInt parameters.teamId ++ "/kanban_lanes.json?api_token=" ++ parameters.mortyApiToken
    in
    Http.get { url = url, expect = Http.expectJson (RemoteData.fromResult >> parameters.msgType) MortyAPI.Decoders.decodeKanbanLanesSuccessResponse }


{-| Retrieves all kanban lanes for a user
-}
getKanbanLanesForUser : KanbanLanesForUserParameters a -> Cmd a
getKanbanLanesForUser parameters =
    let
        url =
            parameters.mortyHost ++ "/api/users/" ++ String.fromInt parameters.userId ++ "/kanban_lanes.json?api_token=" ++ parameters.mortyApiToken
    in
    Http.get { url = url, expect = Http.expectJson (RemoteData.fromResult >> parameters.msgType) MortyAPI.Decoders.decodeKanbanLanesSuccessResponse }


{-| Retrieves all teams and their members
-}
getTeams : TeamsParameters a -> Cmd a
getTeams parameters =
    let
        url =
            parameters.mortyHost ++ "/api/v3/teams.json?api_token=" ++ parameters.mortyApiToken
    in
    Http.get { url = url, expect = Http.expectJson (RemoteData.fromResult >> parameters.msgType) MortyAPI.Decoders.decodeTeamsSuccessResponse }
