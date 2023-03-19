class_name EnemyAttackState
extends EnemyState

# play attack animation, then check if player is still in attack range, then either return to hunt or 
# attack again


# function to transition between states
func _get_next_state():
	pass

# is called as a _process()
func update(_delta):
	_get_next_state()


# is called as a _physics_process()
func physics_update(_delta):
	entity.apply_gravity(_delta)

# called when state is transitioned to
func enter(_msg = {}):
	if animation_player.has_animation("attack"):
		animation_player.play("attack")

# called when state is transitioned from
func exit():
	pass

