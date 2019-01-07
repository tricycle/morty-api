module MortyAPI.Decoders exposing
    ( decodeApproach
    , decodeKanbanLanesSuccessResponse
    , decodeTask
    , decodeTeamsSuccessResponse
    , decodeUser
    )

{-| Provides decoders for converting JSON responses into record types published by MortyAPI.Types.

@docs decodeApproach
@docs decodeKanbanLanesSuccessResponse
@docs decodeTask
@docs decodeTeamsSuccessResponse
@docs decodeUser

-}

import Json.Decode exposing (Decoder, andThen, float, int, list, nullable, string, succeed)
import Json.Decode.Pipeline exposing (optional, required)
import MortyAPI.Types


{-| Provides a decoder for JSON -> MortyAPI.Types.TaskApproach
-}
decodeApproach : Decoder MortyAPI.Types.TaskApproach
decodeApproach =
    succeed MortyAPI.Types.TaskApproach
        |> required "id" int
        |> required "task_id" int
        |> required "user" decodeUser
        |> required "description" string
        |> required "my_hours" (nullable float)
        |> required "senior_hours" (nullable float)
        |> required "mid_level_hours" (nullable float)
        |> required "junior_hours" (nullable float)


{-| Provides a decoder for JSON -> MortyAPI.Types.KanbanLanesSuccessResponse
-}
decodeKanbanLanesSuccessResponse : Decoder MortyAPI.Types.KanbanLanesSuccessResponse
decodeKanbanLanesSuccessResponse =
    succeed MortyAPI.Types.KanbanLanesSuccessResponse
        |> required "data" decodeKanbanLanesData


{-| Provides a decoder for JSON -> MortyAPI.Types.Task
-}
decodeTask : Decoder MortyAPI.Types.Task
decodeTask =
    succeed MortyAPI.Types.Task
        |> required "id" int
        |> required "title" string
        |> optional "description" string ""
        |> required "task_type" string
        |> required "external_identifier" string
        |> required "status" string
        |> required "seconds_since_status_changed" int
        |> required "owned_by_user" (nullable decodeUser)
        |> required "requested_by" (nullable string)
        |> required "task_approaches" (list decodeApproach)
        |> required "prediction_group_id" (nullable int)
        |> required "prediction_judgement_at" (nullable string)
        |> required "mid_level_hour_estimate" (nullable int)


{-| Provides a decoder for JSON -> MortyAPI.Types.TeamsSuccessResponse
-}
decodeTeamsSuccessResponse : Decoder MortyAPI.Types.TeamsSuccessResponse
decodeTeamsSuccessResponse =
    succeed MortyAPI.Types.TeamsSuccessResponse
        |> required "data" decodeTeamsData


{-| Provides a decoder for JSON -> MortyAPI.Types.Team
-}
decodeTeam : Decoder MortyAPI.Types.Team
decodeTeam =
    succeed MortyAPI.Types.Team
        |> required "id" int
        |> required "identifier" (nullable string)
        |> required "name" string
        |> required "members" (list decodeTeamMember)


{-| Provides a decoder for JSON -> MortyAPI.Types.User
-}
decodeUser : Decoder MortyAPI.Types.User
decodeUser =
    succeed MortyAPI.Types.User
        |> required "id" int
        |> required "full_name" string
        |> required "email" string
        |> required "seniority" string
        |> required "prediction_book_api_token" (nullable string)


decodeKanbanTaskType : Decoder MortyAPI.Types.KanbanTaskType
decodeKanbanTaskType =
    string
        |> andThen
            (\str ->
                case str of
                    "feature" ->
                        succeed MortyAPI.Types.Feature

                    "chore" ->
                        succeed MortyAPI.Types.Chore

                    _ ->
                        succeed MortyAPI.Types.Bug
            )


decodeKanbanTaskPriority : Decoder MortyAPI.Types.KanbanTaskPriority
decodeKanbanTaskPriority =
    nullable int
        |> andThen
            (\maybeString ->
                case maybeString of
                    Just 1 ->
                        succeed MortyAPI.Types.HighestPriority

                    Just 2 ->
                        succeed MortyAPI.Types.SecondHighestPriority

                    Just 3 ->
                        succeed MortyAPI.Types.ThirdHighestPriority

                    _ ->
                        succeed MortyAPI.Types.LowerPriority
            )


decodeKanbanTask : Decoder MortyAPI.Types.KanbanTask
decodeKanbanTask =
    succeed MortyAPI.Types.KanbanTask
        |> required "days_since_last_changed" int
        |> required "description" string
        |> required "estimate" (nullable int)
        |> required "morty_url" string
        |> required "pivotal_url" string
        |> required "priority" decodeKanbanTaskPriority
        |> required "requested_by" (nullable string)
        |> required "task_type" decodeKanbanTaskType


decodeKanbanUser : Decoder MortyAPI.Types.KanbanUser
decodeKanbanUser =
    succeed MortyAPI.Types.KanbanUser
        |> required "email" string
        |> required "full_name" string


decodeKanbanStageStatusFields : Decoder MortyAPI.Types.KanbanStageStatusFields
decodeKanbanStageStatusFields =
    succeed MortyAPI.Types.KanbanStageStatusFields
        |> required "status" string
        |> required "message" (nullable string)


decodeKanbanStageStatus : Decoder MortyAPI.Types.KanbanStageStatus
decodeKanbanStageStatus =
    decodeKanbanStageStatusFields
        |> andThen
            (\fields ->
                case fields.status of
                    "ok" ->
                        succeed MortyAPI.Types.Ok

                    _ ->
                        succeed (MortyAPI.Types.Problem (Maybe.withDefault "no message!" fields.message))
            )


decodeKanbanStage : Decoder MortyAPI.Types.KanbanStage
decodeKanbanStage =
    succeed MortyAPI.Types.KanbanStage
        |> required "result" decodeKanbanStageStatus
        |> required "tasks" (list decodeKanbanTask)


decodeKanbanLane : Decoder MortyAPI.Types.KanbanLane
decodeKanbanLane =
    succeed MortyAPI.Types.KanbanLane
        |> required "accepted_stage" decodeKanbanStage
        |> required "delivered_stage" decodeKanbanStage
        |> required "in_progress_stage" decodeKanbanStage
        |> required "meta_stage" decodeKanbanStage
        |> required "to_do_stage" decodeKanbanStage
        |> required "to_estimate_stage" decodeKanbanStage
        |> required "user" decodeKanbanUser


decodeKanbanLanesAttributes : Decoder MortyAPI.Types.KanbanLanes
decodeKanbanLanesAttributes =
    succeed MortyAPI.Types.KanbanLanes
        |> required "label" string
        |> required "kanban_lanes" (list decodeKanbanLane)


decodeKanbanLanesData : Decoder MortyAPI.Types.KanbanLanesData
decodeKanbanLanesData =
    succeed MortyAPI.Types.KanbanLanesData
        |> required "attributes" decodeKanbanLanesAttributes
        |> required "id" string
        |> required "type" string


decodeTeamsData : Decoder MortyAPI.Types.TeamsData
decodeTeamsData =
    succeed MortyAPI.Types.TeamsData
        |> required "attributes" (list decodeTeam)


decodeTeamMember : Decoder MortyAPI.Types.TeamMember
decodeTeamMember =
    succeed MortyAPI.Types.TeamMember
        |> required "id" int
        |> required "full_name" string
        |> required "email" string
        |> required "seniority" string
