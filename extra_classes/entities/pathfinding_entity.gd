class_name PathfindingEntity
extends Entity

var current_path: Array
var current_target

var padding = 1
var target_padding = 5

var path_finder

func _pathfinder_ready():
	if find_parent("World").has_node("Pathfinder"):
		path_finder = find_parent("World").get_node("Pathfinder")
	else:
		push_error("PathfindingEntityNoPathFinder")

func _next_target():
	if len(current_path) == 0:
		current_target = null
		return
	current_target = current_path.pop_front()
	if current_target == null and current_path != []:
		if is_on_floor():
			jump()
		_next_target()

func pathfinder_set_target(pos: Vector2) -> void:
	await get_tree().process_frame
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(Vector2(pos.x, pos.y - 1), Vector2(pos.x, pos.y + 1000), 1)
	var result = space_state.intersect_ray(query)
	if result:
		var go_to = result["position"]
		current_path = path_finder.find_path(self.position, go_to)
		current_path.append(go_to)
		_next_target()

func pathfinder_flush_points() -> void:
	current_path = []

func pathfinder_get_move_direction() -> int:
	var return_value := 3
	if current_target:
		if current_target.x - padding > global_position.x:
			return_value = 1
		elif current_target.x + padding < global_position.x:
			return_value = -1
		else:
			return_value = 0
		if position.distance_to(current_target) < target_padding and is_on_floor():
			_next_target()
	else:
		return_value = 0
	return return_value


func pathfind(move_speed_multiplier:float=1):
	var move_direction = pathfinder_get_move_direction()
	velocity = Vector2(move_speed*move_direction*move_speed_multiplier, velocity.y)
	if abs(move_direction) == 1:
		set_node_direction(move_direction)
