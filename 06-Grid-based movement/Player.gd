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
#主要在這邊處理
	var global=get_node("/root/global");
	if(!global.running):
		return;
	direction = Vector2()
	speed = 0
#以陣列放置player動作,要先叫陣列
#陣列.讀取陣列中第一個動作,看是甚麼
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
		else:
			if grid.is_goal(grid.world_to_map(get_pos())+direction):
				print("success")
				set_fixed_process(false)
			else:
				print("fail")
				set_fixed_process(false)
#判斷成敗Start
#	if not is_moving and global.gameStatus=="normal":
#		target_direction = direction.normalized()
#		if grid.is_cell_vacant(get_pos(), direction):
#			target_pos = grid.update_child_pos(get_pos(), direction, type)
#			if target_pos==null:
#				is_moving=false
#			else:
#				is_moving = true
#		else:
#			is_moving=false
#			if grid.is_goal(grid.world_to_map(get_pos())+direction):
#				global.gameStatus="success"
#			else:
#				global.gameStatus="fail"
#		#remove else
#	elif global.gameStatus=="success":
#		global.currentLevel=global.currentLevel+1
#		if(global.currentLevel>5):
#			global.currentLevel=5
#		set_fixed_process(false)
		#game.upload_game_result()
		#game.show_success()
	#elif global.gameStatus=="fail":
	#	game.upload_game_result()
	#	game.show_fail()
#判斷成敗end

	elif is_moving:
		speed = MAX_SPEED
		velocity = speed * target_direction * delta

		var pos = get_pos()
		var distance_to_target = pos.distance_to(target_pos)
		var move_distance = velocity.length()
#以下判斷動作是否執行完了，是的話才執行排在下一個的動作
		if move_distance > distance_to_target:
			velocity = target_direction * distance_to_target
			is_moving = false
			global.steps.pop_front();
			if(global.steps.size()==0):
				global.running=false;

		move(velocity)
