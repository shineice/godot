# Collection of functions to work with a Grid. Stores all its children in the grid array
extends TileMap

enum ENTITY_TYPES {PLAYER, OBSTACLE, COLLECTIBLE}

var tile_size = Vector2(50,50)#get_cell_size()
var half_tile_size = tile_size / 2
var grid_size = Vector2(16, 10)
var timer

var grid = []
onready var global=get_node("/root/global")
onready var Obstacle = preload("res://maze/Obstacle.tscn")
onready var goal = preload("res://maze/goal.tscn")
onready var Player = preload("res://maze/Player.tscn")
#define the map
onready var map={
	[15,9]:"goal"
}

var level_obstacle_positions=[
	[Vector2(5,5),Vector2(5,6),Vector2(5,7),Vector2(6,7),Vector2(7,7),Vector2(8,7),Vector2(9,7),Vector2(8,3),Vector2(9,3),
		Vector2(10,3),Vector2(11,3),Vector2(11,4)]
]

func _ready():
	#get_node("success").show()
	for x in range(grid_size.x):
		grid.append([])
		for y in range(grid_size.y):
			grid[x].append(null)

	# Player
	var new_player = Player.instance()
	new_player.set_pos(map_to_world(Vector2(0,0)) + half_tile_size)
	add_child(new_player)

	# Obstacles
	var positions = level_obstacle_positions[global.currentLevel-1]
	#for x in range(5):
	#	var placed = false
	#	while not placed:
	#		var grid_pos = Vector2(randi() % int(grid_size.x), randi() % int(grid_size.y))
	#		if not grid[grid_pos.x][grid_pos.y]:
	#			if not grid_pos in positions:
	#				positions.append(grid_pos)
	#				placed = true

	for pos in positions:
		var new_obstacle = Obstacle.instance()
		new_obstacle.set_pos(map_to_world(pos) + half_tile_size)
		grid[pos.x][pos.y] = new_obstacle.get_name()
		add_child(new_obstacle)
	
	#process map
	for entry in map:
		var pos=Vector2(entry[0], entry[1])
		positions.append(pos)
		var new_obstacle=null
		if(map[entry]=="Obstacle"):
			new_obstacle=Obstacle.instance()
		elif(map[entry]=="goal"):
			new_obstacle=goal.instance()
		new_obstacle.set_pos(map_to_world(pos) + half_tile_size)
		grid[pos.x][pos.y] = new_obstacle.get_name()
		add_child(new_obstacle)
func get_cell_content(pos=Vector2()):
	return grid[pos.x][pos.y]


func is_cell_vacant(pos=Vector2(), direction=Vector2()):
	var grid_pos = world_to_map(pos) + direction
	if grid_pos.x < grid_size.x and grid_pos.x >= 0:
		if grid_pos.y < grid_size.y and grid_pos.y >= 0:
			return true if grid[grid_pos.x][grid_pos.y] == null or  grid[grid_pos.x][grid_pos.y]=="goal" else false
	return false


func update_child_pos(new_pos, direction, type):
	# Remove node from current cell, add it to the new cell, returns the new target move_to position
	var grid_pos = world_to_map(new_pos)
	print(grid_pos)
	grid[grid_pos.x][grid_pos.y] = null
	
	var new_grid_pos = grid_pos + direction
	grid[new_grid_pos.x][new_grid_pos.y] = type
	
	var target_pos = map_to_world(new_grid_pos) + half_tile_size
	return target_pos

func show_fail():
	get_node("fail").show()
	
func reset():
	get_tree().reload_current_scene()