extends Node2D


#Reference variable for item in levels array
var level_example = {"filepath":"res://...",
				"name":""}

var level_1 = {"filepath":"res://scenes/levels/level_1.tscn",
				"name":"Tutorial part 1"}
var level_2 = {"filepath":"res://scenes/levels/level_2.tscn",
				"name":"Tutorial part 2"}
var level_3 = {"filepath": "res://scenes/levels/level_3.tscn",
				"name": "Tutorial part 3"}
var level_4 = {"filepath": "res://scenes/levels/level_4.tscn",
				"name": "Entrance"}
var level_5 = {"filepath": "res://scenes/levels/level_5.tscn",
				"name": "Descent"}
var level_6 = {"filepath":"res://scenes/levels/level_6.tscn",
				"name":"Tunnels"}


var levels: Array = [level_1, level_2, level_3, level_4, level_5]
var completed_levels_data: Dictionary
var current_level_index: int

var in_game := false

var main_menu_ref = "res://scenes/menus/main_menu.tscn"
var level_progress_menu_ref = "res://scenes/menus/level_progress_menu.tscn"
var controls_menu_ref = "res://scenes/menus/controls_menu.tscn"
var level_select_menu_ref = "res://scenes/menus/level_select_menu.tscn"
var game_complete_menu_ref = "res://scenes/menus/game_complete_menu.tscn"
var new_game_warning_ref = "res://scenes/menus/new_game_warning.tscn"


var pause_menu
var transition_scene

signal entered_level_progress_menu

func _ready() -> void:
	if has_node("Transition"):
		transition_scene = $Transition
		transition_scene.visible = false
	else:
		push_error("noTransitionScene")
	if has_node("PauseMenu/Control"):
		pause_menu = $PauseMenu/Control
		pause_menu.deactivate()
	import_savedata()
	current_level_index = completed_levels_data.size() -1
	MusicPlayer.switch_state(MusicPlayer.MAIN_MENU)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause") and in_game:
		pause_menu.call_deferred("activate")
	if get_tree().current_scene.name == "LevelProgressMenu":
		emit_signal("entered_level_progress_menu")

#Transitions smoothly to scene
func load_scene(scenepath: String, entering_game = false):
	if transition_scene != null:
		transition_scene.visible = true
		transition_scene.get_node("AnimationPlayer").play("fade_in")
		await transition_scene.get_node("AnimationPlayer").animation_finished
		get_tree().change_scene_to_file(scenepath)
		transition_scene.get_node("AnimationPlayer").play_backwards("fade_in")
		await transition_scene.get_node("AnimationPlayer").animation_finished
		transition_scene.visible = false
	else:
		get_tree().change_scene_to_file(scenepath)
	if entering_game:
		in_game = true
	else:
		in_game = false

#Exports save to file
func export_savedata() -> void:
	var save_data = completed_levels_data
	var file = FileAccess.open("user://save_data.json", FileAccess.WRITE)
	file.store_line(JSON.stringify(save_data))
	file.close()

#Imports save from file
func import_savedata() -> void:
	if not FileAccess.file_exists("user://save_data.json"):
		export_savedata()
		return
	var file = FileAccess.open("user://save_data.json", FileAccess.READ)
	var json_conv = JSON.new()
	json_conv.parse(file.get_as_text())
	var save_data = json_conv.get_data()
	completed_levels_data = save_data

func all_levels_completed() -> bool:
	if completed_levels_data.size() == levels.size():
		return true
	else:
		return false


func start_next_level() -> void:
	if current_level_index >= levels.size()-1:
		if all_levels_completed():
			load_scene(game_complete_menu_ref)
			return
		enter_main_menu()
		return
	current_level_index += 1
	load_scene(levels[current_level_index]["filepath"], true)
	MusicPlayer.switch_state(MusicPlayer.INGAME)

func start_new_game() -> void:
	current_level_index = 0
	completed_levels_data = {}
	export_savedata()
	load_scene(levels[0]["filepath"], true)
	MusicPlayer.switch_state(MusicPlayer.INGAME)

func enter_new_game_warning() -> void:
	load_scene(new_game_warning_ref)

func start_level(index) -> void:
	current_level_index = index
	load_scene(levels[index]["filepath"], true)
	MusicPlayer.switch_state(MusicPlayer.INGAME)

func resume_game() -> void:
	pause_menu.deactivate()

func enter_main_menu() -> void:
	load_scene(main_menu_ref)
	MusicPlayer.switch_state(MusicPlayer.MAIN_MENU)

func restart_level() -> void:
	load_scene(levels[current_level_index]["filepath"], true)
	MusicPlayer.switch_state(MusicPlayer.INGAME)

func level_cleared(stats: Dictionary) -> void:
	var level = levels[current_level_index]
	stats["time"] = round(stats["time"]*10)/10
	if !completed_levels_data.has(level["name"]):
		completed_levels_data[level["name"]] = stats
	elif completed_levels_data[level["name"]]["time"] > stats["time"]:
		completed_levels_data[level["name"]] = stats
	load_scene(level_progress_menu_ref)
	export_savedata()
	await entered_level_progress_menu
	get_tree().current_scene.update_data(stats, true)
	MusicPlayer.switch_state(MusicPlayer.LEVEL_COMPLETE)

func level_failed(stats: Dictionary) -> void:
	load_scene(level_progress_menu_ref)
	await entered_level_progress_menu
	get_tree().current_scene.update_data(stats, false)
	MusicPlayer.switch_state(MusicPlayer.LEVEL_FAILED)

func enter_controls() -> void:
	load_scene(controls_menu_ref)

func enter_level_select() -> void:
	load_scene(level_select_menu_ref)
