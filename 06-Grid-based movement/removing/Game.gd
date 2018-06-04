extends Node

onready var Obstacle = preload("res://Obstacle.tscn")
onready var Obstacle_1 = preload("res://Obstacle_1.tscn")
onready var Obstacle_2 = preload("res://Obstacle_2.tscn")
onready var Obstacle_3 = preload("res://Obstacle_3.tscn")
onready var Obstacle_4 = preload("res://Obstacle_4.tscn")
onready var guest = preload("res://guest.tscn")
onready var number = preload("res://number.tscn")
onready var half = preload("res://half.tscn")

var count=0
var i=0

func _ready():
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
	
func test(object, action): #[物件, 動作值]
	var commands=get_node("commands")
	var o=object.duplicate()
	o.set_pos(Vector2(count*55+25, 10))
	count=count+1
	commands.add_child(o)
	#宣告一個全域陣列(or project setting->Autoload)
	var global=get_node("/root/global");  
	global.steps.append(action);#把陣列的值掛上去
	print(global.steps)
	
func _input(event):
	if event.is_action_pressed("pause"):
		if get_tree().is_paused():
			get_tree().set_pause(false)
		else:
			get_tree().set_pause(true)
