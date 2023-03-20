class_name Level
extends Node2D

var stats ={"kills":0, 
			"stealth_kills": 0,
			"damage_taken": 0,
			"time": 0,
			"times_detected": 0
					}

var processing_pathfinders: Array

var lamp_nodes: Array

var player: Player

var tilemap: TileMap

func _ready() -> void:
	if has_node("TileMap"):
		tilemap = $TileMap

	else:
		push_error("noTilemapInLevel")
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
		pathfinder_node.started_processing.connect(Callable(self, "pathfinder_started_processing"))
		pathfinder_node.finished_processing.connect(Callable(self, "pathfinder_finished_processing"))
	
	for lamp_node in get_children().filter(func(node): return node is Lamp):
		lamp_node.player = player
		if lamp_node.has_node("RayCast2D"):
			lamp_node.get_node("RayCast2D")
			
		lamp_nodes.append(lamp_node)
	

func _process(delta: float) -> void:
	stats["time"] += delta
	_send_lightlevel_to_player()
	if processing_pathfinders.size() == 0:
		erase_unpathables(tilemap)

func _send_lightlevel_to_player() -> void:
	if player == null: 
		return
	for lamp in lamp_nodes:
		if lamp.player_is_in_lightcone():
			player.receive_light_level(true)
			return
	player.receive_light_level(false)

func get_pathfinders() -> Array:
	var pathfinders: Array = []
	for enemy in get_children().filter( func(node): return node is Enemy):
		if has_node("PathFinder"):
			pathfinders.append(enemy.get_node("PathFinder"))
	return pathfinders

func pathfinder_started_processing(node):
	processing_pathfinders.append(node)

func pathfinder_finished_processing(node):
	processing_pathfinders.erase(node)

func erase_unpathables(tilemap_to_erase:TileMap) -> void:
	var unpathable_cells = tilemap_to_erase.get_used_cells(0).filter(func(cell): 
		return tilemap_to_erase.get_cell_tile_data(0, cell).get_custom_data("unpathable"))
	for cell in unpathable_cells:
		tilemap_to_erase.erase_cell(0, cell)
	
	
	
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
