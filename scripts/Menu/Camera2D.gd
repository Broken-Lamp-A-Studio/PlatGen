extends Camera2D


var sx = 0
var sy = 0
onready var time = OS.get_system_time_msecs()
func _ready():
	position.x = sx+500
	position.y = sx+200
var v1 = 0
var v2 = 0
var v3 = true
func animationstart():
	if(OS.get_system_time_msecs() - time > 1):
		position.x += 5
		v1 += 1
		if(v1 > 100):
			v3 = true
		time = OS.get_system_time_msecs()
func _process(_delta):
	if(v3 == false):
		animationstart()
