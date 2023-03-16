class_name Enemy
extends PathfindingEntity

@export var base_vision_score: int
@export var base_hearing_score: int

var player: Entity
var spawn_position: Vector2

#updates to player position if sees player
var target_position: Vector2

func _ready() -> void:
	spawn_position = global_position

func vision_obstruction_multiplier() -> int:
	if player == null:
		return 0
	# return 0 if not looking in direction of player
	if direction != Vector2(player.global_position.x - global_position.x, 0).normalized().x:
		return 0
	var raycast:RayCast2D = $PlayerTargeter
	raycast.target_position = player.position-position
	raycast.force_raycast_update()
	if raycast.get_collider() == player:
		return 1
	else:
		return 0

func get_distance_to_player() -> float:
	if player == null:
		return -1
	return (global_position-player.global_position).length()

# get the difference between vision score & player visibility score
func get_vision_difference():
	assert(player.has("visibility_score"))
	var actual_vision_score: float = base_vision_score * vision_obstruction_multiplier() / get_distance_to_player()
	return actual_vision_score - player.visibility_score

# get difference between hearing score & player noise score
func get_noise_difference():
	assert(player.has("noise_score"))
	var actual_hearing_score: float = base_hearing_score / get_distance_to_player()
	return actual_hearing_score - player.noise_score
