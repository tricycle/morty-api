module MortyAPI.TestFactories exposing (..)

{-| Provides factory methods for testing purposes.

@docs firstTask
@docs secondTask
@docs thirdTask
@docs fourthTask
@docs fifthTask
@docs sixthTask
@docs firstUser
@docs secondUser
@docs kanbanLanesSuccessResponse
@docs teamsSuccessResponse

-}

import MortyAPI.Types


{-| A dummy feature task
-}
firstTask : MortyAPI.Types.KanbanTask
firstTask =
    { daysSinceLastChanged = 79
    , description = "Move below the fold blocks into CMS content blocks for Careers page"
    , estimate = Just 16
    , mortyUrl = "https://morty.trikeapps.com/tasks/2485582"
    , pivotalUrl = "https://www.pivotaltracker.com/story/show/154507088"
    , priority = MortyAPI.Types.HighestPriority
    , requestedBy = Just "John Black"
    , taskType = MortyAPI.Types.Feature
    }


{-| A dummy chore task
-}
secondTask : MortyAPI.Types.KanbanTask
secondTask =
    { daysSinceLastChanged = 94
    , description = "Update all logistics jobs to read/write from/to Siegfried /api/v1/domain/order endpoint"
    , estimate = Nothing
    , mortyUrl = "https://morty.trikeapps.com/tasks/2485504"
    , pivotalUrl = "https://www.pivotaltracker.com/story/show/154269718"
    , priority = MortyAPI.Types.SecondHighestPriority
    , requestedBy = Just "Bill Fring"
    , taskType = MortyAPI.Types.Chore
    }


{-| A dummy feature task
-}
thirdTask : MortyAPI.Types.KanbanTask
thirdTask =
    { daysSinceLastChanged = 78
    , description = "Move below the fold blocks into CMS content blocks for Retailers page"
    , estimate = Just 6
    , mortyUrl = "https://morty.trikeapps.com/tasks/2485277"
    , pivotalUrl = "https://www.pivotaltracker.com/story/show/152743157"
    , priority = MortyAPI.Types.ThirdHighestPriority
    , requestedBy = Just "Matt Bixby"
    , taskType = MortyAPI.Types.Feature
    }


{-| A dummy feature task
-}
fourthTask : MortyAPI.Types.KanbanTask
fourthTask =
    { daysSinceLastChanged = 85
    , description = "No way to discover where a promotion is being used…"
    , estimate = Just 10
    , mortyUrl = "https://morty.trikeapps.com/tasks/2485348"
    , pivotalUrl = "https://www.pivotaltracker.com/story/show/153040253"
    , requestedBy = Just "Matt Bixby"
    , priority = MortyAPI.Types.LowerPriority
    , taskType = MortyAPI.Types.Feature
    }


{-| A dummy feature task
-}
fifthTask : MortyAPI.Types.KanbanTask
fifthTask =
    { daysSinceLastChanged = 77
    , description = "Apache rewrites need to be handled by something else because we are going to move to nginx"
    , estimate = Just 4
    , mortyUrl = "https://morty.trikeapps.com/tasks/2485581"
    , pivotalUrl = "https://www.pivotaltracker.com/story/show/154506909"
    , priority = MortyAPI.Types.LowerPriority
    , requestedBy = Just "Kris D'Angelici"
    , taskType = MortyAPI.Types.Feature
    }


{-| A dummy feature task
-}
sixthTask : MortyAPI.Types.KanbanTask
sixthTask =
    { daysSinceLastChanged = 78
    , description = "Refactor currency formatting in V3"
    , estimate = Just 6
    , mortyUrl = "https://morty.trikeapps.com/tasks/2485461"
    , pivotalUrl = "https://www.pivotaltracker.com/story/show/153866866"
    , priority = MortyAPI.Types.LowerPriority
    , requestedBy = Just "Kris D'Angelici"
    , taskType = MortyAPI.Types.Feature
    }


{-| A dummy user
-}
firstUser : MortyAPI.Types.KanbanUser
firstUser =
    { email = "bentleigh.smith@bellroy.com", fullName = "Bentleigh Smith" }


{-| A dummy user
-}
secondUser : MortyAPI.Types.KanbanUser
secondUser =
    { email = "carlos.negros@bellroy.com", fullName = "Carlos Negros" }


{-| A dummy full Kanban lanes response from the API
-}
kanbanLanesSuccessResponse : MortyAPI.Types.KanbanLanesSuccessResponse
kanbanLanesSuccessResponse =
    { data =
        { attributes =
            { label = "Team: Bellroy Tech"
            , kanbanLanes =
                [ { acceptedStage = { status = MortyAPI.Types.Ok, tasks = [] }
                  , deliveredStage = { status = MortyAPI.Types.Ok, tasks = [] }
                  , inProgressStage = { status = MortyAPI.Types.Ok, tasks = [ firstTask ] }
                  , metaStage = { status = MortyAPI.Types.Ok, tasks = [] }
                  , toDoStage = { status = MortyAPI.Types.Ok, tasks = [ secondTask ] }
                  , toEstimateStage = { status = MortyAPI.Types.Ok, tasks = [] }
                  , user = firstUser
                  }
                , { acceptedStage = { status = MortyAPI.Types.Ok, tasks = [] }
                  , deliveredStage = { status = MortyAPI.Types.Ok, tasks = [ thirdTask, fourthTask ] }
                  , inProgressStage = { status = MortyAPI.Types.Ok, tasks = [ fifthTask, sixthTask ] }
                  , metaStage = { status = MortyAPI.Types.Problem "Carlos Negros does not have anything queued up", tasks = [] }
                  , toDoStage = { status = MortyAPI.Types.Ok, tasks = [] }
                  , toEstimateStage = { status = MortyAPI.Types.Ok, tasks = [] }
                  , user = secondUser
                  }
                ]
            }
        , id = "Team: Bellroy Tech"
        , dataType = "kanban_lanes"
        }
    }


{-| A dummy full Teams response from the API
-}
teamsSuccessResponse : MortyAPI.Types.TeamsSuccessResponse
teamsSuccessResponse =
    { data =
        { attributes =
            [ { id = 1
              , identifier = Nothing
              , name = "Bellroy Tech Team"
              , members =
                    [ { id = 24
                      , fullName = "Catherine Truscott"
                      , email = "catherine.truscott@bellroy.com"
                      , seniority = "Senior"
                      }
                    , { id = 36
                      , fullName = "Chris D'Aloisio"
                      , email = "chris.daloisio@bellroy.com"
                      , seniority = "Senior"
                      }
                    ]
              }
            ]
        }
    }
