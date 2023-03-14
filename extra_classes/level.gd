class_name Level
extends Node2D

var stats = {"kills":0, 
					"damage taken": 0,
					"time": 0
					}

func _ready() -> void:
	assert(has_node("TileMap"))
	assert(has_node("Background"))
	assert(has_node("Player"))
	$Player.connect("damage_taken",Callable(self,"player_damage_taken"))
	for enemy in get_children().filter(func(node): node is Enemy):
		enemy.connect("died",Callable(self,"enemy_died"))

func _process(delta: float) -> void:
	stats["time"] += delta

func level_cleared() -> void:
	SceneManager._level_cleared(stats)

func level_failed() -> void:
	SceneManager.level_failed(stats)

func player_damage_taken(amount: int) -> void:
	stats["damage_taken"] += amount

func enemy_died() -> void:
	stats["kills"] += 1
