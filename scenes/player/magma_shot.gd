extends Node2D


var sfx_player = preload("res://scenes/sfx_player.tscn")
var sound_effect = load("res://sound/Retro Explosion Short 15.wav")


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("default")
	await get_tree().create_timer(0.8).timeout
	$HitBox/CollisionShape2D.set_deferred("disabled", false)
	play_sound_effect(sound_effect)

func play_sound_effect(sound: AudioStream) -> void:
	var sound_player = sfx_player.instantiate()
	sound_player.stream = sound
	add_child(sound_player)


func _on_animated_sprite_2d_animation_finished():
	queue_free()
