extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
func _ready():
	var global=get_node("/root/global");
	var bt1=get_node("1")
	bt1.connect("pressed", self, "switchpoint", ["1"])  #[物件, 動作值]
	var bt2=get_node("2")
	bt2.connect("pressed", self, "switchpoint", ["2"]) 
	var bt3=get_node("3")
	bt3.connect("pressed", self, "switchpoint", ["3"])
	var bt4=get_node("home")
	bt4.connect("pressed", global, "back2SceneSwitcher")
	
	pass

func switchpoint(point):
	if point=="1":
		get_tree().change_scene("res://fisherman/Game.tscn")
	elif point=="2":
		get_tree().change_scene("res://fisherman/Game1.tscn")
	elif point=="3":
		get_tree().change_scene("res://fisherman/Game2.tscn")
