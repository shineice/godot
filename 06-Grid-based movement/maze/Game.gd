extends Node

onready var Obstacle = preload("res://maze/Obstacle.tscn")
var count=0
var i=0
var timer
func _ready():
	var global=get_node("/root/global");
	global.mapid=""
	set_process_input(true)
	set_pause_mode(PAUSE_MODE_PROCESS)
	var up=get_node("palette/up")
	up.connect("pressed", self, "test", [up, "up"])  #[物件, 動作值]
	var down=get_node("palette/down")
	down.connect("pressed", self, "test", [down, "down"])
	var left=get_node("palette/left")
	left.connect("pressed", self, "test", [left, "left"])
	var right=get_node("palette/right")
	right.connect("pressed", self, "test", [right, "right"])
	var start=get_node("palette/start");
	start.connect("pressed", self, "startRunning");

func startRunning():
	var global=get_node("/root/global");
	global.running=true;
	#if complete_point yes/no  (global.complete=Y/global.complete=N)
	global.complete="Y"
	
func test(object, action): #[物件, 動作值]
	var commands=get_node("commands")
	#var o=object.duplicate()
	var o=Button.new()
	o.text=action
	o.set_pos(Vector2(count*55+25, 10))
	count=count+1
	commands.add_child(o)
	#宣告一個全域陣列(or project setting->Autoload)
	var global=get_node("/root/global");
	var u=preload("res://uuid.gd")  
	global.steps.append(action);#把陣列的值掛上去
	#print(global.steps)
	global.list[i]=[String(u.v4()),"add",action,String(OS.get_unix_time())]
	i=i+1
	
func _input(event):
	if event.is_action_pressed("pause"):
		if get_tree().is_paused():
			get_tree().set_pause(false)
		else:
			get_tree().set_pause(true)
			
func show_fail():
	get_node("Grid/fail").show()
	var grid=get_node("Grid")
	timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_timer_process_mode(0)
	timer.set_wait_time(3)
	timer.connect("timeout", self, "reset")
	grid.add_child(timer)
	timer.start()

func show_success():
	get_node("Grid/success").show()
	var grid=get_node("Grid")
	timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_timer_process_mode(0)
	timer.set_wait_time(3)
	timer.connect("timeout", self, "reset")
	grid.add_child(timer)
	timer.start()

func upload_game_result():
	var u=preload("res://uuid.gd")
	global.mapid=String(u.v4())
	var global=get_node("/root/global");
	#global.gamepoint(global.mapid,global.studentid,"point2",String(OS.get_unix_time()),String(global.steps.size()),global.complete)
	var s={"value":global.list}.to_json()
	#global.gamestatus(s);
	#print("json"+s.percent_encode())

func reset():
	var global=get_node("/root/global");
	var grid=get_node("Grid")
	global.reset()
	grid.reset()