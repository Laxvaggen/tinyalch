extends AnimatedSprite2D



func _ready():
	play("default")

func _on_animation_finished():
	await get_tree().create_timer(1.62).timeout
	queue_free()
