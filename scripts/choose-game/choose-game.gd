extends Node2D

var type = "Default"


func _ready():
	set_process(true)
	
func _process(delta):
	if(get_node("Buttons/main/Default").pressed):
		type = "Default"
	if(get_node("Buttons/main/Story").pressed):
		type = "Story"
	if(type == "Default"):
		get_node("Buttons/default").visible = true
		get_node("Buttons/story").visible = false
	if(type == "Story"):
		get_node("Buttons/story").visible = true
		get_node("Buttons/default").visible = false
		
