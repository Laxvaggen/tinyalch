extends Control

func _on_continue_pressed():
	SceneManager.start_next_level()


func _on_new_game_pressed():
	SceneManager.start_new_game()


func _on_level_select_pressed():
	SceneManager.enter_level_select()


func _on_quit_pressed():
	get_tree().quit()


func _on_controls_pressed():
	pass # Replace with function body.


func _on_audio_pressed():
	pass # Replace with function body.
