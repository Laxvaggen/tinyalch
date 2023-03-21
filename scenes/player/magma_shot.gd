extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("default")
	await get_tree().create_timer(0.8).timeout
	$HitBox/CollisionShape2D.set_deferred("disabled", false)


func _on_animated_sprite_2d_animation_finished():
	queue_free()
