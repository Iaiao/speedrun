# A simple REST API wrapper for [Speedrun.com](https://speedrun.com) written in [V](https://github.com/vlang/v)
This module contains functions for reading main data from speedrun.com.


## Install
`v install speedrun`

## Doc
`v doc speedrun`

## Example
Print all registered runners (skipping guests) of first 500 Minecraft runs:
```v
import speedrun

fn main() {
    minecraft := speedrun.search_game("mc")?
    runs := minecraft.runs(500, 0)
    mut users := []speedrun.User
    for run in runs {
        for player in run.players {
            if player.rel == "user" {
                user := speedrun.fetch_user(player.id)?
                users << user
            }
        }
    }
    for user in users {
        println(user.names.international)
    }
}
```

## Not implemented yet
- Multiple filters
- Genres, Platforms, Publishers, Regions, Series, Variables (waiting for generics or type args to avoid copypasting)
- Not read-only API
