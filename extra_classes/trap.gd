class_name Trap
extends Area2D


@export var always_active: bool

var activation_delay: Timer
var reset_delay: Timer
var hitbox: HitBox
var animation_player: AnimationPlayer


func _ready():
	if always_active:
		return
	assert(has_node("CollisionShape2D"))
	if has_node("HitBox"):
		hitbox = $HitBox
		assert(hitbox.has_node("CollisionShape2D"))
	else:
		push_error("noHitBox")
	if has_node("ActivationTimer"):
		activation_delay = $ActivationTimer
	else:
		push_error("noActivationTimer")
	if has_node("ResetTimer"):
		reset_delay = $ResetTimer
	else:
		push_error("ResetTimer")
	if has_node("AnimationPlayer"):
		animation_player = $AnimationPlayer
	else:
		push_error("noAnimationPlayer")
	
	hitbox.get_node("CollisionShape2D").set_deferred("disabled", true)
	hitbox.connect("area_entered", Callable(self, "_cycle_trap"))

#Use and reset trap, if trap is activatable
func _cycle_trap() -> void:
	activation_delay.start()
	await activation_delay.timeout
	animation_player.play("activate")
	$CollisionShape2D.set_deferred("disabled", true)
	reset_delay.start()
	await reset_delay.timeout
	$CollisionShape2D.set_deferred("disabled", false)
