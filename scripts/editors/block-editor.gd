extends Node2D

var r2 = 100
var g = 100
var b = 255
var up_panel = {"x":0, "y":0}
var block_config = ""
onready var symlink = get_node("/root/MainSymlink")
onready var save = get_node("/root/lib_main")
var state = false

func _ready():
	block_config = {"name":$gui/UpPanel/name.text, "game_version":"0.57", "elements":$gui/DownPanel.elements, "objects":[], "settings":{}, "save_path":""}
	get_tree().debug_collisions_hint = true
	prepare_layers()
	symlink.set_music(["res://sounds/soundtracks/micro/block_editor.ogg"])

func background_process():
	$background.modulate = $gui/background_settings/WindowDialog/Panel/ColorPicker.color
	$background.rect_size.x = get_viewport_rect().size.x+50
	$background.rect_size.y = get_viewport_rect().size.y+50
func gui_viewport_sync():
	$gui.rect_size.x = get_viewport_rect().size.x
	$gui.rect_size.y = get_viewport_rect().size.y
func obj_viewport_sync():
	$Object.position.x = get_viewport_rect().size.x/2
	$Object.position.y = get_viewport_rect().size.y/2
func panel_pos_global_sync():
	up_panel.x = get_viewport_rect().size.x
	up_panel.y = get_viewport_rect().size.y-get_viewport_rect().size.y/1.1
	$gui/UpPanel.rect_size.x = up_panel.x
	$gui/UpPanel.rect_size.y = up_panel.y
	$gui/block_options.rect_position.y = get_viewport_rect().size.y/2
	$gui/block_options.rect_position.x = 0#-$gui/block_options.rect_size.x/2
func _process(_delta):
	symlink.texture_editor = $gui/block_options/te.pressed
	background_process()
	gui_viewport_sync()
	if(get_node_or_null("Object")):
		obj_viewport_sync()
	panel_pos_global_sync()
	if(state == false):
		texture_process()
		collision_process()


func _on_background_settings_pressed():
	$gui/background_settings/WindowDialog.popup()

func _on_texturelist_popup_hide():
	print($gui/block_options/te.pressed)
	if($gui/block_options/te.pressed == true):
		$gui/block_options/te.pressed = false



func _on_ce_toggled(button_pressed):
	symlink.collision_editor = button_pressed


func _on_collisionlist_popup_hide():
	if($gui/block_options/ce.pressed):
		$gui/block_options/ce.pressed = false

var textures = []

func texture_process():
	if($"gui/Texture Editor/texturelist/textures".items != textures):
		textures = $"gui/Texture Editor/texturelist/textures".items
		reload_textures()

func reload_textures():
	for child in get_node("Object/textures").get_children():
		child.queue_free()
	var t = 0
	var texture = Sprite.new()
	if($"gui/Texture Editor/texturelist/textures".get_item_count() > 0):
		$gui/UpPanel/icon.texture = $"gui/Texture Editor/texturelist/textures".get_item_icon(0)
	while(t != $"gui/Texture Editor/texturelist/textures".get_item_count()):
		texture = Sprite.new()
		texture.name = "t%d"%t
		texture.texture = $"gui/Texture Editor/texturelist/textures".get_item_icon(t)
		print($"gui/Texture Editor/texturelist/textures".get_item_metadata(t))
		texture.position.x = $"gui/Texture Editor/texturelist/textures".get_item_metadata(t).x
		texture.position.y = $"gui/Texture Editor/texturelist/textures".get_item_metadata(t).y
		texture.set_meta("real_name", $"gui/Texture Editor/texturelist/textures".get_item_text(t))
		texture.set_meta("data_src", {"x":texture.position.x, "y":texture.position.y})
		$Object/textures.add_child(texture)
		get_node("Object/textures/"+texture.name).set_owner(get_node("Object"))
		t += 1

var collisions = []

func collision_process():
	if($"gui/Collison Editor/collisionlist/collisions".items != collisions):
		collisions = $"gui/Collison Editor/collisionlist/collisions".items
		reload_collisions()

var collision_obj = load("res://scenes/editors/objects/collision_obj.tscn")

func reload_collisions():
	for child in get_node("Object/collisions").get_children():
		child.queue_free()
	var t = 0
	var r
	var collision
	var data = {}
	while(t != $"gui/Collison Editor/collisionlist/collisions".get_item_count()):
		collision = collision_obj.instance()
		collision.name = "c%d"%t
		#collision.set_owner(get_node("Object"))
		#collision.owner = get_node("Object")
		data = $"gui/Collison Editor/collisionlist/collisions".get_item_metadata(t)
		if(data.type == "rectangle"):
			r = RectangleShape2D.new()
			r.extents.x = data.size.x
			r.extents.y = data.size.y
			#symlink.console_output("Rectangle load", "warn")
		elif(data.type == "circle"):
			r = CircleShape2D.new()
			r.radius = data.size.r
			#symlink.console_output("Circle load", "warn")
		else:
			r = SegmentShape2D.new()
			r.a.x = data.pos.one.x
			r.a.y = data.pos.one.y
			r.b.x = data.pos.two.x
			r.b.y = data.pos.two.y
			#symlink.console_output("Line load", "warn")
		collision.position.x = data.position.x
		collision.position.y = data.position.y
		var shape = CollisionShape2D.new()
		shape.shape = r
		shape.name = "cc"
		#shape.set_owner(get_node("Object"))
		collision.add_child(shape)
		collision.set_meta("real_name", $"gui/Collison Editor/collisionlist/collisions".get_item_text(t))
		collision.set_meta("real_type", data.type)
		collision.set_meta("data_src", data)
		get_node("Object/collisions").add_child(collision)
		get_node("Object/collisions/"+collision.name).set_owner(get_node("Object"))
		get_node("Object/collisions/"+collision.name+"/"+shape.name).set_owner(get_node("Object"))
		t += 1


func _on_editcollision_popup_hide():
	reload_collisions()


func _on_load_pressed():
	$gui/load.popup_centered()




func _on_load_file_selected(path):
	state = true
	if(get_node_or_null("Object")):
		get_node("Object").visible = false
		var n = "TO_REMOVE%d"%OS.get_system_time_msecs()
		get_node("Object").name = n
		get_node_or_null(n).queue_free()
	var obj = load(path).instance()
	obj.name = "Object"
	add_child(obj, true)
	$"gui/Texture Editor/texturelist/textures".clear()
	for child in get_node_or_null("Object/textures").get_children():
		$"gui/Texture Editor/texturelist/textures".add_item(child.get_meta("real_name"), child.texture)
		print(child.get_meta("data_src"))
		$"gui/Texture Editor/texturelist/textures".set_item_metadata($"gui/Texture Editor/texturelist/textures".get_item_count()-1, child.get_meta("data_src"))
	$"gui/Collison Editor/collisionlist/collisions".clear()
	for child in get_node_or_null("Object/collisions").get_children():
		var texture
		if(child.get_meta("real_type") == "rectangle"):
			texture = load("res://textures/editors/collision_editor/collision_shape.png")
		elif(child.get_meta("real_type") == "circle"):
			texture = load("res://textures/editors/collision_editor/collision_circle.png")
		else:
			texture = load("res://textures/editors/collision_editor/collision_line.png")
		$"gui/Collison Editor/collisionlist/collisions".add_item(child.get_meta("real_name"), texture)
		$"gui/Collison Editor/collisionlist/collisions".set_item_metadata($"gui/Collison Editor/collisionlist/collisions".get_item_count()-1, child.get_meta("data_src"))
	state = false
	$gui/UpPanel/name.text = get_node("Object").get_meta("block_config").name
func _on_save_as_pressed():
	$gui/save_as.popup_centered()

func _on_save_as_file_selected(path):
	block_config.save_path = path
	block_config.name = path.get_file()
	$gui/UpPanel/name.text = block_config.name
	get_node("Object").set_meta("block_config", block_config)
	var pck = PackedScene.new()
	pck.pack(get_node("Object"))
# warning-ignore:return_value_discarded
	ResourceSaver.save(path, pck)
	#lib_main.mkfile(path+".test", "", pck)
func owner_set(path, main_path):
	var t = 0
	var childs = get_node(path).get_children()
	while(t != childs.size()):
		get_node(path+"/"+childs[t].name).owner = get_node(path)
		owner_set(path+"/"+childs[t].name, main_path)
		t += 1
		

func prepare_layers():
	if not(get_node_or_null("Object")):
		var node = Node2D.new()
		node.name = "Object"
		add_child(node)
	if not(get_node_or_null("Object/textures")):
		var node = Node2D.new()
		node.name = "textures"
		get_node("Object").add_child(node)
		get_node("Object/"+node.name).set_owner(get_node("Object"))
	if not(get_node_or_null("Object/collisions")):
		var node = Node2D.new()
		node.name = "collisions"
		get_node("Object").add_child(node)
		get_node("Object/collisions").set_owner(get_node("Object"))

func load_image(path):
	var texture = ImageTexture.new()
	var image = Image.new()
	image.load(path)
	texture.create_from_image(image)
	return texture

func load_items_from_table(table, node_path):
	get_node(node_path).items = table


func _on_save_2_pressed():
	if(block_config.save_path == ""):
		$gui/save_as.popup_centered()
	else:
		_on_save_as_file_selected(block_config.save_path)
