extends Node2D
var rng = RandomNumberGenerator.new()
var actime = 0
var random = 0
var done = 0
func _ready():
	get_node("Control/TextureRect2").rect_position.x = 301
	rng.randomize()
	cloud()
	get_node("Control/TextureRect2").visible = false
	set_process(true)




func _process(delta):
	print(OS.get_system_time_secs())
	print(actime)
	
	
	if(OS.get_system_time_secs() - actime > 1):
		cloud_go()
		actime = OS.get_system_time_secs()
	if(get_node("Control/TextureRect2").rect_position.x > 300):
		get_node("Control/TextureRect2").visible = false
		cloud()


	
	
func cloud():
	print("Cloud visible!")
	random = rng.randf_range(-20, -10)
	get_node("Control/TextureRect2").visible = false
	get_node("Control/TextureRect2").rect_position.x = random
	random = rng.randf_range(0, 50)
	get_node("Control/TextureRect2").rect_position.y = random
	get_node("Control/TextureRect2").visible = true
	
func cloud_go():
	done += 1
	print(done)
	get_node("Control/TextureRect2").rect_position.x += done
