extends Control


func _ready():
	get_tree().paused = true

func _on_resume_pressed():
	SceneManager.resume_game()


func _on_restart_level_pressed():
	SceneManager.restart_level()


func _on_quit_pressed():
	SceneManager.enter_main_menu()
