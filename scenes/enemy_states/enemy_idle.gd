class_name EnemyIdleState
extends EnemyState

# randomly select a point within max roaming distance, pathfind there.
# then play a timer with randomized wait time, play idle animation 
# when timer runs out, pathfind to a new location
# transition to hunt or alert if notices player



## the sight score at which enemy is alerted
@export var sight_alert_threshold: float = -0.25
@export var max_roaming_distance: float = 5

@export var run_animation_name: String = "run"
@export var idle_animation_name: String = "idle"

var idle_timer: Timer

func _ready():
	if has_node("Timer"):
		idle_timer = $Timer
	idle_timer.timeout.connect(Callable(self, "_set_new_roaming_target"))

# function to transition between states
func _get_next_state():
	var sight_score = entity.get_sight_score_difference()
	if sight_score > 0:
		state_machine.transition_to("Hunt", {play_icon=true})
		entity.emit_signal("spotted_player")
	elif sight_score > sight_alert_threshold:
		state_machine.transition_to("Alert", {play_icon=true})
	elif entity.get_noise_score_difference() > 0 and !entity.looking_towards_player():
		entity.set_node_direction(entity.direction*-1)
		
 
func _set_new_roaming_target() -> void:
	var target_angle := Vector2.from_angle(randf_range(-PI, PI))
	var target := Vector2(entity.spawn_position + (target_angle * randf_range(0, max_roaming_distance*Globals.tile_size)))
	entity.pathfinder_set_target(target)

# is called as a _process()
func update(_delta):
	_get_next_state()


# is called as a _physics_process()
func physics_update(_delta):
	if entity.velocity.x == 0:
		animation_player.play(idle_animation_name)
	else:
		animation_player.play(run_animation_name)
	if entity.get_noise_score_difference() > 0 and !entity.looking_towards_player():
		entity.set_node_direction(entity.direction*-1)
	entity.apply_gravity(_delta)
	
	if !entity.current_path == []:
		entity.pathfind(0.75)
	else:
		if idle_timer.time_left == 0:
			idle_timer.start(randf_range(0.5, 3))

# called when state is transitioned to
func enter(_msg = {}):
	_set_new_roaming_target()

# called when state is transitioned from
func exit():
	idle_timer.stop()

