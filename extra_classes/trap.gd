class_name Trap
extends Area2D


@export var always_active: bool

var activation_delay: Timer
var reset_delay: Timer
var hitbox: HitBox
var animation_player: AnimationPlayer


func _ready():
	collision_layer = 0
	set_collision_mask_value(1, true)
	set_collision_mask_value(2, true)
	if always_active:
		if has_node("AnimationPlayer") and get_node("AnimationPlayer").has_animation("idle"):
			get_node("AnimationPlayer").play("idle")
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
		if animation_player.has_animation("idle"):
			animation_player.play("idle")
	else:
		push_error("noAnimationPlayer")
	
	connect("area_entered", Callable(self, "_cycle_trap"))

#Use and reset trap, if trap is activatable
func _cycle_trap(_area) -> void:
	activation_delay.start()
	await activation_delay.timeout
	animation_player.play("activate")
	$CollisionShape2D.set_deferred("disabled", true)
	reset_delay.start()
	await reset_delay.timeout
	$CollisionShape2D.set_deferred("disabled", false)
	animation_player.play("idle")
