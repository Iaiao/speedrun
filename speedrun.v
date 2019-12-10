module speedrun

import time
import json
import http

const (
	GAME_URL = "https://www.speedrun.com/api/v1/games/{id}"
	GAMES_URL = "https://www.speedrun.com/api/v1/games?offset={offset}&max={max}"
	GAME_ABB_URL = "https://www.speedrun.com/api/v1/games?abbreviation={abbr}"
	GAME_RUNS_URL = "https://www.speedrun.com/api/v1/runs?game={game}&offset={offset}&max={max}"
	USER_RUNS_URL = "https://www.speedrun.com/api/v1/runs?user={id}&offset={offset}&max={max}"
	USER_URL = "https://www.speedrun.com/api/v1/users/{id}"
	USER_NAME_URL = "https://www.speedrun.com/api/v1/users?name={name}&offset={offset}&max={max}"
	RUN_URL = "https://www.speedrun.com/api/v1/runs/{id}"
	CATEGORY_URL = "https://www.speedrun.com/api/v1/categories/{id}"
	LEVEL_URL = "https://www.speedrun.com/api/v1/levels/{id}"
	LEADERBOARD_LEVEL_URL = "https://www.speedrun.com/api/v1/leaderboards/{game}/level/{level}/{category}"
	LEADERBOARD_CATEGORY_URL = "https://www.speedrun.com/api/v1/leaderboards/{game}/category/{category}"
	CATEGORIES_URL = "https://www.speedrun.com/api/v1/games/{id}/categories"
	LEVELS_URL = "https://www.speedrun.com/api/v1/games/{id}/levels"
	DEVELOPERS_URL = "https://www.speedrun.com/api/v1/developers?offset={offset}&max={max}"
	DEVELOPER_URL = "https://www.speedrun.com/api/v1/developers/{id}"
	DEVELOPER_GAMES_URL = "https://www.speedrun.com/api/v1/games?developer={id}&max=200"
	// One developer can't make > 200 speedrunnable games, right?
	ENGINES_URL = "https://www.speedrun.com/api/v1/engines?offset={offset}&max={max}"
	ENGINE_URL = "https://www.speedrun.com/api/v1/engines/{id}"
	ENGINE_GAMES_URL = "https://www.speedrun.com/api/v1/games?engine={id}&offset={offset}&max={max}"
	// There are only 11 game types, no need to use {max} and {offset}
	GAMETYPES_URL = "https://www.speedrun.com/api/v1/gametypes?max=200"
	GAMETYPE_URL = "https://www.speedrun.com/api/v1/gametypes/{id}"
	GAMETYPE_GAMES_URL = "https://www.speedrun.com/api/v1/games?gametype={id}&offset={offset}&max={max}"
	// TODO
	GENRES_URL = "https://www.speedrun.com/api/v1/genres?offset={offset}&max={max}"
	GENRE_URL = "https://www.speedrun.com/api/v1/genres/qdnqyk28"
	GENRE_GAMES_URL = "https://www.speedrun.com/api/v1/games?genre=qdnqyk28&offset={offset}&max={max}"
	GUEST_URL = "https://www.speedrun.com/api/v1/guests/{name}"
	PLATFORMS_URL = "https://www.speedrun.com/api/v1/platforms"
	PLATFORM_URL = "https://www.speedrun.com/api/v1/platforms/{id}"
	PLATFORM_GAMES_URL = "https://www.speedrun.com/api/v1/games?platform={id}&offset={offset}&max={max}"
	PLATFORM_RUNS_URL = "https://www.speedrun.com/api/v1/runs?platform={id}&offset={offset}&max={max}"
	PUBLISHERS_URL = "https://www.speedrun.com/api/v1/publishers?offset={offset}&max={max}"
	PUBLISHER_URL = "https://www.speedrun.com/api/v1/publishers/{id}"
	PUBLISHER_GAMES_URL = "https://www.speedrun.com/api/v1/games?publisher={id}&offset={offset}&max={max}"
	REGIONS_URL = "https://www.speedrun.com/api/v1/regionsoffset={offset}&max={max}"
	REGION_URL = "https://www.speedrun.com/api/v1/regions/{id}"
	REGION_GAMES_URL = "https://www.speedrun.com/api/v1/games?region={id}&offset={offset}&max={max}"
	REGION_RUNS_URL = "https://www.speedrun.com/api/v1/runs?region={id}&offset={offset}&max={max}"
	ALL_SERIES_URL = "https://www.speedrun.com/api/v1/series?offset={offset}&max={max}"
	SERIES_URL = "https://www.speedrun.com/api/v1/series/{id}"
	SERIES_GAMES_URL = "https://www.speedrun.com/api/v1/series/{id}/games&offset={offset}&max={max}"
	VARIABLE_URL = "https://www.speedrun.com/api/v1/variables/{id}"
)

struct SpeedrunResponse {
	status int
	data string [raw]
}

pub struct Run {
	_date string [json:'date']
	_submitted string [json:'submitted']
pub:
	id string
	links []Link
	videos Videos
	comment string
	splits Link
	times Times
	game_id string [json:'game']
	level_id string [json:'level']
	category_id string [json:'category']
	players []ID
mut:
	status VerifyStatus
	date time.Time
	submitted time.Time
}

pub struct Times {
pub:
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
pub:
	platform string
	emulated bool
	region string
}

pub struct Link {
pub:
	rel string
	uri string
}

pub struct ID {
pub:
	rel string
	id string
}

pub struct Videos {
pub:
	links []string
}

pub struct VerifyStatus {
	_verify_date string [json:'verify-date']
pub:
	status string
	examiner string
mut:
	verified bool
	verify_date time.Time
}

pub struct Game {
pub:
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
	/*
	 * Option size temporary limit is 300
	 * `assets` make `Game` weight 432
	 *
	 * assets Assets
	 */
	_created string [json:'created']
	_release_date string [json:'release-date']
mut:
	release_date time.Time
	created time.Time
}

// struct Assets {
// pub:
//  logo         Asset
//  cover_tiny   Asset [json:'cover-tiny']
//  cover_small  Asset [json:'cover-small']
//  cover_medium Asset [json:'cover-medium']
//  cover_large  Asset [json:'cover-large']
//  icon         Asset
//  trophy_1th   Asset [json:'trophy-1th']
//  trophy_2nd   Asset [json:'trophy-2nd']
//  trophy_3rd   Asset [json:'trophy-3rd']
//  trophy_4th   Asset [json:'trophy-4th']
// }

// struct Asset {
// pub:
//   uri string
//   width int
//   height int
// }

pub struct RuleSet {
pub:
	show_milliseconds bool [json:'show-milliseconds']
	require_verification bool [json:'require-verification']
	require_video bool [json:'require-video']
	run_times []string [json:'run-times']
	default_time string [json:'default-time']
	emulators_allowed bool [json:'emulators-allowed']
}

pub struct Names {
pub:
	international string
	japanese string
	twitch string
}

pub struct Level {
pub:
	id string
	name string
	rules string
	links []Link
}

pub struct Category {
pub:
	id string
	name string
	category_type string [json:'type']
	rules string
	players PlayerRule
	miscellaneous bool
	links []Link
}

pub struct Leaderboard {
pub:
	game_id string [json:'game']
	category_id string [json:'category']
	level_id string [json:'level']
	platform string
	region string
	emulators []string
	video_only bool [json:'video-only']
	timing string
	links []Link
	runs []Place
}

pub struct Place {
pub:
	place int
	run Run
}

pub struct PlayerRule {
pub:
	category_type string [json:'type']
	value int
}

pub struct User {
	_signup string [json:'signup']
pub:
	id string
	names Names
	name_style NameStyle [json:'name-style']
	role string
	location Location
mut:
	signup time.Time
}

pub struct Location {
pub:
	country Country
}

pub struct Country {
pub:
	code string
	names Names
}

pub struct NameStyle {
pub:
	style string
	color_from Color [json:'color-from']
	color_to Color [json:'color-to']
}

pub struct Color {
pub:
	light string
	dark string
}

pub struct Developer {
pub:
	id string
	name string
	links []Link
}

pub struct Engine {
pub:
	id string
	name string
	links []Link
}

pub struct GameType {
pub:
	id string
	name string
	allows_base_game string [json:'allows-base-game']
	links []Link
}

pub fn fetch_games(_count, offset int) ?[]Game {
	mut games := []Game
	mut count := _count
	if count == 0 {
		return games
	}
	if count < 0 {
		count = 0xFFFFFF
	}

	url := GAMES_URL
		.replace("{max}", count.str())
		.replace("{offset}", offset.str())

	res := get(url) or {
		return error(err)
	}
	response := json.decode([]Game, res) or {
		return error(err)
	}

	games << response

	if response.len < 200 {
		return games
	}

	next := fetch_games(count - 200, offset + 200) or {
		return error(err)
	}

	games << next

	return games
}

pub fn fetch_game(id string) ?Game {
	url := GAME_URL
		.replace("{id}", id)

	res := get(url) or {
		return error(err)
	}
	response := json.decode(Game, res) or {
		return error(err)
	}

	return process_game(response)
}

pub fn fetch_leaderboard_category(game_id, category_id string) ?Leaderboard {
	url := LEADERBOARD_CATEGORY_URL
		.replace("{game}", game_id)
		.replace("{category}", category_id)

	res := get(url) or {
		return error(err)
	}
	response := json.decode(Leaderboard, res)

	return response
}

pub fn fetch_leaderboard_level(game_id, category_id, level_id string) ?Leaderboard {
	url := LEADERBOARD_LEVEL_URL
		.replace("{game}", game_id)
		.replace("{level}", level_id)
		.replace("{category}", category_id)

	res := get(url) or {
		return error(err)
	}
	response := json.decode(Leaderboard, res)

	return response
}

pub fn fetch_user(id string) ?User {
	url := USER_URL
		.replace("{id}", id)

	res := get(url) or {
		return error(err)
	}
	response := json.decode(User, res) or {
		return error(err)
	}
	return process_user(response)
}

pub fn fetch_run(id string) ?Run {
	url := RUN_URL
		.replace("{id}", id)

	res := get(url) or {
		return error(err)
	}
	response := json.decode(Run, res) or {
		return error(err)
	}

	return process_run(response)
}

pub fn fetch_runs(game_id string, _count, offset int) ?[]Run {
	mut count := _count
	if count < 0 {
		count = 0xFFFFFF
	}
	mut runs := []Run
	url := GAME_RUNS_URL
		.replace("{game}", game_id)
		.replace("{max}", count.str())
		.replace("{offset}", offset.str())

	res := get(url) or {
		return error(err)
	}
	response := json.decode([]Run, res) or {
		return error(err)
	}

	for run in response {
		runs << process_run(run)
	}
	if response.len < 200 {
		return runs
	}

	next := fetch_runs(game_id, count - 200, offset + 200) or {
		return error(err)
	}
	runs << next

	return runs
}

pub fn fetch_category(category_id string) ?Category {
	url := CATEGORY_URL
		.replace("{id}", category_id)

	res := get(url) or {
		return error(err)
	}
	response := json.decode(Category, res) or {
		return error(err)
	}
	if response.id == "" {
		return none
	}

	return response
}

pub fn fetch_level(level_id string) ?Level {
	url := LEVEL_URL
		.replace("{id}", level_id)

	res := get(url) or {
		return error(err)
	}
	response := json.decode(Level, res) or {
		return error(err)
	}
	if response.id == "" {
		return none
	}

	return response
}

pub fn fetch_developers(_count, offset int) ?[]Developer {
	mut devs := []Developer
	mut count := _count
	if count == 0 {
		return devs
	}
	if count < 0 {
		count = 0xFFFFFF
	}

	url := DEVELOPERS_URL
		.replace("{max}", count.str())
		.replace("{offset}", offset.str())

	res := get(url) or {
		return error(err)
	}
	response := json.decode([]Developer, res) or {
		return error(err)
	}

	devs << response

	if response.len < 200 {
		return devs
	}

	next := fetch_developers(count - 200, offset + 200) or {
		return error(err)
	}

	devs << next

	return devs
}

pub fn fetch_developer(id string) ?Developer {
	url := DEVELOPER_URL
		.replace("{id}", id)

	res := get(url) or {
		return error(err)
	}
	response := json.decode(Developer, res) or {
		return error(err)
	}

	return response
}

pub fn fetch_engines(_count, offset int) ?[]Engine {
	mut engines := []Engine
	mut count := _count
	if count == 0 {
		return engines
	}
	if count < 0 {
		count = 0xFFFFFF
	}

	url := ENGINES_URL
		.replace("{max}", count.str())
		.replace("{offset}", offset.str())

	res := get(url) or {
		return error(err)
	}
	response := json.decode([]Engine, res) or {
		return error(err)
	}

	engines << response

	if response.len < 200 {
		return engines
	}

	next := fetch_engines(count - 200, offset + 200) or {
		return error(err)
	}

	engines << next

	return engines
}

pub fn fetch_engine(id string) ?Engine {
	url := ENGINE_URL
		.replace("{id}", id)

	res := get(url) or {
		return error(err)
	}
	response := json.decode(Engine, res) or {
		return error(err)
	}

	return response
}

pub fn fetch_gametypes() ?[]GameType {
	url := GAMETYPES_URL

	res := get(url) or {
		return error(err)
	}
	response := json.decode([]GameType, res) or {
		return error(err)
	}

	return response
}

pub fn fetch_gametype(id string) ?GameType {
	url := GAMETYPE_URL
		.replace("{id}", id)

	res := get(url) or {
		return error(err)
	}
	response := json.decode(GameType, res) or {
		return error(err)
	}

	return response
}

pub fn search_game(name string) ?Game {
	url := GAME_ABB_URL
		.replace("{abbr}", name)

	res := get(url) or {
		return error(err)
	}
	response := json.decode([]Game, res) or {
		return error(err)
	}
	if response.len == 0 {
		return error("Error: $name not found")
	}

	return process_game(response[0])
}

pub fn search_user(name string) ?User {
	mut offset := 0
	for {
		users := search_users(name, 200, offset) or {
			return error(err)
		}

		for user in users {
			if user.names.international.to_upper() == name.to_upper() {
				return process_user(user)
			}
		}

		if users.len < 200 {
			return error("User $name not found")
		}
		offset += 200
	}
	return error("User $name not found")
}

pub fn search_users(name string, _count, offset int) ?[]User {
	mut users := []User
	mut count := _count
	if count == 0 {
		return users
	}
	if count < 0 {
		count = 0xFFFFFF
	}

	url := USER_NAME_URL
		.replace("{name}", name)
		.replace("{max}", count.str())
		.replace("{offset}", offset.str())

	res := get(url) or {
		return error(err)
	}
	response := json.decode([]User, res) or {
		return error(err)
	}

	for user in response {
		users << process_user(user)
	}
	if response.len < 200 {
		return users
	}

	next := search_users(name, count - 200, offset + 200) or {
		return error(err)
	}

	users << next

	return users
}

pub fn search_developer(name string) ?Developer {
	mut offset := 0
	for {
		devs := fetch_developers(200, offset) or {
			return error(err)
		}

		for dev in devs {
			if dev.name.to_upper() == name.to_upper() {
				return dev
			}
		}

		if devs.len < 200 {
			return error("Developer $name not found")
		}
		
		offset += 200
	}
	return error("Developer $name not found")
}

pub fn search_gametype(name string) ?GameType {
	gts := fetch_gametypes() or {
		return error(err)
	}

	for gt in gts {
		if gt.name.to_upper() == name.to_upper() {
			return gt
		}
	}

	return error("Gametype $name not found")
}

pub fn (game Game) runs(count, offset int) ?[]Run {
	return fetch_runs(game.id, count, offset)
}

pub fn (game Game) categories() ?[]Category {
	url := CATEGORIES_URL
		.replace("{id}", game.id)

	res := get(url) or {
		return error(err)
	}
	response := json.decode([]Category, res) or {
		return error(err)
	}

	return response
}

pub fn (game Game) levels() ?[]Level {
	url := LEVELS_URL
		.replace("{id}", game.id)

	res := get(url) or {
		return error(err)
	}
	response := json.decode([]Level, res) or {
		return error(err)
	}
	return response
}

pub fn (user User) runs(_count, offset int) ?[]Run {
	mut runs := []Run
	mut count := _count
	if count == 0 {
		return runs
	}
	if count < 0 {
		count = 0xFFFFFF
	}
	url := USER_RUNS_URL
		.replace("{id}", user.id)
		.replace("{max}", count.str())
		.replace("{offset}", offset.str())

	res := get(url) or {
		return error(err)
	}
	response := json.decode([]Run, res) or {
		return error(err)
	}

	for run in response {
		runs << process_run(run)
	}

	if response.len < 200 {
		return runs
	}

	next := user.runs(count - 200, offset + 200) or {
		return error(err)
	}
	runs << next

	return runs
}

pub fn (run Run) level() ?Level {
	level := fetch_level(run.level_id) or {
		return error(err)
	}
	return level
}

pub fn (run Run) category() ?Category {
	category := fetch_category(run.category_id) or {
		return error(err)
	}
	return category
}

pub fn (level Level) leaderboard(category_id string) ?Leaderboard {
	mut game_id := ""
	for link in level.links {
		if link.rel == "game" {
			game_id = link.uri[38..]
			break
		}
	}
	leaderboard := fetch_leaderboard_level(game_id, category_id, level.id) or {
		return error(err)
	}
	return leaderboard
}

pub fn (category Category) leaderboard() ?Leaderboard {
	mut game_id := ""
	for link in category.links {
		if link.rel == "game" {
			game_id = link.uri[38..]
			break
		}
	}
	leaderboard := fetch_leaderboard_category(game_id, category.id) or {
		return error(err)
	}
	return leaderboard
}

pub fn (lb Leaderboard) game() ?Game {
	game := fetch_game(lb.game_id) or {
		return error(err)
	}
	return game
}

pub fn (lb Leaderboard) category() ?Category {
	category := fetch_category(lb.category_id) or {
		return error(err)
	}
	return category
}

pub fn (lb Leaderboard) level() ?Level {
	level := fetch_level(lb.level_id) or {
		return error(err)
	}
	return level
}

pub fn (dev Developer) games() ?[]Game {
	url := DEVELOPER_GAMES_URL
		.replace("{id}", dev.id)

	res := get(url) or {
		return error(err)
	}
	response := json.decode([]Game, res) or {
		return error(err)
	}

	return response
}

pub fn (engine Engine) games(_count, offset int) ?[]Game {
	mut games := []Game
	mut count := _count
	if count == 0 {
		return games
	}
	if count < 0 {
		count = 0xFFFFFF
	}

	url := ENGINE_GAMES_URL
		.replace("{id}", engine.id)
		.replace("{max}", count.str())
		.replace("{offset}", offset.str())

	res := get(url) or {
		return error(err)
	}
	response := json.decode([]Game, res) or {
		return error(err)
	}

	games << response

	if response.len < 200 {
		return games
	}

	next := engine.games(count - 200, offset + 200) or {
		return error(err)
	}

	games << next

	return games
}

pub fn (gt GameType) games() ?[]Game {
	url := GAMETYPE_GAMES_URL

	res := get(url) or {
		return error(err)
	}
	response := json.decode([]Game, res) or {
		return error(err)
	}

	return response
}


fn get(url string) ?string {
	res := http.get(url) or {
		return error(err)
	}
	if res.status_code != 200 {
		return error("Error: Got response code $res.status_code: $res.text")
	}
	response := json.decode(SpeedrunResponse, res.text) or {
		return error(err)
	}
	if response.status != 0 {
		return error("Error: Got response code $response.status: $res.text")
	}
	return response.data
}

fn process_game(_game Game) Game {
	mut game := _game
	game.created = time.parse(
		game._created
			.replace("T", " ")
			.replace("Z", "")
	)
	game.release_date = time.parse(game._release_date + " 00:00:00")
	return game
}

fn process_user(_user User) User {
	mut user := _user
	user.signup = time.parse(
		user._signup
			.replace("T", " ")
			.replace("Z", "")
	)
	return user
}

fn process_run(_run Run) Run {
	mut run := _run
	if run._date != "" {
		run.date = time.parse(run._date + " 00:00:00")
	} else {
		run.date = time.unix(0)
	}
	if run.status._verify_date != "" {
		run.status.verify_date = time.parse(
			run.status._verify_date
				.replace("T", " ")
				.replace("Z", "")
		)
	} else {
		run.status.verify_date = time.unix(0)
	}
	if run._submitted != "" {
		run.submitted = time.parse(
			run._submitted
				.replace("T", " ")
				.replace("Z", "")
		)
	} else {
		run.submitted = time.unix(0)
	}
	if run.status.status == "verified" {
		run.status.verified = true
	}
	return run
}
