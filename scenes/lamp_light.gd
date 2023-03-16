class_name Lamp
extends PointLight2D

var player: Player

@onready var raycast := $RayCast2D

func _physics_process(delta):
	_cast_to_player()
func _cast_to_player() -> void:
	if player == null:
		return
	raycast.target_position = to_local(player.global_position)

func get_lightlevel_at_player() -> float:
	if !raycast.get_collider() is Player:
		return 0
	var raycast_distance = Vector2(global_position - raycast.get_collision_point()).length()
	var light_level = 1/raycast_distance**2 * (texture_scale / 0.01)

	return light_level
