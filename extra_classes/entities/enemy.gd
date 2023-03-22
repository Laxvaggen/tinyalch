class_name Enemy
extends PathfindingEntity

@export var base_vision_score: int
@export var base_hearing_score: int

var player: Entity
var spawn_position: Vector2

var attack_range_area: Area2D

#updates to player position if sees player
var last_known_player_location: Vector2

var alert_icon = preload("res://scenes/icons/alert_icon.tscn")
var hunt_icon = preload("res://scenes/icons/hunt_icon.tscn")

var status_bar_container

signal spotted_player
signal lost_player

func _enemy_init() -> void:
	spawn_position = global_position
	if has_node("AttackRange"):
		attack_range_area = $AttackRange
	else:
		push_error("enemyNoAttackRange")
	if has_node("StatusBars"):
		status_bar_container = $StatusBars

func _set_bars() -> void:
	if status_bar_container == null:
		return
	if status_bar_container.get_node("HealthBar"):
		status_bar_container.get_node("HealthBar").value = 100 * health/max_health
	if status_bar_container.get_node("AlertBar"):
		status_bar_container.get_node("AlertBar").value = 100 - 100 * get_sight_score_difference()/-0.5


func vision_obstruction_multiplier() -> int:
	if player == null:
		return 0
	# return 0 if not looking in direction of player
	if !looking_towards_player():
		return 0
	var raycast:RayCast2D = $PlayerTargeter
	raycast.target_position = Vector2(player.position + Vector2(0, 3))-position
	raycast.force_raycast_update()
	if raycast.get_collider() == player:
		return 1
	else:
		return 0

func get_distance_to_player() -> float:
	if player == null:
		return -1
	return (global_position-player.global_position).length()

func get_sight_score_difference() -> float:
	assert(player.get("visibility_score") != null)
	var actual_vision_score: float = base_vision_score * state_machine.state.state_vision_multiplier * vision_obstruction_multiplier() / (get_distance_to_player()/Globals.tile_size)
	var score: float = actual_vision_score - 1/player.visibility_score
	if score < -0.5:
		return -0.5
	return score

func get_noise_score_difference() -> float:
	assert(player.get("noise_score") != null)
	var actual_hearing_score: float = base_hearing_score * state_machine.state.state_hearing_multiplier / (get_distance_to_player()/Globals.tile_size)
	var score: float = actual_hearing_score - 1/player.noise_score
	if score < -0.5:
		return -0.5
	return score
 
func looking_towards_player() -> bool:
	if direction != Vector2(player.global_position.x - global_position.x, 0).normalized().x:
		return false
	return true

func player_in_attack_range() -> bool:
	if !attack_range_area:
		return false
	if attack_range_area.get_overlapping_bodies().has(player):
		return true
	return false

