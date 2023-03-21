extends Control



func _on_back_button_pressed():
	SceneManager.enter_main_menu()


func _on_continue_button_pressed():
	SceneManager.start_new_game()
