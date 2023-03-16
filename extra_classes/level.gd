class_name Level
extends Node2D

var stats ={"kills":0, 
			"stealth_kills": 0,
			"damage taken": 0,
			"time": 0,
			"times_detected": 0
					}

var processing_pathfinders: Array

var lamp_nodes: Array

var player: Player

func _ready() -> void:
	assert(has_node("TileMap"))
	if has_node("Player"):
		player = $Player
	else:
		push_error("noPlayerInLevel")
	player.connect("damage_taken", Callable(self,"player_damage_taken"))
	for enemy in get_children().filter(func(node): return node is Enemy):
		enemy.connect("died", Callable(self,"enemy_died"))
		enemy.connect("spotted_player", Callable(self, "player_spotted"))
		enemy.player = player
	for pathfinder_node in get_pathfinders():
		processing_pathfinders.append(pathfinder_node)
		pathfinder_node.finished_processing.connect(Callable(self, "pathfinder_finished_processing"))
	var tilemap = get_node("/root/World/TileMap")
	var cells_by_id = tilemap.get_used_cells_by_id(0)
	
	for lamp_node in get_children().filter(func(node): return node is Lamp):
		lamp_node.player = player
		if lamp_node.has_node("RayCast2D"):
			lamp_node.get_node("RayCast2D")
			
		lamp_nodes.append(lamp_node)

func _process(delta: float) -> void:
	stats["time"] += delta
	_send_lightlevel_to_player()

func _send_lightlevel_to_player() -> void:
	var total_light_level_at_player:float = 0
	for lamp in lamp_nodes:
		total_light_level_at_player += lamp.get_lightlevel_at_player()
	player.receive_light_level(total_light_level_at_player)

func get_pathfinders() -> Array:
	var pathfinders: Array
	for enemy in get_children().filter( func(node): return node is Enemy):
		if has_node("PathFinder"):
			pathfinders.append(enemy.get_node("PathFinder"))
	return pathfinders

func pathfinder_finished_processing(node):
	processing_pathfinders.erase(node)
	if processing_pathfinders.size() == 0:
		erase_unpathables(node.tilemap)

func erase_unpathables(tilemap:TileMap) -> void:
	var unpathable_cells = tilemap.get_used_cells(0).filter(func(cell): 
		return tilemap.get_cell_tile_data(0, cell).get_custom_data("unpathable"))
	for cell in unpathable_cells:
		tilemap.erase_cell(0, cell)
	
	
	
#Called when level is completed
func level_cleared() -> void:
	SceneManager._level_cleared(stats)

#Called when player dies
func level_failed() -> void:
	SceneManager.level_failed(stats)

func player_damage_taken(amount: int) -> void:
	stats["damage_taken"] += amount

func enemy_died() -> void:
	#get enemy state, if state is [not noticed player]:
	#stats["stealth_kills"] += 1
	stats["kills"] += 1

func player_spotted() -> void:
	stats["times_detected"] += 1
