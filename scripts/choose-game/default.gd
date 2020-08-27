extends Control



func _ready():
	set_process(true)
	
func _process(delta):
	if(self.visible == true):
		get_node("Start").active = true
	elif(self.visible == false):
		get_node("Start").active = false
	if(get_node("Easy").pressed and self.visible == true):
		get_node("Start").mode = "Easy"
	if(get_node("Normal").pressed and self.visible == true):
		get_node("Start").mode = "Normal"
	if(get_node("Hard").pressed and self.visible == true):
		get_node("Start").mode = "Hard"
