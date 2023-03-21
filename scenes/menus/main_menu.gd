extends Control

var audio_pressed_icon = load("res://sprites/ui/UI - Icons18disabled.png")
var audio_icon = load("res://sprites/ui/UI - Icons18.png")

func _ready():
	if SceneManager.completed_levels_data.size() > 0:
		$AllButtonsContainer/MainButtonsContainer/Continue.disabled = false
		$AllButtonsContainer/MainButtonsContainer/LevelSelect.disabled = false
	else:
		$AllButtonsContainer/MainButtonsContainer/Continue.disabled = true
		$AllButtonsContainer/MainButtonsContainer/LevelSelect.disabled = true
	
	if SceneManager.all_levels_completed():
		$AllButtonsContainer/MainButtonsContainer/Continue.disabled = true

func _on_continue_pressed():
	SceneManager.start_next_level()


func _on_new_game_pressed():
	if SceneManager.completed_levels_data.size() > 0:
		SceneManager.enter_new_game_warning()
	else:
		SceneManager.start_new_game()


func _on_level_select_pressed():
	SceneManager.enter_level_select()


func _on_quit_pressed():
	get_tree().quit()


func _on_controls_pressed():
	SceneManager.enter_controls()


func _on_audio_toggled(button_pressed):
	if button_pressed:
		$AllButtonsContainer/ExtraButtonsContainer/Audio.set_button_icon(audio_pressed_icon)
	else:
		$AllButtonsContainer/ExtraButtonsContainer/Audio.set_button_icon(audio_icon)
