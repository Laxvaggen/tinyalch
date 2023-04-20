extends Control

var selectable_levels: Array

var level_index := 0
var max_index: int

func _ready() -> void:
	for level in SceneManager.levels:
		if SceneManager.completed_levels_data.has(level["name"]):
			selectable_levels.append(level)
	if !selectable_levels.size() == SceneManager.levels.size():
		selectable_levels.append(SceneManager.levels[selectable_levels.size()])
	max_index = selectable_levels.size() - 1
	_load_level_data()

func _load_level_data(level_completed:=true) -> void:
	# Update labels to correctly display level stats, no stats if level is not completed
	var level = selectable_levels[level_index]
	$LevelSelectorContainer/LevelName.text = level["name"]
	if !level_completed:
		$LevelSelectorContainer/DataContainer.visible = false
		return
	$LevelSelectorContainer/DataContainer.visible = true
	var stats = SceneManager.completed_levels_data[level["name"]]
	var label_container = $LevelSelectorContainer/DataContainer/MarginContainer/VBoxContainer
	label_container.get_node("Kills").text = "Kills: " + str(stats["kills"])
	label_container.get_node("DamageTaken").text = "Damage Taken: " + str(stats["damage_taken"])
	label_container.get_node("Time").text = "Time: " + str(round(100*stats["time"])/100)
	label_container.get_node("TimesDetected").text = "Times Detected: " + str(stats["times_detected"])


func _on_previous_level_pressed():
	level_index -= 1
	if level_index < 0:
		level_index = max_index
		_load_level_data(false)
		return
	_load_level_data()


func _on_enter_level_pressed():
	SceneManager.start_level(SceneManager.levels.find(selectable_levels[level_index]))


func _on_next_level_pressed():
	level_index += 1
	if level_index == max_index:
		_load_level_data(false)
		return
	if level_index > max_index:
		level_index = 0
	_load_level_data()


func _on_back_pressed():
	SceneManager.enter_main_menu()
