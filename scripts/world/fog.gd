extends Node2D

var rng = RandomNumberGenerator.new()
onready var time = OS.get_system_time_msecs()
onready var time2 = OS.get_system_time_secs()
var animation = false
var clone = preload("res://scenes/Fog2.tscn")
var count = 0
var rc = 0
var ccount = 0
var random = rng.randf_range(1, 5)
var x = 0
var y = 0
var cname = "0"
var clist = 0

func _ready():
	clist = ""
	rng.randomize()
	rc = clone.instance()
	set_process(true)
func _process(delta):
	if(animation == true):
		if(OS.get_system_time_secs() - time2 > random):
			if not(ccount > 15):
				ccount += 1
				cname = "obj2%d" % ccount
				clist = [clist, cname]
				rc.name = cname
				print(cname)
				self.add_child(rc)
				get_node(cname).go(x, y)
				get_node(cname).visible = true
				get_node(cname).set_process(true)
			if(ccount > 15):
				print(clist)
				set_process(false)
			time2 = OS.get_system_time_secs()
			random = rng.randf_range(1, 5)
			
		
