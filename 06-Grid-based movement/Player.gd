extends KinematicBody2D

var direction = Vector2()

const MAX_SPEED = 400

var speed = 0
var velocity = Vector2()

var target_pos = Vector2()
var target_direction = Vector2()
var is_moving = false

var type
var grid


func _ready():
	grid = get_parent()
	type = grid.PLAYER
	set_fixed_process(true)


func _fixed_process(delta):
	var global=get_node("/root/global");
	if(!global.running):
		return;
	
	direction = Vector2()
	speed = 0

	if global.steps[0]=="up":
		direction.y = -1
	elif global.steps[0]=="down":
		direction.y = 1
	elif global.steps[0]=="left":
		direction.x = -1
	elif global.steps[0]=="right":
		direction.x = 1
	
	if not is_moving and direction != Vector2():
		target_direction = direction.normalized()
		if grid.is_cell_vacant(get_pos(), direction):
			target_pos = grid.update_child_pos(get_pos(), direction, type)
			is_moving = true
	elif is_moving:
		speed = MAX_SPEED
		velocity = speed * target_direction * delta

		var pos = get_pos()
		var distance_to_target = pos.distance_to(target_pos)
		var move_distance = velocity.length()

		if move_distance > distance_to_target:
			velocity = target_direction * distance_to_target
			is_moving = false
			global.steps.pop_front();
			if(global.steps.size()==0):
				global.running=false;

		move(velocity)
