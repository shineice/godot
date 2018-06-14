extends 'res://fisherman/GridObject.gd'

var pickupedObject=null

func init():
	.init("Player", "Player", "res://fisherman/Player.tscn")
	
func isKinematicObject():
	return true

func pickup(obj):
	getParentGrid().removeObject(obj)

func putdown(obj):
	var pos=getGridPos()
	getParentGrid().addObject(pos.x, pos.y, pickupedObject)