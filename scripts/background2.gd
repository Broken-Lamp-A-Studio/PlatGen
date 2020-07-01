extends Node2D
var rng = RandomNumberGenerator.new()
onready var last_time = OS.get_system_time_msecs()

func move_cloud():
	get_node("Sprite").offset.x += 1
func _ready():
	rng.randomize()
	set_process(true)
func _process(delta):
	if(OS.get_system_time_msecs() - last_time > 100):
		move_cloud()
		last_time = OS.get_system_time_msecs()
	if(get_node("Sprite").offset.x > 300):
		cloud()
		
func cloud():
	get_node("Sprite").visible = false
	get_node("Sprite").offset.x = -5
	var random = rng.randf_range(0, 50)
	get_node("Sprite").offset.y = random
	get_node("Sprite").visible = true

