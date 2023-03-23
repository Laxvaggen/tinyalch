extends PlayerState

@onready var coyote_timer := $CoyoteTimer

var landing_sound = load("res://sound/Retro FootStep 03.wav")

# function to transition between states
func _get_next_state():
	if player.is_on_floor() and player.velocity.y >= 0:
		state_machine.transition_to("Idle", {noForceAnimation=true})
		animation_player.play("land")
		player.play_sound_effect(landing_sound)
	elif player.is_on_edge() and player.velocity.y >= 0:
		state_machine.transition_to("EdgeHang")
		player.play_sound_effect(landing_sound)
	elif Input.is_action_pressed("dash"):
		state_machine.transition_to("Dash")

# is called as a _process()
func update(_delta):
	_get_next_state()
	if Input.is_action_just_pressed("jump") and !coyote_timer.is_stopped():
		player.jump()
		coyote_timer.stop()
	

# is called as a _physics_process()
func physics_update(_delta):
	player.apply_gravity(_delta)
	if Input.is_action_pressed("move_left"):
		player.velocity = player.velocity.move_toward(Vector2(player.air_speed*-1, player.velocity.y), player.air_acceleration*_delta)
	elif Input.is_action_pressed("move_right"):
		player.velocity = player.velocity.move_toward(Vector2(player.air_speed*1, player.velocity.y), player.air_acceleration*_delta)
	else:
		player.velocity = player.velocity.move_toward(Vector2(0, player.velocity.y), player.air_acceleration*_delta)
	
	if player.velocity.y > 0:
		animation_player.play("fall")
	else:
		animation_player.play("jump")

# called when state is transitioned to
func enter(_msg = {}):
	player.lock_state_switching(0.1)
	if _msg.has("doJump"):
		player.jump()
	else:
		coyote_timer.start()
# called when state is transitioned from
func exit():
	coyote_timer.stop()
