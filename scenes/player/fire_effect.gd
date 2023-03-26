extends AnimatedSprite2D

var sfx_player = preload("res://scenes/sfx_player.tscn")

func _ready():
	play("default")
	await get_tree().create_timer(0.05).timeout
	play_sound_effect(load("res://sound/Retro Impact LoFi 09.wav"))


func play_sound_effect(sound: AudioStream) -> void:
	var sound_player = sfx_player.instantiate()
	sound_player.stream = sound
	add_child(sound_player)

func _on_animation_finished():
	await get_tree().create_timer(1.62).timeout
	queue_free()
