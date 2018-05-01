module MortyAPI.Commands exposing (..)

{-| Provides commands and command parameters for making API calls.

@docs ApproachParameters
@docs CurrentUserParameters
@docs KanbanLanesForTeamParameters
@docs KanbanLanesForUserParameters
@docs TasksParameters
@docs TaskParameters

@docs getCurrentUserCommand
@docs getKanbanLanesForTeam
@docs getKanbanLanesForUser
@docs getTaskCommand
@docs getTasksCommand
@docs postTaskApproachCommand
@docs putTaskUpdateCommand

-}

import Http
import Json.Decode
import Maybe
import MortyAPI.Decoders
import MortyAPI.Encoders
import MortyAPI.Models
import RemoteData
import Time


{-| Parameters required to POST a new Task Approach
-}
type alias ApproachParameters a =
    { mortyApiToken : String
    , mortyHost : String
    , msgType : RemoteData.WebData MortyAPI.Models.Approach -> a
    }


{-| Parameters required to retrieve the current user
-}
type alias CurrentUserParameters a =
    { mortyApiToken : String
    , mortyHost : String
    , msgType : RemoteData.WebData MortyAPI.Models.User -> a
    }


{-| Parameters required to retrieve the kanban board for a full team
-}
type alias KanbanLanesForTeamParameters a =
    { mortyApiToken : String
    , mortyHost : String
    , teamId : Int
    , msgType : RemoteData.WebData MortyAPI.Models.KanbanLanesSuccessResponse -> a
    }


{-| Parameters required to retrieve the kanban board for a single user
-}
type alias KanbanLanesForUserParameters a =
    { mortyApiToken : String
    , mortyHost : String
    , userId : Int
    , msgType : RemoteData.WebData MortyAPI.Models.KanbanLanesSuccessResponse -> a
    }


{-| Parameters required to retrieve a task
-}
type alias TaskParameters a =
    { mortyApiToken : String
    , mortyHost : String
    , taskId : Int
    , msgType : RemoteData.WebData MortyAPI.Models.Task -> a
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
    , msgType : RemoteData.WebData (List MortyAPI.Models.Task) -> a
    }


{-| Gets the current user from the API
-}
getCurrentUserCommand : CurrentUserParameters a -> Cmd a
getCurrentUserCommand parameters =
    let
        url =
            parameters.mortyHost ++ "/api/v2/current_users/me.json?api_token=" ++ parameters.mortyApiToken
    in
        Http.get url MortyAPI.Decoders.decodeUser
            |> RemoteData.sendRequest
            |> Cmd.map parameters.msgType


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
                ++ toString ownerId
                ++ "&scope="
                ++ taskScope
                ++ "&scope_param="
                ++ taskScopeParam
                ++ "&api_token="
                ++ parameters.mortyApiToken
    in
        Http.get url (Json.Decode.list MortyAPI.Decoders.decodeTask)
            |> RemoteData.sendRequest
            |> Cmd.map parameters.msgType


{-| Gets a task from the API
-}
getTaskCommand : TaskParameters a -> Cmd a
getTaskCommand parameters =
    let
        url =
            parameters.mortyHost
                ++ "/api/v2/tasks/"
                ++ toString parameters.taskId
                ++ ".json?api_token="
                ++ parameters.mortyApiToken
    in
        Http.get url MortyAPI.Decoders.decodeTask
            |> RemoteData.sendRequest
            |> Cmd.map parameters.msgType


{-| Updates the properties of a task using a PUT call to the API
-}
putTaskUpdateCommand : TaskParameters a -> MortyAPI.Models.Task -> Cmd a
putTaskUpdateCommand parameters updatedTask =
    let
        url =
            parameters.mortyHost
                ++ "/api/v2/tasks/"
                ++ toString parameters.taskId
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
                , expect = Http.expectJson MortyAPI.Decoders.decodeTask
                , timeout = Just (30 * Time.second)
                , withCredentials = False
                }
    in
        request_
            |> RemoteData.sendRequest
            |> Cmd.map parameters.msgType


{-| POSTs a new task approach to the API
-}
postTaskApproachCommand : ApproachParameters a -> MortyAPI.Models.Approach -> Cmd a
postTaskApproachCommand parameters approach =
    let
        url =
            parameters.mortyHost
                ++ "/api/v2/task_approaches.json?api_token="
                ++ parameters.mortyApiToken
    in
        Http.post url (Http.jsonBody <| MortyAPI.Encoders.encodeApproach approach) MortyAPI.Decoders.decodeApproach
            |> RemoteData.sendRequest
            |> Cmd.map parameters.msgType


{-| Retrieves all kanban lanes for a team
-}
getKanbanLanesForTeam : KanbanLanesForTeamParameters a -> Cmd a
getKanbanLanesForTeam parameters =
    let
        url =
            parameters.mortyHost ++ "/api/teams/" ++ toString parameters.teamId ++ "/kanban_lanes.json?api_token=" ++ parameters.mortyApiToken
    in
        Http.get url MortyAPI.Decoders.decodeKanbanLanesSuccessResponse
            |> RemoteData.sendRequest
            |> Cmd.map parameters.msgType


{-| Retrieves all kanban lanes for a user
-}
getKanbanLanesForUser : KanbanLanesForUserParameters a -> Cmd a
getKanbanLanesForUser parameters =
    let
        url =
            parameters.mortyHost ++ "/api/users/" ++ toString parameters.userId ++ "/kanban_lanes.json?api_token=" ++ parameters.mortyApiToken
    in
        Http.get url MortyAPI.Decoders.decodeKanbanLanesSuccessResponse
            |> RemoteData.sendRequest
            |> Cmd.map parameters.msgType
