extends Node2D

signal exit_reached

func _ready():
	exit_reached.connect(Callable(get_node("/root/World"), "level_cleared"))
	$AnimationPlayer.play("float")

func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		exit_reached.emit()
