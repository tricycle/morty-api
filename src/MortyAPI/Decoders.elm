module MortyAPI.Decoders
    exposing
        ( decodeApproach
        , decodeKanbanLanesSuccessResponse
        , decodeTask
        , decodeUser
        )

{-| Provides decoders for converting JSON responses into record types published by MortyAPI.Models.

@docs decodeApproach
@docs decodeKanbanLanesSuccessResponse
@docs decodeTask
@docs decodeUser

-}

import Json.Decode as JD
import Json.Decode.Pipeline as JDP
import MortyAPI.Models


{-| Provides a decoder for JSON -> MortyAPI.Models.Approach
-}
decodeApproach : JD.Decoder MortyAPI.Models.Approach
decodeApproach =
    JDP.decode MortyAPI.Models.Approach
        |> JDP.required "id" JD.int
        |> JDP.required "task_id" JD.int
        |> JDP.required "user" decodeUser
        |> JDP.required "description" JD.string
        |> JDP.required "my_hours" (JD.nullable JD.float)
        |> JDP.required "senior_hours" (JD.nullable JD.float)
        |> JDP.required "mid_level_hours" (JD.nullable JD.float)
        |> JDP.required "junior_hours" (JD.nullable JD.float)


{-| Provides a decoder for JSON -> MortyAPI.Models.KanbanLanesSuccessResponse
-}
decodeKanbanLanesSuccessResponse : JD.Decoder MortyAPI.Models.KanbanLanesSuccessResponse
decodeKanbanLanesSuccessResponse =
    JDP.decode MortyAPI.Models.KanbanLanesSuccessResponse
        |> JDP.required "data" decodeKanbanLanesData


{-| Provides a decoder for JSON -> MortyAPI.Models.Task
-}
decodeTask : JD.Decoder MortyAPI.Models.Task
decodeTask =
    JDP.decode MortyAPI.Models.Task
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


{-| Provides a decoder for JSON -> MortyAPI.Models.User
-}
decodeUser : JD.Decoder MortyAPI.Models.User
decodeUser =
    JDP.decode MortyAPI.Models.User
        |> JDP.required "id" JD.int
        |> JDP.required "full_name" JD.string
        |> JDP.required "email" JD.string
        |> JDP.required "seniority" JD.string
        |> JDP.required "prediction_book_api_token" (JD.nullable JD.string)


decodeKanbanTaskType : JD.Decoder MortyAPI.Models.KanbanTaskType
decodeKanbanTaskType =
    JD.string
        |> JD.andThen
            (\str ->
                case str of
                    "feature" ->
                        JD.succeed MortyAPI.Models.Feature

                    "chore" ->
                        JD.succeed MortyAPI.Models.Chore

                    _ ->
                        JD.succeed MortyAPI.Models.Bug
            )


decodeKanbanTask : JD.Decoder MortyAPI.Models.KanbanTask
decodeKanbanTask =
    JDP.decode MortyAPI.Models.KanbanTask
        |> JDP.required "days_since_last_changed" JD.int
        |> JDP.required "description" JD.string
        |> JDP.required "estimate" (JD.nullable JD.int)
        |> JDP.required "morty_url" JD.string
        |> JDP.required "pivotal_url" JD.string
        |> JDP.required "requested_by" (JD.nullable JD.string)
        |> JDP.required "task_type" decodeKanbanTaskType


decodeKanbanUser : JD.Decoder MortyAPI.Models.KanbanUser
decodeKanbanUser =
    JDP.decode MortyAPI.Models.KanbanUser
        |> JDP.required "email" JD.string
        |> JDP.required "full_name" JD.string


decodeKanbanStageStatusFields : JD.Decoder MortyAPI.Models.KanbanStageStatusFields
decodeKanbanStageStatusFields =
    JDP.decode MortyAPI.Models.KanbanStageStatusFields
        |> JDP.required "status" JD.string
        |> JDP.required "message" (JD.nullable JD.string)


decodeKanbanStageStatus : JD.Decoder MortyAPI.Models.KanbanStageStatus
decodeKanbanStageStatus =
    decodeKanbanStageStatusFields
        |> JD.andThen
            (\fields ->
                case fields.status of
                    "ok" ->
                        JD.succeed MortyAPI.Models.Ok

                    _ ->
                        JD.succeed (MortyAPI.Models.Problem (Maybe.withDefault "no message!" fields.message))
            )


decodeKanbanStage : JD.Decoder MortyAPI.Models.KanbanStage
decodeKanbanStage =
    JDP.decode MortyAPI.Models.KanbanStage
        |> JDP.required "result" decodeKanbanStageStatus
        |> JDP.required "tasks" (JD.list decodeKanbanTask)


decodeKanbanLane : JD.Decoder MortyAPI.Models.KanbanLane
decodeKanbanLane =
    JDP.decode MortyAPI.Models.KanbanLane
        |> JDP.required "accepted_stage" decodeKanbanStage
        |> JDP.required "delivered_stage" decodeKanbanStage
        |> JDP.required "in_progress_stage" decodeKanbanStage
        |> JDP.required "meta_stage" decodeKanbanStage
        |> JDP.required "to_do_stage" decodeKanbanStage
        |> JDP.required "to_estimate_stage" decodeKanbanStage
        |> JDP.required "user" decodeKanbanUser


decodeKanbanLanesAttributes : JD.Decoder MortyAPI.Models.KanbanLanes
decodeKanbanLanesAttributes =
    JDP.decode MortyAPI.Models.KanbanLanes
        |> JDP.required "label" JD.string
        |> JDP.required "kanban_lanes" (JD.list decodeKanbanLane)


decodeKanbanLanesData : JD.Decoder MortyAPI.Models.KanbanLanesData
decodeKanbanLanesData =
    JDP.decode MortyAPI.Models.KanbanLanesData
        |> JDP.required "attributes" decodeKanbanLanesAttributes
        |> JDP.required "id" JD.string
        |> JDP.required "type" JD.string
