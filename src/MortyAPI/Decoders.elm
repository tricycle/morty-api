module MortyAPI.Decoders
    exposing
        ( decodeApproach
        , decodeKanbanLanesSuccessResponse
        , decodeTask
        , decodeUser
        )

{-| Provides decoders for converting JSON responses into record types published by MortyAPI.Types.

@docs decodeApproach
@docs decodeKanbanLanesSuccessResponse
@docs decodeTask
@docs decodeUser

-}

import Json.Decode as JD
import Json.Decode.Pipeline as JDP
import MortyAPI.Types


{-| Provides a decoder for JSON -> MortyAPI.Types.Approach
-}
decodeApproach : JD.Decoder MortyAPI.Types.Approach
decodeApproach =
    JDP.decode MortyAPI.Types.Approach
        |> JDP.required "id" JD.int
        |> JDP.required "task_id" JD.int
        |> JDP.required "user" decodeUser
        |> JDP.required "description" JD.string
        |> JDP.required "my_hours" (JD.nullable JD.float)
        |> JDP.required "senior_hours" (JD.nullable JD.float)
        |> JDP.required "mid_level_hours" (JD.nullable JD.float)
        |> JDP.required "junior_hours" (JD.nullable JD.float)


{-| Provides a decoder for JSON -> MortyAPI.Types.KanbanLanesSuccessResponse
-}
decodeKanbanLanesSuccessResponse : JD.Decoder MortyAPI.Types.KanbanLanesSuccessResponse
decodeKanbanLanesSuccessResponse =
    JDP.decode MortyAPI.Types.KanbanLanesSuccessResponse
        |> JDP.required "data" decodeKanbanLanesData


{-| Provides a decoder for JSON -> MortyAPI.Types.Task
-}
decodeTask : JD.Decoder MortyAPI.Types.Task
decodeTask =
    JDP.decode MortyAPI.Types.Task
        |> JDP.required "id" JD.int
        |> JDP.required "title" JD.string
        |> JDP.optional "description" JD.string ""
        |> JDP.required "task_type" JD.string
        |> JDP.required "external_identifier" JD.string
        |> JDP.required "status" JD.string
        |> JDP.required "seconds_since_status_changed" JD.int
        |> JDP.required "owned_by_user" (JD.nullable decodeUser)
        |> JDP.required "requested_by" (JD.nullable JD.string)
        |> JDP.required "task_approaches" (JD.list decodeApproach)
        |> JDP.required "prediction_group_id" (JD.nullable JD.int)
        |> JDP.required "prediction_judgement_at" (JD.nullable JD.string)
        |> JDP.required "mid_level_hour_estimate" (JD.nullable JD.int)


{-| Provides a decoder for JSON -> MortyAPI.Types.User
-}
decodeUser : JD.Decoder MortyAPI.Types.User
decodeUser =
    JDP.decode MortyAPI.Types.User
        |> JDP.required "id" JD.int
        |> JDP.required "full_name" JD.string
        |> JDP.required "email" JD.string
        |> JDP.required "seniority" JD.string
        |> JDP.required "prediction_book_api_token" (JD.nullable JD.string)


decodeKanbanTaskType : JD.Decoder MortyAPI.Types.KanbanTaskType
decodeKanbanTaskType =
    JD.string
        |> JD.andThen
            (\str ->
                case str of
                    "feature" ->
                        JD.succeed MortyAPI.Types.Feature

                    "chore" ->
                        JD.succeed MortyAPI.Types.Chore

                    _ ->
                        JD.succeed MortyAPI.Types.Bug
            )


decodeKanbanTaskPriority : JD.Decoder MortyAPI.Types.KanbanTaskPriority
decodeKanbanTaskPriority =
    (JD.nullable JD.int)
        |> JD.andThen
            (\maybeString ->
                case maybeString of
                    Just 1 ->
                        JD.succeed MortyAPI.Types.HighestPriority

                    Just 2 ->
                        JD.succeed MortyAPI.Types.SecondHighestPriority

                    Just 3 ->
                        JD.succeed MortyAPI.Types.ThirdHighestPriority

                    _ ->
                        JD.succeed MortyAPI.Types.LowerPriority
            )


decodeKanbanTask : JD.Decoder MortyAPI.Types.KanbanTask
decodeKanbanTask =
    JDP.decode MortyAPI.Types.KanbanTask
        |> JDP.required "days_since_last_changed" JD.int
        |> JDP.required "description" JD.string
        |> JDP.required "estimate" (JD.nullable JD.int)
        |> JDP.required "morty_url" JD.string
        |> JDP.required "pivotal_url" JD.string
        |> JDP.required "priority" decodeKanbanTaskPriority
        |> JDP.required "requested_by" (JD.nullable JD.string)
        |> JDP.required "task_type" decodeKanbanTaskType


decodeKanbanUser : JD.Decoder MortyAPI.Types.KanbanUser
decodeKanbanUser =
    JDP.decode MortyAPI.Types.KanbanUser
        |> JDP.required "email" JD.string
        |> JDP.required "full_name" JD.string


decodeKanbanStageStatusFields : JD.Decoder MortyAPI.Types.KanbanStageStatusFields
decodeKanbanStageStatusFields =
    JDP.decode MortyAPI.Types.KanbanStageStatusFields
        |> JDP.required "status" JD.string
        |> JDP.required "message" (JD.nullable JD.string)


decodeKanbanStageStatus : JD.Decoder MortyAPI.Types.KanbanStageStatus
decodeKanbanStageStatus =
    decodeKanbanStageStatusFields
        |> JD.andThen
            (\fields ->
                case fields.status of
                    "ok" ->
                        JD.succeed MortyAPI.Types.Ok

                    _ ->
                        JD.succeed (MortyAPI.Types.Problem (Maybe.withDefault "no message!" fields.message))
            )


decodeKanbanStage : JD.Decoder MortyAPI.Types.KanbanStage
decodeKanbanStage =
    JDP.decode MortyAPI.Types.KanbanStage
        |> JDP.required "result" decodeKanbanStageStatus
        |> JDP.required "tasks" (JD.list decodeKanbanTask)


decodeKanbanLane : JD.Decoder MortyAPI.Types.KanbanLane
decodeKanbanLane =
    JDP.decode MortyAPI.Types.KanbanLane
        |> JDP.required "accepted_stage" decodeKanbanStage
        |> JDP.required "delivered_stage" decodeKanbanStage
        |> JDP.required "in_progress_stage" decodeKanbanStage
        |> JDP.required "meta_stage" decodeKanbanStage
        |> JDP.required "to_do_stage" decodeKanbanStage
        |> JDP.required "to_estimate_stage" decodeKanbanStage
        |> JDP.required "user" decodeKanbanUser


decodeKanbanLanesAttributes : JD.Decoder MortyAPI.Types.KanbanLanes
decodeKanbanLanesAttributes =
    JDP.decode MortyAPI.Types.KanbanLanes
        |> JDP.required "label" JD.string
        |> JDP.required "kanban_lanes" (JD.list decodeKanbanLane)


decodeKanbanLanesData : JD.Decoder MortyAPI.Types.KanbanLanesData
decodeKanbanLanesData =
    JDP.decode MortyAPI.Types.KanbanLanesData
        |> JDP.required "attributes" decodeKanbanLanesAttributes
        |> JDP.required "id" JD.string
        |> JDP.required "type" JD.string
