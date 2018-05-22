# Collection of functions to work with a Grid. Stores all its children in the grid array
extends TileMap

enum ENTITY_TYPES {PLAYER, OBSTACLE, COLLECTIBLE}

var tile_size = Vector2(50,50)#get_cell_size()
var half_tile_size = tile_size / 2
var grid_size = Vector2(17,7)#Vector2(16, 16)

var grid = []
onready var Obstacle = preload("res://Obstacle.tscn")
onready var Obstacle_1 = preload("res://Obstacle_1.tscn")
onready var Obstacle_2 = preload("res://Obstacle_2.tscn")
onready var Obstacle_3 = preload("res://Obstacle_3.tscn")
onready var Obstacle_4 = preload("res://Obstacle_4.tscn")
onready var Player = preload("res://Player.tscn")

#define the map
onready var map={
	[15,5]:"Obstacle", #鍋
	[15,1]:"Obstacle_1", #刀
	[10,1]:"Obstacle_3",
	[10,5]:"Obstacle_4",
	[3,3]:"Obstacle_2" #loop
}

func _ready():
	for x in range(grid_size.x):
		grid.append([])
		for y in range(grid_size.y):
			grid[x].append(null)

	# Player
	var new_player = Player.instance()
	new_player.set_pos(map_to_world(Vector2(0,0)) + half_tile_size)
	add_child(new_player)

	# Obstacles
	var positions = []
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
		#new_obstacle.set_pos(pos*50-tile_size/2)
		grid[pos.x][pos.y] = new_obstacle.get_name()
		add_child(new_obstacle)

	#process map
	for entry in map:
		var pos=Vector2(entry[0], entry[1])
		positions.append(pos)
		var new_obstacle=null
		if(map[entry]=="Obstacle"):
			new_obstacle=Obstacle.instance()
		elif(map[entry]=="Obstacle_1"):
			new_obstacle=Obstacle_1.instance()
		elif(map[entry]=="Obstacle_2"):
			new_obstacle=Obstacle_2.instance()
		elif(map[entry]=="Obstacle_3"):
			new_obstacle=Obstacle_3.instance()
		elif(map[entry]=="Obstacle_4"):
			new_obstacle=Obstacle_4.instance()
		new_obstacle.set_pos(map_to_world(pos) + half_tile_size)
		grid[pos.x][pos.y] = new_obstacle.get_name()
		add_child(new_obstacle)

func get_cell_content(pos=Vector2()):
	return grid[pos.x][pos.y]


func is_cell_vacant(pos=Vector2(), direction=Vector2()):
	var grid_pos = world_to_map(pos) + direction
	if grid_pos.x < grid_size.x and grid_pos.x >= 0:
		if grid_pos.y < grid_size.y and grid_pos.y >= 0:
			return true if grid[grid_pos.x][grid_pos.y] == null else false
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