extends Enemy

func _reposition_after_attack() -> void:
	global_position.x += 25*direction
