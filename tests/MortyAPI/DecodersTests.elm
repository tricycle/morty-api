module MortyAPI.DecodersTests exposing (..)

import Expect
import Json.Decode
import MortyAPI.Decoders
import Test exposing (..)
import MortyAPI.TestFactories


suite : Test
suite =
    describe "MortyDecoders"
        [ describe "decodeTeamsSuccessResponse"
            [ test "data is decoded properly" <|
                \() ->
                    let
                        data =
                            """
                            {
                               "jsonapi":{
                                  "version":"1.0"
                               },
                               "data":{
                                  "attributes":[
                                     {
                                        "id":1,
                                        "created_at":"2014-11-25T15:25:11.288+11:00",
                                        "updated_at":"2018-05-07T08:41:36.985+10:00",
                                        "name":"Bellroy Tech Team",
                                        "identifier":null,
                                        "members":[
                                           {
                                              "id":24,
                                              "created_at":"2014-11-20T17:50:58.823+11:00",
                                              "updated_at":"2018-08-22T13:07:52.621+10:00",
                                              "full_name":"Catherine Truscott",
                                              "email":"catherine.truscott@bellroy.com",
                                              "seniority":"Senior"
                                           },
                                           {
                                              "id":36,
                                              "created_at":"2014-11-20T17:51:00.424+11:00",
                                              "updated_at":"2018-08-30T16:34:24.438+10:00",
                                              "full_name":"Chris D'Aloisio",
                                              "email":"chris.daloisio@bellroy.com",
                                              "seniority":"Senior"
                                           }
                                        ]
                                     }
                                  ]
                               }
                            }
                            """

                        decoder =
                            MortyAPI.Decoders.decodeTeamsSuccessResponse

                        decodedOutput =
                            Json.Decode.decodeString decoder data

                        expectedResult =
                            (Ok MortyAPI.TestFactories.teamsSuccessResponse)
                    in
                        Expect.equal decodedOutput expectedResult
            ]
        , describe "decodeKanbanLanesSuccessResponse"
            [ test "data is decoded properly" <|
                \() ->
                    let
                        data =
                            """
                            {
                               "data":{
                                  "attributes":{
                                     "label":"Team: Bellroy Tech",
                                     "kanban_lanes":[
                                        {
                                           "accepted_stage":{
                                              "result":{"status":"ok", "message":null},
                                              "tasks":[

                                              ]
                                           },
                                           "delivered_stage":{
                                              "result":{"status":"ok", "message":null},
                                              "tasks":[

                                              ]
                                           },
                                           "in_progress_stage":{
                                              "result":{"status":"ok", "message":null},
                                              "tasks":[
                                                 {
                                                    "days_since_last_changed":79,
                                                    "description":"Move below the fold blocks into CMS content blocks for Careers page",
                                                    "estimate":16,
                                                    "morty_url":"https://morty.trikeapps.com/tasks/2485582",
                                                    "pivotal_url":"https://www.pivotaltracker.com/story/show/154507088",
                                                    "priority":1,
                                                    "requested_by":"John Black",
                                                    "task_type":"feature"
                                                 }
                                              ]
                                           },
                                           "meta_stage":{
                                              "result":{"status":"ok", "message":null},
                                              "tasks":[]
                                           },
                                           "to_do_stage":{
                                              "result":{"status":"ok", "message":null},
                                              "tasks":[
                                                 {
                                                    "days_since_last_changed":94,
                                                    "description":"Update all logistics jobs to read/write from/to Siegfried /api/v1/domain/order endpoint",
                                                    "estimate":null,
                                                    "morty_url":"https://morty.trikeapps.com/tasks/2485504",
                                                    "pivotal_url":"https://www.pivotaltracker.com/story/show/154269718",
                                                    "priority":2,
                                                    "requested_by":"Bill Fring",
                                                    "task_type":"chore"
                                                 }
                                              ]
                                           },
                                           "to_estimate_stage":{
                                              "result":{"status":"ok", "message":null},
                                              "tasks":[

                                              ]
                                           },
                                           "user":{
                                              "email":"bentleigh.smith@bellroy.com",
                                              "full_name":"Bentleigh Smith"
                                           }
                                        },
                                        {
                                           "accepted_stage":{
                                              "result":{"status":"ok", "message":null},
                                              "tasks":[

                                              ]
                                           },
                                           "delivered_stage":{
                                              "result":{"status":"ok", "message":null},
                                              "tasks":[
                                                 {
                                                    "days_since_last_changed":78,
                                                    "description":"Move below the fold blocks into CMS content blocks for Retailers page",
                                                    "estimate":6,
                                                    "morty_url":"https://morty.trikeapps.com/tasks/2485277",
                                                    "pivotal_url":"https://www.pivotaltracker.com/story/show/152743157",
                                                    "priority":3,
                                                    "requested_by":"Matt Bixby",
                                                    "task_type":"feature"
                                                 },
                                                 {
                                                    "days_since_last_changed":85,
                                                    "description":"No way to discover where a promotion is being used…",
                                                    "estimate":10,
                                                    "morty_url":"https://morty.trikeapps.com/tasks/2485348",
                                                    "pivotal_url":"https://www.pivotaltracker.com/story/show/153040253",
                                                    "priority":4,
                                                    "requested_by":"Matt Bixby",
                                                    "task_type":"feature"
                                                 }
                                              ]
                                           },
                                           "in_progress_stage":{
                                              "result":{"status":"ok", "message":null},
                                              "tasks":[
                                                 {
                                                    "days_since_last_changed":77,
                                                    "description":"Apache rewrites need to be handled by something else because we are going to move to nginx",
                                                    "estimate":4,
                                                    "morty_url":"https://morty.trikeapps.com/tasks/2485581",
                                                    "pivotal_url":"https://www.pivotaltracker.com/story/show/154506909",
                                                    "priority":5,
                                                    "requested_by":"Kris D'Angelici",
                                                    "task_type":"feature"
                                                 },
                                                 {
                                                    "days_since_last_changed":78,
                                                    "description":"Refactor currency formatting in V3",
                                                    "estimate":6,
                                                    "morty_url":"https://morty.trikeapps.com/tasks/2485461",
                                                    "pivotal_url":"https://www.pivotaltracker.com/story/show/153866866",
                                                    "priority":6,
                                                    "requested_by":"Kris D'Angelici",
                                                    "task_type":"feature"
                                                 }
                                              ]
                                           },
                                           "meta_stage":{
                                              "result":{"status":"problem","message":"Carlos Negros does not have anything queued up"},
                                              "tasks":[

                                              ]
                                           },
                                           "to_do_stage":{
                                              "result":{"status":"ok", "message":null},
                                              "tasks":[

                                              ]
                                           },
                                           "to_estimate_stage":{
                                              "result":{"status":"ok", "message":null},
                                              "tasks":[

                                              ]
                                           },
                                           "user":{
                                              "email":"carlos.negros@bellroy.com",
                                              "full_name":"Carlos Negros"
                                           }
                                        }
                                     ]
                                  },
                                  "id":"Team: Bellroy Tech",
                                  "type":"kanban_lanes"
                               }
                            }
                            """

                        decoder =
                            MortyAPI.Decoders.decodeKanbanLanesSuccessResponse

                        decodedOutput =
                            Json.Decode.decodeString decoder data

                        expectedResult =
                            (Ok MortyAPI.TestFactories.kanbanLanesSuccessResponse)
                    in
                        Expect.equal decodedOutput expectedResult
            ]
        , describe "decodeTasks"
            [ test "data is decoded properly" <|
                \() ->
                    let
                        data =
                            """
                            [
                              {
                                "id":1369986,
                                "title":"Rename \\"Classification Code\\" to \\"GL Code\\" in the UI",
                                "created_at":null,
                                "updated_at":null,
                                "description":"... and back and forth we go...",
                                "task_type":"feature",
                                "status":"accepted",
                                "requested_by":"David Goodlad",
                                "owned_by_user":{
                                  "id":36,
                                  "created_at":"2014-11-20T17:51:00.424+11:00",
                                  "updated_at":"2017-09-10T22:27:47.803+10:00",
                                  "full_name":"Chris D'Aloisio",
                                  "email":"chris@trikeapps.com",
                                  "seniority":"Senior",
                                  "prediction_book_api_token":"a_token"
                                },
                                "external_identifier":"9816539",
                                "prediction_group_id":null,
                                "prediction_judgement_at":null,
                                "mid_level_hour_estimate":1,
                                "task_approaches":[],
                                "seconds_since_status_changed":78999
                              },
                              {
                                "id":2483545,
                                "title":"Support soft deletion in all Kaos objects",
                                "created_at":"2017-01-20T09:40:41.177+11:00",
                                "updated_at":"2017-06-13T08:53:12.751+10:00",
                                "description":"Implement soft deletion on all Kaos models so that deletions get synchronised to slaves. Build a spec that iterates through all non-abstract classes that inherit from ActiveRecord::Base in the Kaos namespace and check they have this property.",
                                "task_type":"feature",
                                "status":"accepted",
                                "requested_by":"Michael Webb",
                                "owned_by_user":{
                                  "id":36,
                                  "created_at":"2014-11-20T17:51:00.424+11:00",
                                  "updated_at":"2017-09-10T22:27:47.803+10:00",
                                  "full_name":"Chris D'Aloisio",
                                  "email":"chris@trikeapps.com",
                                  "seniority":"Senior",
                                  "prediction_book_api_token":"a_token"
                                },
                                "external_identifier":"138004795",
                                "prediction_group_id":null,
                                "prediction_judgement_at":null,
                                "mid_level_hour_estimate":8,
                                "task_approaches":[
                                  {
                                    "id":1887,
                                    "task_id":2483545,
                                    "description":"- add a soft deletion to all kaos models - this is propagated automatically via the already registered webhooks - each system receives the changed information and updates it live",
                                    "created_at":"2017-02-02T13:08:02.553+11:00",
                                    "updated_at":"2017-02-02T13:08:41.725+11:00",
                                    "my_hours":null,
                                    "senior_hours":null,
                                    "mid_level_hours":null,
                                    "junior_hours":null,
                                    "user":{
                                      "id":36,
                                      "created_at":"2014-11-20T17:51:00.424+11:00",
                                      "updated_at":"2017-09-10T22:27:47.803+10:00",
                                      "full_name":"Chris D'Aloisio",
                                      "email":"chris@trikeapps.com",
                                      "seniority":"Senior",
                                      "prediction_book_api_token":"a_token"
                                    }
                                  },
                                  {
                                    "id":1888,
                                    "task_id":2483545,
                                    "description":"Same as 0 because we've run out of estimation time",
                                    "created_at":"2017-02-02T13:08:39.800+11:00",
                                    "updated_at":"2017-02-02T13:08:41.753+11:00",
                                    "my_hours":null,
                                    "senior_hours":null,
                                    "mid_level_hours":null,
                                    "junior_hours":null,
                                    "user":{
                                      "id":36,
                                      "created_at":"2014-11-20T17:51:00.424+11:00",
                                      "updated_at":"2017-09-10T22:27:47.803+10:00",
                                      "full_name":"Chris D'Aloisio",
                                      "email":"chris@trikeapps.com",
                                      "seniority":"Senior",
                                      "prediction_book_api_token":"a_token"
                                    }
                                  }
                                ],
                                "seconds_since_status_changed":78999
                              }
                            ]
                            """

                        decoder =
                            Json.Decode.list MortyAPI.Decoders.decodeTask

                        decodedOutput =
                            Json.Decode.decodeString decoder data

                        expectedResult =
                            (Ok
                                [ { id = 1369986
                                  , title = "Rename \"Classification Code\" to \"GL Code\" in the UI"
                                  , description = "... and back and forth we go..."
                                  , taskType = "feature"
                                  , externalIdentifier = "9816539"
                                  , status = "accepted"
                                  , requestedBy = Just "David Goodlad"
                                  , ownedBy =
                                        Just
                                            { id = 36
                                            , fullName = "Chris D'Aloisio"
                                            , email = "chris@trikeapps.com"
                                            , seniority = "Senior"
                                            , predictionBookApiToken = Just "a_token"
                                            }
                                  , taskApproaches = []
                                  , predictionGroupId = Nothing
                                  , predictionJudgementAt = Nothing
                                  , midLevelHourEstimate = Just 1
                                  , secondsSinceStatusChanged = 78999
                                  }
                                , { id = 2483545
                                  , title = "Support soft deletion in all Kaos objects"
                                  , description = "Implement soft deletion on all Kaos models so that deletions get synchronised to slaves. Build a spec that iterates through all non-abstract classes that inherit from ActiveRecord::Base in the Kaos namespace and check they have this property."
                                  , taskType = "feature"
                                  , externalIdentifier = "138004795"
                                  , status = "accepted"
                                  , requestedBy = Just "Michael Webb"
                                  , ownedBy =
                                        Just
                                            { id = 36
                                            , fullName = "Chris D'Aloisio"
                                            , email = "chris@trikeapps.com"
                                            , seniority = "Senior"
                                            , predictionBookApiToken = Just "a_token"
                                            }
                                  , taskApproaches =
                                        [ { id = 1887
                                          , taskId = 2483545
                                          , user =
                                                { id = 36
                                                , fullName = "Chris D'Aloisio"
                                                , email = "chris@trikeapps.com"
                                                , seniority = "Senior"
                                                , predictionBookApiToken = Just "a_token"
                                                }
                                          , description = "- add a soft deletion to all kaos models - this is propagated automatically via the already registered webhooks - each system receives the changed information and updates it live"
                                          , myHours = Nothing
                                          , seniorHours = Nothing
                                          , midLevelHours = Nothing
                                          , juniorHours = Nothing
                                          }
                                        , { id = 1888
                                          , taskId = 2483545
                                          , user =
                                                { id = 36
                                                , fullName = "Chris D'Aloisio"
                                                , email = "chris@trikeapps.com"
                                                , seniority = "Senior"
                                                , predictionBookApiToken = Just "a_token"
                                                }
                                          , description = "Same as 0 because we've run out of estimation time"
                                          , myHours = Nothing
                                          , seniorHours = Nothing
                                          , midLevelHours = Nothing
                                          , juniorHours = Nothing
                                          }
                                        ]
                                  , predictionGroupId = Nothing
                                  , predictionJudgementAt = Nothing
                                  , midLevelHourEstimate = Just 8
                                  , secondsSinceStatusChanged = 78999
                                  }
                                ]
                            )
                    in
                        Expect.equal decodedOutput expectedResult
            ]
        ]
