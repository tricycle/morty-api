module Tests.MortyAPI.Factories exposing (..)

import MortyAPI.Models


firstTask : MortyAPI.Models.KanbanTask
firstTask =
    { daysSinceLastChanged = 79
    , description = "Move below the fold blocks into CMS content blocks for Careers page"
    , estimate = Just 16
    , mortyUrl = "https://morty.trikeapps.com/tasks/2485582"
    , pivotalUrl = "https://www.pivotaltracker.com/story/show/154507088"
    , requestedBy = Just "John Black"
    , taskType = MortyAPI.Models.Feature
    }


secondTask : MortyAPI.Models.KanbanTask
secondTask =
    { daysSinceLastChanged = 94
    , description = "Update all logistics jobs to read/write from/to Siegfried /api/v1/domain/order endpoint"
    , estimate = Nothing
    , mortyUrl = "https://morty.trikeapps.com/tasks/2485504"
    , pivotalUrl = "https://www.pivotaltracker.com/story/show/154269718"
    , requestedBy = Just "Bill Fring"
    , taskType = MortyAPI.Models.Chore
    }


thirdTask : MortyAPI.Models.KanbanTask
thirdTask =
    { daysSinceLastChanged = 78
    , description = "Move below the fold blocks into CMS content blocks for Retailers page"
    , estimate = Just 6
    , mortyUrl = "https://morty.trikeapps.com/tasks/2485277"
    , pivotalUrl = "https://www.pivotaltracker.com/story/show/152743157"
    , requestedBy = Just "Matt Bixby"
    , taskType = MortyAPI.Models.Feature
    }


fourthTask : MortyAPI.Models.KanbanTask
fourthTask =
    { daysSinceLastChanged = 85
    , description = "No way to discover where a promotion is being used…"
    , estimate = Just 10
    , mortyUrl = "https://morty.trikeapps.com/tasks/2485348"
    , pivotalUrl = "https://www.pivotaltracker.com/story/show/153040253"
    , requestedBy = Just "Matt Bixby"
    , taskType = MortyAPI.Models.Feature
    }


fifthTask : MortyAPI.Models.KanbanTask
fifthTask =
    { daysSinceLastChanged = 77
    , description = "Apache rewrites need to be handled by something else because we are going to move to nginx"
    , estimate = Just 4
    , mortyUrl = "https://morty.trikeapps.com/tasks/2485581"
    , pivotalUrl = "https://www.pivotaltracker.com/story/show/154506909"
    , requestedBy = Just "Kris D'Angelici"
    , taskType = MortyAPI.Models.Feature
    }


sixthTask : MortyAPI.Models.KanbanTask
sixthTask =
    { daysSinceLastChanged = 78
    , description = "Refactor currency formatting in V3"
    , estimate = Just 6
    , mortyUrl = "https://morty.trikeapps.com/tasks/2485461"
    , pivotalUrl = "https://www.pivotaltracker.com/story/show/153866866"
    , requestedBy = Just "Kris D'Angelici"
    , taskType = MortyAPI.Models.Feature
    }


firstUser : MortyAPI.Models.KanbanUser
firstUser =
    { email = "bentleigh.smith@bellroy.com", fullName = "Bentleigh Smith" }


secondUser : MortyAPI.Models.KanbanUser
secondUser =
    { email = "carlos.negros@bellroy.com", fullName = "Carlos Negros" }


kanbanLanesSuccessResponse : MortyAPI.Models.KanbanLanesSuccessResponse
kanbanLanesSuccessResponse =
    { data =
        { attributes =
            { label = "Team: Bellroy Tech"
            , kanbanLanes =
                [ { acceptedStage = { status = MortyAPI.Models.Ok, tasks = [] }
                  , deliveredStage = { status = MortyAPI.Models.Ok, tasks = [] }
                  , inProgressStage = { status = MortyAPI.Models.Ok, tasks = [ firstTask ] }
                  , metaStage = { status = MortyAPI.Models.Ok, tasks = [] }
                  , toDoStage = { status = MortyAPI.Models.Ok, tasks = [ secondTask ] }
                  , toEstimateStage = { status = MortyAPI.Models.Ok, tasks = [] }
                  , user = firstUser
                  }
                , { acceptedStage = { status = MortyAPI.Models.Ok, tasks = [] }
                  , deliveredStage = { status = MortyAPI.Models.Ok, tasks = [ thirdTask, fourthTask ] }
                  , inProgressStage = { status = MortyAPI.Models.Ok, tasks = [ fifthTask, sixthTask ] }
                  , metaStage = { status = MortyAPI.Models.Problem "Carlos Negros does not have anything queued up", tasks = [] }
                  , toDoStage = { status = MortyAPI.Models.Ok, tasks = [] }
                  , toEstimateStage = { status = MortyAPI.Models.Ok, tasks = [] }
                  , user = secondUser
                  }
                ]
            }
        , id = "Team: Bellroy Tech"
        , dataType = "kanban_lanes"
        }
    }
