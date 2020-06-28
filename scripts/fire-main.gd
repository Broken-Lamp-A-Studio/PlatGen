extends Node2D

onready var time = OS.get_system_time_msecs()
var rng = RandomNumberGenerator.new()
var random = 0
func _ready():
	rng.randomize()

func _process(delta):
	if(OS.get_system_time_msecs() - time > 100):
		random = rng.randf_range(-2, 2)
		get_node("Sprite").rotate(random)
		random = rng.randf_range(-2, 2)
		get_node("Sprite2").rotate(random)
		random = rng.randf_range(-2, 2)
		get_node("Sprite3").rotate(random)
		time = OS.get_system_time_msecs()
