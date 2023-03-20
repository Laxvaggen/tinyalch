class_name EnemyAttackState
extends EnemyState

# play attack animation, then check if player is still in attack range, then either return to hunt or 
# attack again

@export var attack_cooldown: float = 2
@export var attack_animation_name: String = "attack"
@export var stop_motion: bool = true
var cooldown_timer: Timer

func _ready():
	await get_tree().create_timer(0.1).timeout
	animation_player.animation_finished.connect(Callable(self, "animation_finished"))
	if has_node("Cooldown"):
		cooldown_timer = $Cooldown
		cooldown_timer.timeout.connect(Callable(self, "next_attack"))
		

# function to transition between states
func _get_next_state():
	pass

func animation_finished(anim_name: String) -> void:
	if anim_name != attack_animation_name:
		return
	cooldown_timer.start()

func next_attack() -> void:
	if !entity.player_in_attack_range():
		state_machine.transition_to("Hunt")
		return
	if !entity.looking_towards_player():
			entity.set_node_direction(entity.direction*-1)
	if entity.vision_obstruction_multiplier() == 0:
		state_machine.transition_to("Hunt")
		return
	if animation_player.has_animation(attack_animation_name):
		animation_player.play(attack_animation_name)


# is called as a _process()
func update(_delta):
	_get_next_state()


# is called as a _physics_process()
func physics_update(_delta):
	entity.apply_gravity(_delta)

# called when state is transitioned to
func enter(_msg = {}):
	if stop_motion:
		entity.velocity = Vector2.ZERO
	if animation_player.has_animation(attack_animation_name):
		animation_player.play(attack_animation_name)

# called when state is transitioned from
func exit():
	pass

