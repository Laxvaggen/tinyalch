class_name Level
extends TileMap

var stats ={"kills":0, 
			"stealth_kills": 0,
			"damage_taken": 0,
			"time": 0,
			"times_detected": 0
					}

var lamp_nodes: Array
var player: Player

var background := preload("res://scenes/Background.tscn")

func _ready() -> void:
		
	await get_tree().process_frame
	add_child(background.instantiate())
	if has_node("Player"):
		player = $Player
		player.connect("died", Callable(self, "level_failed"))
	else:
		push_error("noPlayerInLevel")
	player.connect("damage_taken", Callable(self,"player_damage_taken"))
	set_enemy_properties()
	set_lamp_properties()
	for child in get_children():
		if child.process_mode == Node.PROCESS_MODE_DISABLED:
			child.process_mode = Node.PROCESS_MODE_INHERIT


func set_enemy_properties() -> void:
	for enemy in get_children().filter(func(node): return node.is_in_group("Enemy")):
		enemy.connect("died", Callable(self,"enemy_died"))
		enemy.connect("spotted_player", Callable(self, "player_spotted"))
		enemy.player = player

func set_lamp_properties() -> void:
	for lamp_node in get_children().filter(func(node): return node.is_in_group("Lamp")):
		lamp_node.player = player
		lamp_nodes.append(lamp_node)

func _process(delta: float) -> void:
	stats["time"] += delta
	_send_lightlevel_to_player()

func _send_lightlevel_to_player() -> void:
	if player == null: 
		return
	for lamp in lamp_nodes:
		if lamp.player_is_in_lightcone():
			player.receive_light_level(true)
			return
	player.receive_light_level(false)

func erase_unpathables() -> void:
	var unpathable_cells = get_used_cells(0).filter(func(cell): return get_cell_source_id(0, cell) == 0)
	unpathable_cells = unpathable_cells.filter(func(cell): 
		return get_cell_tile_data(0, cell).get_custom_data("unpathable"))
	for cell in unpathable_cells:
		erase_cell(0, cell)
	
	
	
#Called when level is completed
func level_cleared() -> void:
	SceneManager.level_cleared(stats)

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
