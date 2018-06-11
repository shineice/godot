# Collection of functions to work with a Grid. Stores all its children in the grid array
extends 'res://fisherman/GridBase.gd'

onready var Obstacle_1 = null
onready var Obstacle_2 = null
onready var Obstacle_3 = null

#define the map
onready var map={}

func initMap():
	var global=get_node("/root/global");
	global.point = "fisherman_2"
	map={
		[0,3]:"Obstacle_3",  
		[10,1]:"Obstacle_2",
		[10,5]:"Obstacle_1",
	}
	Obstacle_1 = preload("res://fisherman/sheep.tscn")
	Obstacle_2 = preload("res://fisherman/wolf_locked.tscn")
	Obstacle_3 = preload("res://fisherman/grass.tscn")
	# Obstacles
	var positions = []
	#process map
	for entry in map:
		var pos=Vector2(entry[0], entry[1])
		positions.append(pos)
		var new_obstacle=null
		if(map[entry]=="Obstacle_1"):
			new_obstacle=Obstacle_1.instance()
		elif(map[entry]=="Obstacle_2"):
			new_obstacle=Obstacle_2.instance()
		elif(map[entry]=="Obstacle_3"):
			new_obstacle=Obstacle_3.instance()
		new_obstacle.set_pos(map_to_world(pos) + half_tile_size)
		grid[pos.x][pos.y] = map[entry]
		grid_inst[pos.x][pos.y]=new_obstacle
		add_child(new_obstacle)

func is_goal(pos):
	if global.steps.size() > 14:
		return false
	return pos.x==10 and pos.y==3



