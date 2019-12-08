# Import module
```v
import iaiao.speedrun
```

# Doc generated with `v doc`
Private functions and structs hidden

```v
module iaiao.speedrun

struct Run {
        _date string [ json : 'date' ]
        pub :
        id string
        submitted string
        links []Link
        videos Videos
        comment string
        splits Link
        times Times
        game_id string [ json : 'game' ]
        level_id string [ json : 'level' ]
        category_id string [ json : 'category' ]
        players []ID
        mut :
        status VerifyStatus
        date time . Time

}
struct Times {
        pub :
        primary string
        primary_t f64
        realtime string
        realtime_t f64
        realtime_noloads string
        realtime_noloads_t f64
        ingame string
        ingame_t f64

}
struct System {
        pub :
        platform string
        emulated bool
        region string

}
struct Link {
        pub :
        rel string
        uri string

}
struct ID {
        pub :
        rel string
        id string

}
struct Videos {
        pub :
        links []string

}
struct VerifyStatus {
        _verify_date string [ json : 'verify-date' ]
        pub :
        status string
        examiner string
        mut :
        verified bool
        verify_date time . Time

}
struct Game {
        pub :
        id string
        names Names
        abbreviation string
        released int
        ruleset RuleSet
        romhack bool
        gametypes []string
        platforms []string
        regions []string
        genres []string
        engines []string
        developers []string
        publishers []string
        _created string [ json : 'created' ]
        _release_date string [ json : 'release-date' ]
        mut :
        release_date time . Time
        created time . Time

}
struct RuleSet {
        pub :
        show_milliseconds bool [ json : 'show-milliseconds' ]
        require_verification bool [ json : 'require-verification' ]
        require_video bool [ json : 'require-video' ]
        run_times []string [ json : 'run-times' ]
        default_time string [ json : 'default-time' ]
        emulators_allowed bool [ json : 'emulators-allowed' ]

}
struct Names {
        pub :
        international string
        japanese string
        twitch string

}
struct Level {
        pub :
        id string
        name string
        rules string
        links []Link

}
struct Category {
        pub :
        id string
        name string
        category_type string [ json : 'type' ]
        rules string
        players PlayerRule
        miscellaneous bool
        links []Link

}
struct Leaderboard {
        pub :
        game_id string [ json : 'game' ]
        category_id string [ json : 'category' ]
        level_id string [ json : 'level' ]
        platform string
        region string
        emulators []string
        video_only bool [ json : 'video-only' ]
        timing string
        links []Link
        runs []Place

}
struct Place {
        pub :
        place int
        run Run

}
struct PlayerRule {
        pub :
        category_type string [ json : 'type' ]
        value int

}
struct User {
        _signup string [ json : 'signup' ]
        pub :
        id string
        names Names
        name_style NameStyle [ json : 'name-style' ]
        role string
        location Location
        mut :
        signup time . Time

}
struct Location {
        pub :
        country Country

}
struct Country {
        pub :
        code string
        names Names

}
struct NameStyle {
        pub :
        style string
        color_from Color [ json : 'color-from' ]
        color_to Color [ json : 'color-to' ]

}
struct Color {
        pub :
        light string
        dark string

}
struct Developer {
        pub :
        id string
        name string
        links []Link

}
struct Engine {
        pub :
        id string
        name string
        links []Link

}
struct GameType {
        pub :
        id string
        name string
        allows_base_game string [ json : 'allows-base-game' ]
        links []Link

}
fn fetch_games (_count, offset int) ?[]Game
fn fetch_game (id string) ?Game
fn fetch_leaderboard_category (game_id, category_id string) ?Leaderboard
fn fetch_leaderboard_level (game_id, category_id, level_id string) ?Leaderboard
fn fetch_user (id string) ?User
fn fetch_run (id string) ?Run
fn fetch_runs (game_id string, _count, offset int) ?[]Run
fn fetch_category (category_id string) ?Category
fn fetch_level (level_id string) ?Level
fn fetch_developers (_count, offset int) ?[]Developer
fn fetch_developer (id string) ?Developer
fn fetch_engines (_count, offset int) ?[]Engine
fn fetch_engine (id string) ?Engine
fn fetch_gametypes () ?[]GameType
fn fetch_gametype (id string) ?GameType
fn search_game (name string) ?Game
fn search_user (name string) ?User
fn search_users (name string, _count, offset int) ?[]User
fn search_developer (name string) ?Developer
fn search_gametype (name string) ?GameType
fn (game Game) runs (count, offset int) ?[]Run
fn (game Game) categories () ?[]Category
fn (game Game) levels () ?[]Level
fn (user User) runs (_count, offset int) ?[]Run
fn (run Run) level () ?Level
fn (run Run) category () ?Category
fn (level Level) leaderboard (category_id string) ?Leaderboard
fn (category Category) leaderboard () ?Leaderboard
fn (lb Leaderboard) game () ?Game
fn (lb Leaderboard) category () ?Category
fn (lb Leaderboard) level () ?Level
fn (dev Developer) games () ?[]Game
fn (engine Engine) games (_count, offset int) ?[]Game
fn (gt GameType) games () ?[]Game
```
