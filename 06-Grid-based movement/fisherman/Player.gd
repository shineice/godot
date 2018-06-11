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
var game

var expanded_steps=[]
var pickupedObject
var action

func _ready():
	grid = get_parent()
	game=grid.get_parent()
	type = grid.PLAYER
	set_fixed_process(true)


func _fixed_process(delta):
#主要在這邊處理
	var global=get_node("/root/global");
	if(!global.running):
		return;
	var direction = null
	var speed = 0
	if global.gameStatus=="idle":
		if(global.index==global.expandedSteps.size()):
			global.gameStatus="end"
			return
		if global.expandedSteps[global.index]=="up": 
			direction=Vector2(0, -1)
		elif global.expandedSteps[global.index]=="down":
			direction=Vector2(0, 1)
		elif global.expandedSteps[global.index]=="left":
			direction=Vector2(-1, 0)
		elif global.expandedSteps[global.index]=="right":
			direction=Vector2(1, 0)
		elif global.expandedSteps[global.index]=="pickup":
			action="pickup"
			global.gameStatus="action"
		elif global.expandedSteps[global.index]=="putdown":
			action="putdown"
			global.gameStatus="action"
		if direction!=null:
			target_direction = direction.normalized()
			if grid.is_cell_vacant(get_pos(), direction):
				target_pos = grid.update_child_pos(get_pos(), direction, type)
				global.gameStatus="moving"
			else:
				if grid.is_goal(grid.world_to_map(get_pos())+direction):
					global.gameStatus="success"
				else:
					global.gameStatus="fail"
		global.index=global.index+1
		return
	elif global.gameStatus=="end":
		if grid.is_goal(grid.world_to_map(get_pos())):
			global.gameStatus="success"
		else:
			global.gameStatus="fail"
		return
	elif global.gameStatus=="moving":
		speed = MAX_SPEED
		velocity = speed * target_direction * delta

		var pos = get_pos()
		var distance_to_target = pos.distance_to(target_pos)
		var move_distance = velocity.length()
		#以下判斷動作是否執行完了，是的話才執行排在下一個的動作
		if move_distance > distance_to_target:
			velocity = target_direction * distance_to_target
			global.gameStatus="idle"
		move(velocity)
	elif global.gameStatus=="action":
		if action=="pickup":
			var currentPos=grid.world_to_map(get_pos())
			pickupedObject = grid.grid_inst[currentPos.x][currentPos.y]
			grid.grid_inst[currentPos.x][currentPos.y]=null
			grid.grid[currentPos.x][currentPos.y]=null
			grid.remove_child(pickupedObject)
			global.gameStatus="idle"
			return
		elif action=="putdown":
			var currentPos=grid.world_to_map(get_pos())
			grid.grid_inst[currentPos.x][currentPos.y]=pickupedObject
			grid.grid[currentPos.x][currentPos.y]="o"
			pickupedObject.set_pos(grid.map_to_world(currentPos) + grid.half_tile_size)
			grid.add_child(pickupedObject)
			global.gameStatus="idle"
			return
	elif global.gameStatus=="success":
		set_fixed_process(false)
		global.running=false
		global.complete="Y"
		game.upload_game_result()
		game.show_success()
	else:#fail	
		global.running=false
		global.complete="N"
		game.upload_game_result()
		game.show_fail()
	
	if 1==1:
		return
#以陣列放置player動作,要先叫陣列
#陣列.讀取陣列中第一個動作,看是甚麼
	if global.index<global.expandedSteps.size():
		if global.expandedSteps[global.index]=="up": 
			direction.y = -1
		elif global.expandedSteps[global.index]=="down":
			direction.y = 1
		elif global.expandedSteps[global.index]=="left":
			direction.x = -1
		elif global.expandedSteps[global.index]=="right":
			direction.x = 1
	if global.expandedSteps[global.index]=="pickup":
		var currentPos=grid.world_to_map(get_pos())
		pickupedObject = grid.grid_inst[currentPos.x][currentPos.y]
		grid.grid_inst[currentPos.x][currentPos.y]=null
		grid.grid[currentPos.x][currentPos.y]=null
		grid.remove_child(pickupedObject)
		global.index = global.index+1
		if(global.expandedSteps.size()==global.index and 1==0):  
			global.running=false
	elif global.expandedSteps[global.index]=="putdown":
		var currentPos=grid.world_to_map(get_pos())
		grid.grid_inst[currentPos.x][currentPos.y]=pickupedObject
		grid.grid[currentPos.x][currentPos.y]="o"
		pickupedObject.set_pos(map_to_world(currentPos) + grid.half_tile_size)
		grid.add_child(pickupedObject)
		if(global.expandedSteps.size()==global.index and 1==0):  
			global.running=false
	elif not is_moving and global.gameStatus=="normal":
		target_direction = direction.normalized()
		if grid.is_cell_vacant(get_pos(), direction):
			target_pos = grid.update_child_pos(get_pos(), direction, type)
			if target_pos==null:
				is_moving=false
			else:
				is_moving = true
		else:
			is_moving=false
			if grid.is_goal(grid.world_to_map(get_pos())+direction):
				global.gameStatus="success"
			else:
				global.gameStatus="fail"
		
	elif global.gameStatus=="success":
		set_fixed_process(false)
		global.running=false
		global.complete="Y"
		game.upload_game_result()
		game.show_success()
	
	elif global.gameStatus=="fail":
		global.running=false
		global.complete="N"
		game.upload_game_result()
		game.show_fail()
		
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
			global.index = global.index+1
			if(global.expandedSteps.size()==global.index and 1==0):  
				global.running=false

		move(velocity)
