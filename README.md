# Morty API

A library for interfacing with the Morty API. Morty is a time tracking system used by Bellroy
(built originally by TrikeApps, who became part of Bellroy in late 2017).

## Installation

```
elm install tricycle/morty-api
```

## Usage

To retrieve details of a task:
```
init : ( Model, Cmd Msg )
init =
    let
        taskParameters =
                    { mortyApiToken = "my api token"
                    , mortyHost = "https://morty.trikeapps.com"
                    , taskId = 234873
                    , msgType = MyApplicationMsg
                    }
    in
        ( model, Cmd.batch [ MortyAPI.Command.getTaskCommand taskParameters ])
```

Other operations available:
* Get current user details (matching API token)
* Search for tasks
* Retrieve task details
* Update a tasks details
* Add an approach for a task
* Retrieve the Kanban lanes for a specific user
* Retrieve the Kanban lanes for a specific team
* Retrieve all teams and their members
