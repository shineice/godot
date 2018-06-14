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
var pickupedObject
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
				var grid_pos = grid.getMapPos(get_pos().x, get_pos().y)
				var new_grid_pos = grid_pos + direction
				target_pos = grid.getWorldPos(new_grid_pos.x, new_grid_pos.y)
				global.gameStatus="moving"
			else:
				if grid.is_goal(grid.getMapPos(get_pos().x, get_pos().y)+direction):
					global.gameStatus="success"
				else:
					global.gameStatus="fail"
		global.index=global.index+1
		return
	elif global.gameStatus=="end":
		if grid.is_goal(grid.getMapPos(get_pos().x, get_pos().y)):
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
		if(global.gameStatus=="idle"):
			#update pos
			var o=grid.getObjectFromNode(self)
			grid.removeObject(o)
			var gridPos=grid.getMapPos(get_pos().x, get_pos().y)
			grid.addObject(gridPos.x, gridPos.y, o)
	elif global.gameStatus=="action":
		if action=="pickup":
			var currentPos=grid.getMapPos(get_pos().x, get_pos().y)
			pickupedObject = grid.getFirstObject(currentPos.x, currentPos.y)
			grid.removeObject(pickupedObject)
			global.gameStatus="idle"
			return
		elif action=="putdown":
			if pickupedObject == null:
				global.gameStatus="fail"
				return
			var currentPos=grid.getMapPos(get_pos().x, get_pos().y)
			grid.addObject(currentPos.x, currentPos.y, pickupedObject)
#			
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

