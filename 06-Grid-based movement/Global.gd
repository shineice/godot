extends Node

var steps=[];
var expandedSteps=[]
var running=false;
var complete;
var mapid;
var point;
var studentid="10325209"; #Save to global.studentid (signing in)
var list=[];
var index = 0;

var currentGame="maze"
var currentLevel=1

var gameStatus="idle" #normal/fail/success
var SAVE_LOCALLY=1

func reset():
	steps=[]
	expandedSteps=[]
	index=0
	running=false
	gameStatus="normal"

func gamepoint(mapid,stuid,gamepoint,datetime,blocknum,complete):
	if SAVE_LOCALLY==1:
		var dir=Directory.new()
		var savePath="user://gamepoint.save"
		if(dir.dir_exists("/sdcard")):
			savePath="/sdcard/gamepoint.save"
		var savegame = File.new()
		if(savegame.file_exists(savePath)):
			savegame.open(savePath, File.READ_WRITE)
			savegame.seek_end();
		else:
			savegame.open(savePath, File.WRITE)
		savegame.store_line("mapid="+mapid+"&stuid="+stuid+"&gamepoint="+gamepoint+"&datetime="+datetime+"&blocknum="+blocknum+"&complete="+complete)
		savegame.close()
		return
	var err=0
	var http = HTTPClient.new() 
	var err = http.connect("imsofa.rocks",8080) 
	assert(err==OK) # Make sure connection was OK
	while( http.get_status()==HTTPClient.STATUS_CONNECTING or http.get_status()==HTTPClient.STATUS_RESOLVING):
		http.poll()
		print("Connecting..")
		OS.delay_msec(100)

	assert( http.get_status() == HTTPClient.STATUS_CONNECTED ) 

	var headers=[
	   "User-Agent: Pirulo/1.0 (Godot)",
		"Accept: */*"
	]
	var req="mapid="+mapid+"&stuid="+stuid+"&gamepoint="+gamepoint+"&datetime="+datetime+"&blocknum="+blocknum+"&complete="+complete
	err = http.request(HTTPClient.METHOD_GET,"/GameProgramLearningServer/GamePointService?"+req,headers) # Request a page from the site (this one was chunked..)

	assert( err == OK ) # Make sure all is OK

	while (http.get_status() == HTTPClient.STATUS_REQUESTING):
		# Keep polling until the request is going on
		http.poll()
		print("Requesting.."+String(http.get_status()))
		OS.delay_msec(100)

	assert( http.get_status() == HTTPClient.STATUS_BODY or http.get_status() == HTTPClient.STATUS_CONNECTED ) # Make sure request finished well.
	print("response? ",http.has_response()) 

func gamestatus(req):
	if SAVE_LOCALLY==1:
		var dir=Directory.new()
		var savePath="user://gamestatus.save"
		if(dir.dir_exists("/sdcard")):
			savePath="/sdcard/gamestatus.save"
		var savegame = File.new()
		if(savegame.file_exists(savePath)):
			savegame.open(savePath, File.READ_WRITE)
			savegame.seek_end();
		else:
			savegame.open(savePath, File.WRITE)
		savegame.store_line(req)
		savegame.close()
		return
	var err=0
	var http = HTTPClient.new() 
	var err = http.connect("imsofa.rocks",8080) 
	assert(err==OK) # Make sure connection was OK
	while( http.get_status()==HTTPClient.STATUS_CONNECTING or http.get_status()==HTTPClient.STATUS_RESOLVING):
		http.poll()
		print("Connecting..")
		OS.delay_msec(100)

	assert( http.get_status() == HTTPClient.STATUS_CONNECTED ) 

	var headers=[
	   "User-Agent: Pirulo/1.0 (Godot)",
		"Accept: */*"
	]
	err = http.request(HTTPClient.METHOD_POST,"/GameProgramLearningServer/GameStatusService?req="+req.percent_encode(),headers) # Request a page from the site (this one was chunked..)

	assert( err == OK ) # Make sure all is OK

	while (http.get_status() == HTTPClient.STATUS_REQUESTING):
		# Keep polling until the request is going on
		http.poll()
		print("Requesting.."+String(http.get_status()))
		OS.delay_msec(100)

	assert( http.get_status() == HTTPClient.STATUS_BODY or http.get_status() == HTTPClient.STATUS_CONNECTED ) # Make sure request finished well.
	print("response? ",http.has_response()) 

func back2SceneSwitcher():
	get_tree().change_scene("res://LevelSelection.tscn")

