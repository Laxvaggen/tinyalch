extends Control

func _process(delta):
	if Input.is_action_just_pressed("pause") and get_tree().paused:
		SceneManager.resume_game()

func deactivate() -> void:
	visible = false
	get_tree().paused = false
	for button in $VBoxContainer/PanelContainer/MarginContainer/ButtonsContainer.get_children():
		button.disabled = true
	
	
func activate() -> void:
	visible = true
	get_tree().paused = true
	for button in $VBoxContainer/PanelContainer/MarginContainer/ButtonsContainer.get_children():
		button.disabled = false
	


func _on_resume_pressed():
	SceneManager.resume_game()


func _on_restart_level_pressed():
	SceneManager.restart_level()


func _on_quit_pressed():
	SceneManager.enter_main_menu()

