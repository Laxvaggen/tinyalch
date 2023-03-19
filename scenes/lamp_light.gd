class_name Lamp
extends PointLight2D

var player: Player
var lightcone_length := 5 * Globals.tile_size

@onready var raycast := $RayCast2D

func _physics_process(_delta):
	_cast_to_player()
func _cast_to_player() -> void:
	if player == null:
		return
	raycast.target_position = to_local(player.global_position)

func player_is_in_lightcone() -> bool:
	if !raycast.get_collider() is Player:
		return false
	if Vector2(raycast.target_position).length()*scale.x > lightcone_length:
		return false
	return true
