extends Node

onready var Obstacle = preload("res://Obstacle.tscn")
var count=0

func _ready():
	set_process_input(true)
	set_pause_mode(PAUSE_MODE_PROCESS)
	var up=get_node("palette/up")
	up.connect("pressed", self, "test", [up])
	var down=get_node("palette/down")
	down.connect("pressed", self, "test", [down])
	var left=get_node("palette/left")
	left.connect("pressed", self, "test", [left])
	var right=get_node("palette/right")
	right.connect("pressed", self, "test", [right])

func test(object):
	var commands=get_node("commands")
	var o=object.duplicate()
	o.set_pos(Vector2(count*55+25, 10))
	count=count+1
	commands.add_child(o)
	
func _input(event):
	if event.is_action_pressed("pause"):
		if get_tree().is_paused():
			get_tree().set_pause(false)
		else:
			get_tree().set_pause(true)