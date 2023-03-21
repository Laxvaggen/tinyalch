extends AnimatedSprite2D

func _ready():
	visible = false

func _on_animation_finished():
	visible = false
