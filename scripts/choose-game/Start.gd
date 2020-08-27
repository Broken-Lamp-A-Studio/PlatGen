extends TextureButton

var save_data = File.new()
var name_data = "res://data/settings.info"
var info_data = "res://data/main.json"
var mode = "Easy"
var active = false
var main_data = 0

func _ready():
	set_process(true)

func _process(delta):
	main_data = {
		"type" : "default",
		"mode" : mode
	}
	if(self.pressed and active == true):
		save()
		get_tree().change_scene("res://scenes/game/main-game.tscn")




func save():
	save_data.open(info_data, File.WRITE)
	save_data.store_line(to_json(main_data))
	save_data.close()
