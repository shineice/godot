extends KinematicBody2D

var direction = Vector2()

const MAX_SPEED = 400

var speed = 0
var velocity = Vector2()

var target_pos = Vector2()
var target_direction = Vector2()
var is_moving = false

var grid
var game

var expanded_steps=[]
var action

var object

func _ready():
	grid = get_parent()
	game=grid.get_parent()
	object=grid.getObjectFromNode(self)
	set_fixed_process(true)

func _fixed_process(delta):
#主要在這邊處理
	var global=get_node("/root/global");
	if(!global.running):
		return;
	object.tick(delta)
