extends RigidBody2D

onready var time = OS.get_system_time_secs()
var del = false
var touching = true

func _ready():
	set_process(true)

func _process(delta):
	if(touching == false and OS.get_system_time_secs() - time > 3):
		del = true
		time = OS.get_system_time_secs()
	


func _on_grass_body_entered(body):
	if(body.name == "dirt_with_grass" or body.name == "dirt"):
		touching = true



func _on_grass_body_exited(body):
	if(body.name == "dirt_with_grass" or body.name == "dirt"):
		touching = false
		time = OS.get_system_time_secs()
