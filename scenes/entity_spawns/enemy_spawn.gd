extends Marker2D


@export var entity_type: PackedScene

func _ready():
	# spawn an enemy of "entity_type" at position
	var entity_instance = entity_type.instantiate()
	entity_instance.global_position = global_position
	entity_instance.process_mode = entity_instance.PROCESS_MODE_DISABLED
	get_node("/root/World").add_child.call_deferred(entity_instance)
	queue_free()
