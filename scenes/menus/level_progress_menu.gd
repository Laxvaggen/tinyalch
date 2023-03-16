extends Control

func update_data(stats: Dictionary, level_completed:bool) -> void:
	if !level_completed:
		$PanelContainer/HBoxContainer/ButtonsContainer/Continue.disabled = true
		$VBoxContainer/PanelContainer2/MarginContainer/LevelStatus.text = "You Died"
	else:
		$VBoxContainer/PanelContainer2/MarginContainer/LevelStatus.text = "Level Completed"
	var label_container = $PanelContainer/HBoxContainer/DataContainer/MarginContainer/VBoxContainer
	label_container.get_node("Kills").text = "Kills" + str(stats["kills"])
	label_container.get_node("DamageTaken").text = "Damage Taken" + str(stats["damage taken"])
	label_container.get_node("Time").text = "Time" + str(stats["time"])
	label_container.get_node("TimesDetected").text = "Times Detected" + str(stats["times_detected"])

func _on_continue_pressed():
	SceneManager.start_next_level()


func _on_restart_pressed():
	SceneManager.restart_level()


func _on_quit_pressed():
	SceneManager.enter_main_menu()
