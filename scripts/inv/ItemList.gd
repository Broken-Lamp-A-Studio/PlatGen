extends ItemList

var mouse_entered = false
const lib = preload("res://libs/main.gd")
var path2 = ""
func _ready():
	var gn = read_file("user://save/worldname.world")
	path2 = "user://save/"+gn
	var dir = Directory.new()
	print("path:"+path2)
	if(dir.file_exists(path2+"/inv/"+name+".inv")):
		items = rdfile(path2+"/inv/"+name+".inv", "var")

func setup(x, y, w, h):
	rect_position.x = x
	rect_position.y = y
	rect_size.x = w
	rect_size.y = h

func _on_ItemList_item_selected(index):
	if(get_tree().get_root().get_node("GAME/player/CanvasLayer/inv").cursor == ""):
		print(name+" index selected:%d"%index)
		get_tree().get_root().get_node("GAME/player/CanvasLayer/mouse").texture = self.get_item_icon(index)
		get_tree().get_root().get_node("GAME/player/CanvasLayer/inv").cursor = self.get_item_text(index)
		get_tree().get_root().get_node("GAME/player/CanvasLayer/mouse/Label").text = self.get_item_text(index)
		self.remove_item(index)


func _on_ItemList_mouse_entered():
	mouse_entered = true


func _on_ItemList_mouse_exited():
	mouse_entered = false

func _input(event):
	if(mouse_entered == true and event.is_action_pressed("left_mouse_button")):
		if(get_tree().get_root().get_node("GAME/player/CanvasLayer/inv").cursor != ""):
			self.add_item(get_tree().get_root().get_node("GAME/player/CanvasLayer/inv").cursor, get_tree().get_root().get_node("GAME/player/CanvasLayer/mouse").texture)
			get_tree().get_root().get_node("GAME/player/CanvasLayer/mouse").texture = load("res://textures/mouse.png")
			get_tree().get_root().get_node("GAME/player/CanvasLayer/inv").cursor = ""
			get_tree().get_root().get_node("GAME/player/CanvasLayer/mouse/Label").text = ""

func _notification(what):
	if(what == NOTIFICATION_WM_QUIT_REQUEST or what == NOTIFICATION_EXIT_TREE or what == NOTIFICATION_MOUSE_EXIT):
		path2 = get_tree().get_root().get_node("GAME").gp
		lib.mkdir(path2+"/inv")
		lib.mkfile(path2+"/inv/"+name+".inv", "var", items)

func exit_2():
	path2 = get_tree().get_root().get_node("GAME").gp
	lib.mkdir(path2+"/inv")
	lib.mkfile(path2+"/inv/"+name+".inv", "var", items)

static func rdfile(path, type):
	var data = null
	var file = File.new()
	var dir = Directory.new()
	if(dir.file_exists(path)):
		file.open(path, File.READ)
		if(type == "json"):
			data = parse_json(file.get_line())
		elif(type == "table"):
			data = [parse_json(file.get_line())]
		elif(type == "var"):
			data = file.get_var()
		elif(type == "script"):
			data = file.get_script()
		else:
			data = file.get_as_text()
		file.close()
	return data

func read_file(path):
	var file = File.new()
	file.open(path, File.READ)
	var data = file.get_line()
	file.close()
	return data
