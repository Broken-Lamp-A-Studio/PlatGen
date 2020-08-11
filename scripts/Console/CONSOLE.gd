extends Node2D

var text = ""
var console = false

func _ready():
	self.visible = false
	set_process(true)
	set_process_input(true)
	
func _process(delta):
	if(Input.is_action_just_pressed("ui_console")):
		if(console == false):
			self.visible = true
			get_node("KEYB").visible = true
			console = true
			text = ""
	
	if(console == true):
		get_node("KEYB/information").text = "Enter Command:"
		get_node("OUTPUT/RichTextLabel").text = ""
		get_node("KEYB/text").text = text
			
		
	
