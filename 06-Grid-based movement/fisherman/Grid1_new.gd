extends 'res://fisherman/GridBase.gd'

var map={
	[0,3]:"res://fisherman/Grass.gd",  
	[10,1]:"res://fisherman/Wolf_locked.gd",
	[10,5]:"res://fisherman/Sheep.gd",
}

func initMap():
	for entry in map:
		spawnObject(entry[0], entry[1], map[entry])
	return

func is_goal(pos):
	if global.steps.size() > 14:
		return false
	if grid[pos.x][pos.y]==null:
		return false
	if String(grid[pos.x][pos.y])=="0":
		return false
	return pos.x==10 and pos.y==3