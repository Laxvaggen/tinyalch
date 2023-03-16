extends Node2D


#Reference variable for item in levels array
var level_example = {"filepath":"res://...",
				"name":""}

var levels: Array
var completed_levels_data: Dictionary
var current_level_index: int

var main_menu_ref = "res://scenes/menus/main_menu.tscn"
var level_cleared_menu_ref = "res://scenes/menus/level_cleared_menu.tscn"
var level_failed_menu_ref = "res://scenes/menus/level_failed_menu.tscn"
var controls_menu_ref = "res://scenes/menus/controls_menu.tscn"
var level_select_menu_ref = "res://scenes/menus/level_select_menu.tscn"
var game_complete_menu_ref = "res://scenes/menus/game_complete_menu.tscn"
var pause_menu_ref = "res://scenes/menus/pause_menu.tscn"

var transition_scene

func _ready() -> void:
	if has_node("Transition"):
		transition_scene = $Transition
	else:
		push_error("noTransitionScene")
	#import_savedata()
	current_level_index = completed_levels_data.size() -1

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause") and get_tree().current_scene.is_in_group("Levels"):
		var pause_menu_instance = pause_menu_ref.instantiate()
		get_tree().get_root().add_child(pause_menu_instance)

#Transitions smoothly to scene
func load_scene(scenepath: String, _in_game = false):
	if transition_scene != null:
		transition_scene.visible = true
		transition_scene.get_node("AnimationPlayer").play("fade_in")
		await transition_scene.animation_player.animation_finished
		get_tree().change_scene_to_file(scenepath)
		transition_scene.animation_player.get_node("AnimationPlayer").play_backwards("fade_in")
		await transition_scene.animation_player.animation_finished
		transition_scene.visible = false
	else:
		get_tree().change_scene_to_file(scenepath)

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

func start_new_game() -> void:
	current_level_index = 0
	completed_levels_data = {}
	export_savedata()
	load_scene(levels[0]["filepath"], true)

func start_level(index) -> void:
	load_scene(levels[index]["filepath"], true)

func resume_game() -> void:
	get_tree().paused = false

func enter_main_menu() -> void:
	load_scene(main_menu_ref)

func restart_level() -> void:
	load_scene(levels[current_level_index]["filepath"], true)

func level_cleared(stats: Dictionary) -> void:
	var level = levels[current_level_index]
	stats["time"] = round(stats["time"]*10)/10
	if !completed_levels_data.has(level["name"]):
		completed_levels_data[level["name"]] = stats
	elif completed_levels_data[level["name"]]["time"] > stats["time"]:
		completed_levels_data[level["name"]] = stats
	load_scene(level_cleared_menu_ref)
	export_savedata()

func level_failed(_stats: Dictionary) -> void:
	load_scene(level_failed_menu_ref)

func enter_controls() -> void:
	load_scene(controls_menu_ref)

func enter_level_select() -> void:
	load_scene(level_select_menu_ref)
