extends Control


var animation = 0
onready var time = OS.get_system_time_msecs()

func make_dir(path):
	var dir = Directory.new()
	if not(dir.dir_exists(path)):
		dir.make_dir(path)
func read_file(path, type):
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
		else:
			data = file.get_as_text()
		file.close()
	return data
func write_file(path, type, data):
	var file = File.new()
	file.open(path, File.WRITE)
	if(type == "json"):
		
		file.store_line(to_json(data))
	elif(type == "var"):
		file.store_var(data)
	elif(type == "buffer"):
		file.store_buffer(data)
	elif(type == "string"):
		file.store_string(data)
	elif(type == "real"):
		file.store_real(data)
	else:
		file.store_line(data)
	file.close()

var list = []

func _ready():
	self.visible = false
	self.modulate.a = 0
	var dir = Directory.new()
	if not(dir.file_exists("user://save/worldsx.var")):
		write_file("user://save/worldsx.var", "var", [])
	list = read_file("user://save/worldsx.var", "var")
	var tick = 0
	print("Menu opened.")
	print("Available worlds:")
	print(list)
	while not(tick == list.size()):
		
		$Panel/ItemList.add_item(list[tick])
		tick += 1
	

func undo_animation_process():
	if(OS.get_system_time_msecs() - time > 10):
		if not(self.modulate.a <= 0):
			self.modulate.a -= 0.05
		else:
			animation = 0
			self.visible = false
		time = OS.get_system_time_msecs()

func animation_process():
	if(OS.get_system_time_msecs() - time > 10):
		if not(self.modulate.a > 1):
			self.visible = true
			self.modulate.a += 0.05
		else:
			animation = 0
		time = OS.get_system_time_msecs()

func animation_init():
	if(animation == -1):
		undo_animation_process()
	elif(animation == 1):
		animation_process()

func get_open():
	animation = 1

func get_menu(menu):
	get_tree().get_root().get_node("Menu2/Camera2D/CanvasLayer/GUI/"+menu).get_open()

onready var time2 = OS.get_system_time_msecs()

func _process(_delta):
	animation_init()
	if($Panel/Delete.pressed and OS.get_system_time_msecs() - time2 > 300):
		var n = get_node("Panel/World-name").text
		get_node("Panel/World-name").text = "Unnamed"
		$Panel/ItemList.clear()
		list.remove(list.find(n))
		write_file("user://save/worldsx.var", "var", list)
		var tick = 0
		print(list)
		while not(tick == list.size()):
			$Panel/ItemList.add_item(list[tick])
			tick += 1
		remove_all("user://save/"+n)
		time2 = OS.get_system_time_msecs()
	#else:
	#	time2 = OS.get_system_time_msecs()
	if($Panel/Back.pressed):
		animation = -1
		get_menu("MainMenu")
	if($Panel/Start.pressed):
		write_file("user://save/save_files.data", "", "user://save")
		write_file("user://save/worldname.world", "", get_node("Panel/World-name").text)
		if not(list.has(get_node("Panel/World-name").text)):
			list += [get_node("Panel/World-name").text]
			#print(list)
			write_file("user://save/worldsx.var", "var", list)
			time2 = OS.get_system_time_msecs()
		if(OS.get_system_time_msecs() - time > 50):
# warning-ignore:return_value_discarded
			get_tree().change_scene("res://scenes/GAME.tscn")

func check_dir(path):
	var dir = Directory.new()
	if(dir.dir_exists(path)):
		return true
	else:
		return false

func check_file(path):
	var dir = Directory.new()
	if(dir.file_exists(path)):
		return true
	else:
		return false


func _on_ItemList_item_selected(index):
	get_node("Panel/World-name").text = $Panel/ItemList.get_item_text(index)

func remove_all(path):
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	var data = dir.get_next()
	while not(data == ""):
		if not(data == "." or data == ".."):
			#print(data)
			if(dir.current_is_dir()):
				remove_all(path+"/"+data)
				dir.remove(path+"/"+data)
			else:
				dir.remove(path+"/"+data)
		data = dir.get_next()
	dir.remove(path)
