extends Button


func _process(_delta):
	if(self.pressed):
		get_tree().change_scene("res://scenes/GAME.tscn")
