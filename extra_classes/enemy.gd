class_name Enemy
extends Entity

var player: Entity
var spawn_position: Vector2

func _ready() -> void:
	spawn_position = global_position

func vision_of_player_obstructed() -> bool:
	if player == null:
		return false
	var raycast:RayCast2D = $PlayerTargeter
	raycast.target_position = player.position-position
	raycast.force_raycast_update()
	if raycast.get_collider() == player:
		return true
	else:
		return false
