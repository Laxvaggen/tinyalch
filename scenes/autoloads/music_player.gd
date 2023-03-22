extends AudioStreamPlayer

var main_menu_music = [
	load("res://music/menu/when_snow_become_ashes.ogg")
]
 
var level_complete_music = [
	load("res://music/level_complete/destiny.wav")
]

var level_failed_music = [
	load("res://music/level_failed/disciples.ogg")
]

var ingame_standard_music = [
	load("res://music/ingame_standard/Dark Quest.ogg"),
	load("res://music/ingame_standard/Full of memories.ogg"),
	load("res://music/ingame_standard/priorities_changing.wav")
]

var ingame_combat_music = [
	load("res://music/ingame_combat/conflict.ogg"),
	load("res://music/ingame_combat/confrontation.wav"),
	load("res://music/ingame_combat/Darkness March.ogg"),
	load("res://music/ingame_combat/gambit.wav")
]

enum {MAIN_MENU, LEVEL_COMPLETE, LEVEL_FAILED, INGAME, INGAME_COMBAT}

var state = MAIN_MENU

var volume: float= -20
var fadein_time: float = 4

func switch_state(new_state, custom_fadein_time := fadein_time, custom_volume := volume) -> void:
	state = new_state
	var tween = get_tree().create_tween()
	volume_db = -80
	tween.tween_property(self, "volume_db", custom_volume, custom_fadein_time)
	
	stream = _get_song()
	play()

func _get_song() -> AudioStream:
	var song: AudioStream
	match state:
		MAIN_MENU:
			song = main_menu_music.pick_random()
		LEVEL_COMPLETE:
			song = level_complete_music.pick_random()
		LEVEL_FAILED:
			song = level_failed_music.pick_random()
		INGAME:
			song = ingame_standard_music.pick_random()
		INGAME_COMBAT:
			song = ingame_combat_music.pick_random()
	return song


func _on_finished():
	stream = _get_song()
	play()
