extends Control

var active = false
var cursor = ""

func _ready():
	$main/ItemList.setup(200, 0, 250, 230)

func _input(event):
	if(active == true and event.is_action_pressed("inv_open")):
		print($main/ItemList.items)
		self.visible = not self.visible


func get_stop():
	set_process(false)
	set_process_input(false)
	set_physics_process(false)

func get_play():
	set_process(true)
	set_process_input(true)
	set_physics_process(true)

func add_item(name2, texture):
	$main/ItemList.add_item(name2, load(texture))
