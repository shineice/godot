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
var timer


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
	if global.steps[global.index]=="up": 
		direction.y = -1
	elif global.steps[global.index]=="down":
		direction.y = 1
	elif global.steps[global.index]=="left":
		direction.x = -1
	elif global.steps[global.index]=="right":
		direction.x = 1
	
	if not is_moving and direction != Vector2():
		target_direction = direction.normalized()
		if grid.is_cell_vacant(get_pos(), direction):
			target_pos = grid.update_child_pos(get_pos(), direction, type)
			is_moving = true
		else:
			grid.show_fail()
			timer = Timer.new()
			timer.set_one_shot(true)
			timer.set_timer_process_mode(0)
			timer.set_wait_time(3)
			timer.connect("timeout", self, "reset")
			grid.add_child(timer)
			timer.start()
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
			#不刪除功能start
			#global.steps.pop_front();
			global.index = global.index+1
			if(global.steps.size()==global.index):  
				global.running=false;
			#End
				var u=preload("res://uuid.gd")
				global.mapid=String(u.v4())
				global.gamepoint(global.mapid,global.studentid,"point2",String(OS.get_unix_time()),String(global.steps.size()),global.complete)
				for i in range(global.index):
					global.gamestatus(global.list[i][0],global.mapid,global.list[i][1],global.list[i][2],global.list[i][3])
		move(velocity)
	if(grid.is_goal(grid.world_to_map(get_pos()))):
		var global=get_node("/root/global");
		global.currentLevel=(global.currentLevel+1)%4
		is_moving=false
		set_fixed_process(false)
		grid.show_success()
		timer = Timer.new()
		timer.set_one_shot(true)
		timer.set_timer_process_mode(0)
		timer.set_wait_time(3)
		timer.connect("timeout", self, "reset")
		grid.add_child(timer)
		timer.start()

func reset():
	var global=get_node("/root/global");
	global.steps=[]
	global.index=0
	grid.reset()
	global.running=false;