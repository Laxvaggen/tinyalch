class_name PathfindingEntity
extends Entity

var current_path: Array
var current_target

var padding = 1
var target_padding = 5

var path_finder: Pathfinder

func _ready() -> void:
	_convert_stats()
	if has_node("StateMachine"):
		state_machine = $StateMachine
	else:
		push_error("EntityNoStateMachine")
	if has_node("StateMachineStateLockedTimer"):
		state_locked_timer = $StateLockedTimer
	if has_node("AnimationPlayer"):
		animation_player = $AnimationPlayer
	else:
		push_error("EntityNoAnimationPlayer")
	if has_node("PathFinder"):
		path_finder = $PathFinder
	else:
		push_error("PathfindingEntityNoPathFinder")
	set_up_direction(Vector2.UP)
	if state_locked_timer != null:
		state_locked_timer.connect("timeout",Callable(self,"unlock_state_switching"))
	_enter()

func _next_target():
	if len(current_path) == 0:
		current_target = null
		return
	current_target = current_path.pop_front()

func pathfinder_set_target(pos: Vector2) -> void:
	await get_tree().process_frame
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(pos, Vector2(pos.x, pos.y + 1000))
	var result = space_state.intersect_ray(query)
	if result:
		var go_to = result["position"]
		current_path = path_finder.find_path(self.position, go_to)
		_next_target()

func pathfinder_flush_points() -> void:
	current_path = []

func pathfinder_get_move_direction():
	if len(current_path) == 0:
		return 0
	if current_target:
		if current_target[0] - padding > position[0]:
			return 1
		elif current_target[0] + padding < position[0]:
			return -1
		else:
			return 0
		
		if position.distance_to(current_target) < target_padding and is_on_floor():
			_next_target()
	else:
		return null
