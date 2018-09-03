module MortyAPI.Encoders exposing (encodeApproach, encodeTask)

{-| Provides encoders for converting record types published by MortyAPI.Types into JSON responses.

@docs encodeApproach
@docs encodeTask

-}

import MortyAPI.Types exposing (User, Task, Approach)
import Json.Encode exposing (object, Value, int, null, string, float)


{-| Encode MortyAPI.Types.Task into JSON.
-}
encodeTask : Task -> Value
encodeTask task =
    let
        predictionGroupIdValue =
            task.predictionGroupId |> Maybe.map int |> Maybe.withDefault null

        predictionJudgementAtValue =
            task.predictionJudgementAt |> Maybe.map string |> Maybe.withDefault null

        estimateValue =
            task.midLevelHourEstimate |> Maybe.map int |> Maybe.withDefault null
    in
        Json.Encode.object
            [ ( "task"
              , Json.Encode.object
                    [ ( "id", int task.id )
                    , ( "prediction_group_id", predictionGroupIdValue )
                    , ( "prediction_judgement_at", predictionJudgementAtValue )
                    , ( "mid_level_hour_estimate", estimateValue )
                    ]
              )
            ]


{-| Encode MortyAPI.Types.Approach into JSON.
-}
encodeApproach : Approach -> Value
encodeApproach approach =
    let
        myHoursList =
            case approach.myHours of
                Just myHours ->
                    [ ( "my_hours", float myHours ) ]

                Nothing ->
                    []

        seniorHoursList =
            case approach.seniorHours of
                Just seniorHours ->
                    [ ( "senior_hours", float seniorHours ) ]

                Nothing ->
                    []

        midLevelHoursList =
            case approach.midLevelHours of
                Just midLevelHours ->
                    [ ( "mid_level_hours", float midLevelHours ) ]

                Nothing ->
                    []

        juniorHoursList =
            case approach.juniorHours of
                Just juniorHours ->
                    [ ( "junior_hours", float juniorHours ) ]

                Nothing ->
                    []

        elements =
            [ ( "task_id", int approach.taskId )
            , ( "user_id", int approach.user.id )
            , ( "description", string approach.description )
            ]
                ++ myHoursList
                ++ seniorHoursList
                ++ midLevelHoursList
                ++ juniorHoursList
    in
        Json.Encode.object
            [ ( "task_approach"
              , Json.Encode.object
                    elements
              )
            ]
