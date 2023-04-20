class_name Pathfinder
extends Node2D

var jump_height: float = 2.5*Globals.tile_size
var jump_distance: float = 2*Globals.tile_size

var tilemap: TileMap
var graph

var cell_size = Globals.tile_size

signal started_processing(entity:Pathfinder)
signal finished_processing(entity:Pathfinder)


func find_path(start, end) -> Array:
	"""
	return a list of actions: move right/left/jump depending on path
	"""
	var first_point = graph.get_closest_point(start)
	var last_point = graph.get_closest_point(end)
	var path = graph.get_id_path(first_point, last_point)
	
	if len(path) == 0:
		return path
	
	var actions: Array = []
	
	var last_pos: Vector2
	for point in path:
		var pos = graph.get_point_position(point)
		var type = cell_type(pos, true, true)
		
		if (last_pos and last_pos.y >= pos.y - (cell_size * jump_height) and
			(last_pos.x < pos.x and type[0] == -1) or last_pos.x > pos.x and type[1] == -1):
				actions.append(null) 
		last_pos = pos
		
		if point == path[0] and len(path) > 1:
			var next_pos = graph.get_point_position(path[1])
			if start.distance_to(next_pos) > pos.distance_to(next_pos):
				actions.append(pos)
		elif point == path[-1] and len(path) > 1:
			if graph.get_point_position(path[-2]).distance_to(end) < pos.distance_to(end):
				actions.append(pos)
		else:
			actions.append(pos)
	
	actions.append(end)
	return actions

func _ready() -> void:
	
	graph = AStar2D.new()
	tilemap = find_parent("World")

	assert(tilemap != null)
	global_position = tilemap.global_position
	await get_tree().process_frame
	create_map()
	connect_points()
	emit_signal("finished_processing", self)

func get_relevant_cells():
	"""
	return a list of tiles/cells in current tilemap, excluding tiles pathfinder should not interact with
	"""
	var cells = tilemap.get_used_cells(0).filter(func(cell): return tilemap.get_cell_source_id(0, cell) in [0, 1])
	cells = cells.filter(func(cell): 
		return !tilemap.get_cell_tile_data(0, cell).get_custom_data("decoration"))
	return cells

func connect_points():
	"""
	create connections/paths between points, which pathfinding entities can navigate
	"""
	
	var points = graph.get_point_ids()
	for point in points:
		var close_right = -1
		var close_left_drop = -1
		var close_right_drop = -1
		var pos = graph.get_point_position(point)
		var type = cell_type(pos, true, true)
		
		var points_to_join := []
		var no_bi_join := []
		
		for new_point in points:
			var new_pos = graph.get_point_position(new_point)
			if type[1] == 0 and new_pos.y == pos.y and new_pos.x > pos.x:
				if close_right < 0 or new_pos.x < graph.get_point_position(close_right).x:
					close_right = new_point
		
			if type[0] == -1:
				if new_pos.x == pos.x - cell_size and new_pos.y > pos.y:
					if close_left_drop < 0 or new_pos.y < graph.get_point_position(close_left_drop).y:
						close_left_drop = new_point
				if (new_pos.y >= pos.y - (cell_size * jump_height) and new_pos.y <= pos.y and 
					new_pos.x > pos.x - (cell_size * (jump_distance + 2)) and new_pos.x < pos.x and cell_type(new_pos, true, true)[1] == -1):
					points_to_join.append(new_point)
					
			if type[1] == -1:
				if new_pos.x == pos.x + cell_size and new_pos.y > pos.y:
					if close_right_drop < 0 or new_pos.y < graph.get_point_position(close_right_drop).y:
						close_right_drop = new_point
				if (new_pos.y >= pos.y - (cell_size * jump_height) and new_pos.y <= pos.y and 
					new_pos.x < pos.x + (cell_size * (jump_distance + 2)) and new_pos.x > pos.x and cell_type(new_pos, true, true)[0] == -1):
					points_to_join.append(new_point)
		
		if close_right > 0: 
			points_to_join.append(close_right)
		if close_left_drop > 0:
			if graph.get_point_position(close_left_drop).y <= pos.y + cell_size * jump_height:
				points_to_join.append(close_left_drop)
			else:
				no_bi_join.append(close_left_drop)
		if close_right_drop > 0:
			if graph.get_point_position(close_right_drop).y <= pos.y + cell_size * jump_height:
				points_to_join.append(close_right_drop)
			else:
				no_bi_join.append(close_right_drop)
		
		for join in points_to_join:
			graph.connect_points(point, join)
		for join in no_bi_join:
			graph.connect_points(point, join, false)
	
func create_map() -> void:
	"""
	create points to be navigated between
	"""
	var space_state = get_world_2d().direct_space_state
	var cells = get_relevant_cells()
	for cell in cells:
		var type = cell_type(cell)
		if type and type != Vector2i.ZERO:
			create_point(cell)
			
			if type[0] == -1:
				var pos = tilemap.map_to_local(Vector2i(cell.x - 1, cell.y))
				var pos_to = Vector2(pos.x, pos.y + 1000)
				pos = to_global(pos)
				pos_to = to_global(pos_to)
				var query = PhysicsRayQueryParameters2D.create(pos, pos_to)
				var result = space_state.intersect_ray(query)
				if result:
					create_point(tilemap.local_to_map(result.position))
			
			if type[1] == -1:
				var pos = tilemap.map_to_local(Vector2i(cell.x + 1, cell.y))
				var pos_to = Vector2(pos.x, pos.y + 1000)
				pos = to_global(pos)
				pos_to = to_global(pos_to)
				var query = PhysicsRayQueryParameters2D.create(pos, pos_to)
				var result = space_state.intersect_ray(query)
				if result:
					create_point(tilemap.local_to_map(result.position))
					

func cell_type(pos: Vector2i, global = false, is_above = false):
	"""
	get cell type, defined by existence of adjacent cells
	"""
	if global:
		pos = tilemap.local_to_map(pos)
	if is_above:
		pos = Vector2(pos.x, pos.y + 1)
	var cells = get_relevant_cells()
	if Vector2i(pos.x, pos.y - 1) in cells:
		return null
	
	var results = Vector2i.ZERO
	
	if Vector2i(pos.x - 1, pos.y - 1) in cells:
		results[0] = 1
	elif !Vector2i(pos.x - 1, pos.y) in cells:
		results[0] = -1
	
	if Vector2i(pos.x + 1, pos.y - 1) in cells:
		results[1] = 1
	elif !Vector2i(pos.x + 1, pos.y) in cells:
		results[1] = -1
	return results

func create_point(pos: Vector2i) -> void:
	if graph.get_point_ids() and graph.get_point_position(graph.get_closest_point(pos)) == Vector2(pos):
		return
	var actual_pos = tilemap.map_to_local(Vector2i(pos.x, pos.y - 1))
	graph.add_point(graph.get_available_point_id(), actual_pos)
