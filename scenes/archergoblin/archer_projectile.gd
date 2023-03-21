extends RigidBody2D


var direction: int
var speed := 500


# Called when the node enters the scene tree for the first time.
func _ready():
	set_axis_velocity(Vector2(direction*speed, -75))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_colliding_bodies().size() > 0:
		queue_free()

func _physics_process(delta):
	pass


func _on_decay_timer_timeout():
	queue_free()
