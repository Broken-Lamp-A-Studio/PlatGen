extends Control

var gen = []
var SEED = 00000000

func _ready():
	$gui/left/content/VBoxContainer/MenuButton.get_popup().connect("index_pressed", self, "_menu_one_index_pressed")
	gen = lib_main.rdfile("user://objects/generator.var", "var")
	


func _on_load_file_selected(path):
	pass



func _on_save_as_file_selected(path):
	pass # Replace with function body.



func _on_gen_seed_pressed():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	$"gui/CORNER down_left/HBoxContainer/seed".text = "%d"%rng.randf_range(0, 99999999)
	SEED = int($"gui/CORNER down_left/HBoxContainer/seed".text)

func _on_seed_text_changed(new_text):
	SEED = int(new_text)

func _menu_one_index_pressed(index):
	pass
