extends KinematicBody2D




func _ready():
	set_process(true)
	
func _process(delta):
	if(self.visible == true):
		get_node("CollisionShape2D").disabled = false
	elif(self.visible == false):
		get_node("CollisionShape2D").disabled = true
