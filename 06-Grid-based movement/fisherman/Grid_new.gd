extends 'res://fisherman/GridBase.gd'

var map={
	[3,3]:"res://fisherman/Sheep.gd",
	[9,2]:"res://fisherman/Wolf.gd",
	[9,4]:"res://fisherman/Wolf.gd",
	[9,6]:"res://fisherman/Wolf.gd",
	[11,1]:"res://fisherman/Wolf.gd",
	[11,3]:"res://fisherman/Wolf.gd",
	[11,5]:"res://fisherman/Wolf.gd",
}

func initMap():
	for entry in map:
		spawnObject(entry[0], entry[1], map[entry])
	spawnObject(0, 0, "res://fisherman/FishermanPlayer.gd")
	return

func is_goal(pos):
	if grid[pos.x][pos.y]==null:
		return false
	if(getObjectByName(pos.x, pos.y, "Sheep")==null):
		return false
	return pos.x==9 and pos.y==0