extends Control

var selectable_levels: Array

var level_index := 0
var max_index: int

func _ready() -> void:
	for level in SceneManager.levels:
		if SceneManager.completed_levels_data.has(level["name"]):
			selectable_levels.append(level)
	max_index = selectable_levels.size() - 1
	_load_level_data()

func _load_level_data() -> void:
	var level = selectable_levels[level_index]
	var stats = SceneManager.completed_levels_data[level["name"]]
	var label_container = $LevelSelectorContainer/DataContainer/MarginContainer/VBoxContainer
	label_container.get_node("Kills").text = "Kills" + str(stats["kills"])
	label_container.get_node("DamageTaken").text = "Damage Taken" + str(stats["damage taken"])
	label_container.get_node("Time").text = "Time" + str(stats["time"])
	label_container.get_node("TimesDetected").text = "Times Detected" + str(stats["times_detected"])
	$LevelName.text = level["name"]


func _on_previous_level_pressed():
	level_index -= 1
	if level_index < 0:
		level_index = max_index
	_load_level_data()


func _on_enter_level_pressed():
	SceneManager.start_level(SceneManager.levels.find(selectable_levels[level_index]))


func _on_next_level_pressed():
	level_index += 1
	if level_index > max_index:
		level_index = 0
	_load_level_data()


func _on_back_pressed():
	SceneManager.enter_main_menu()
