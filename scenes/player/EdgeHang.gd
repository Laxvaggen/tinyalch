extends PlayerState

# function to transition between states
func _get_next_state():
	if Input.is_action_pressed("jump"):
		state_machine.transition_to("Air", {doJump=true})
		player.lock_state_switching(0.1)
	elif  Input.is_action_pressed("fall_through"):
		state_machine.transition_to("Air")
	elif Input.is_action_pressed("move_left"):
		if player.direction == -1:
			animation_player.play("climb_from_ledge")
		else:
			player.set_node_direction(1)
			state_machine.transition_to("Air")
	elif Input.is_action_pressed("move_right"):
		if player.direction == 1:
			animation_player.play("climb_from_ledge")
		else:
			player.set_node_direction(-1)
			state_machine.transition_to("Air")


func _go_to_ledge() -> void:
	var raycast: RayCast2D = $"../../EdgeGroundFinder"
	player.position += raycast.get_collision_point() - raycast.global_position

# is called as a _process()
func update(_delta):
	_get_next_state()

# is called as a _physics_process()
func physics_update(_delta):
	pass

# called when state is transitioned to
func enter(_msg = {}):
	_go_to_ledge()
	player.velocity = Vector2.ZERO
	animation_player.play("grab_ledge")
	$"../../Sprite".position = Vector2(-3*player.direction, 8)
	
	

# called when state is transitioned from
func exit():
	$"../../Sprite".position = Vector2(0, 6)
