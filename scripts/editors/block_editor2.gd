extends Control


func _ready():
	get_tree().debug_collisions_hint = true
	get_tree().debug_navigation_hint = true
	get_node("object").position.x = get_viewport_rect().size.x/2
	get_node("object").position.y = get_viewport_rect().size.y/2
	render_tree()

var object_path = ""

func _on_load_object_pressed():
	$Windows/load.popup_centered()


func _on_save_as_object_pressed():
	$Windows/save_as.popup_centered()


func _on_save_object_pressed():
	if(object_path == ""):
		_on_save_as_object_pressed()


func _on_bgcolor_object_pressed():
	$Windows/ChangeBackground.popup_centered()


func _on_exit_pressed():
	pass # Replace with function body.


func _on_ColorPicker_color_changed(color):
	$background.color = color


func _on_new_texture_pressed():
	$Windows/new_texture.popup_centered()


func _on_new_collision_pressed():
	$Windows/new_collision.popup_centered()


func _on_new_shader_pressed():
	$Windows/new_shader.popup_centered()


func _on_new_particle_pressed():
	$Windows/new_particle.popup_centered()




func _on_create_texture_pressed():
	if not(get_node_or_null("object/textures")):
		mk_node("object", "textures")
	if($Windows/new_texture/enviroment/s/e/e/n/name.text == "" or get_node("object/textures").has_node($Windows/new_texture/enviroment/s/e/e/n/name.text)):
		MainSymlink.show_error("You can't set this name.")
	else:
		if($Windows/new_texture/enviroment/s/e/e/p/path.text == ""):
			MainSymlink.show_error("No path defined.")
		elif($Windows/new_texture/enviroment/s/e/e/p/path.text.get_base_dir().is_abs_path() == false):
			MainSymlink.show_error("Invalid path.")
		else:
			if($Windows/new_texture/enviroment/s/e/e/t/type.selected == 0):
				var init_texture = lib_main.load_image($Windows/new_texture/enviroment/s/e/e/p/path.text)
				var atlas_texture = AtlasTexture.new()
				atlas_texture.atlas = init_texture
				atlas_texture.region.size.x = init_texture.get_size().x
				atlas_texture.region.size.y = init_texture.get_size().y
				mk_texture("object/textures", $Windows/new_texture/enviroment/s/e/e/n/name.text, atlas_texture, "object")
			else:
				var init_texture = load($Windows/new_texture/enviroment/s/e/e/p/path.text)
				var atlas_texture = AtlasTexture.new()
				atlas_texture.atlas = init_texture
				atlas_texture.region.size.x = init_texture.get_size().x
				atlas_texture.region.size.y = init_texture.get_size().y
				mk_texture("object/textures", $Windows/new_texture/enviroment/s/e/e/n/name.text, atlas_texture, "object")
			render_tree()
			$Windows/new_texture.hide()
			

func mk_node(path, name2):
	var obj = Node2D.new()
	obj.name = name2
	get_node_or_null(path).add_child(obj)
	get_node(path+"/"+name2).set_owner(get_node(path))

func mk_texture(path, name2, texture, owner2):
	var obj = Sprite.new()
	obj.name = name2
	obj.texture = texture
	get_node_or_null(path).add_child(obj)
	get_node(path+"/"+name2).set_owner(get_node(owner2))

func _on_select_texture_path_pressed():
	$Windows/select_texture.popup_centered()


func _on_select_texture_file_selected(path):
	$Windows/new_texture/enviroment/s/e/e/p/path.text = path






func _on_create_collision_pressed():
	if not(get_node_or_null("object/collisions")):
		mk_node("object", "collisions")
	if($Windows/new_collision/enviroment/s/e/e/n/name.text == "" or get_node_or_null("object/collisions").has_node($Windows/new_collision/enviroment/s/e/e/n/name.text)):
		MainSymlink.show_error("You can't set this name.")
	else:
		if($Windows/new_collision/enviroment/s/e/e/t2/type2.selected == 0):
			mk_static("object", $Windows/new_collision/enviroment/s/e/e/n/name.text, "object/collisions")
		elif($Windows/new_collision/enviroment/s/e/e/t2/type2.selected == 1):
			mk_rigid("object", $Windows/new_collision/enviroment/s/e/e/n/name.text, "object/collisions")
		else:
			mk_kinematic("object", $Windows/new_collision/enviroment/s/e/e/n/name.text, "object/collisions")
		if($Windows/new_collision/enviroment/s/e/e/t/type.selected == 0):
			mk_square("object", "collision", "object/collisions/"+$Windows/new_collision/enviroment/s/e/e/n/name.text)
		else:
			mk_circle("object", "collision", "object/collisions/"+$Windows/new_collision/enviroment/s/e/e/n/name.text)
		render_tree()
		$Windows/new_collision.hide()


func mk_static(owner2, name2, path):
	var obj = StaticBody2D.new()
	obj.name = name2
	get_node_or_null(path).add_child(obj)
	get_node(path+"/"+name2).set_owner(get_node(owner2))

func mk_rigid(owner2, name2, path):
	var obj = RigidBody2D.new()
	obj.name = name2
	obj.owner = get_node(owner2)
	get_node_or_null(path).add_child(obj)
	get_node(path+"/"+name2).set_owner(get_node(owner2))

func mk_kinematic(owner2, name2, path):
	var obj = KinematicBody2D.new()
	obj.name = name2
	get_node_or_null(path).add_child(obj)
	get_node(path+"/"+name2).set_owner(get_node(owner2))


func mk_square(owner2, name2, path):
	var obj = CollisionShape2D.new()
	obj.name = name2
	var shape = RectangleShape2D.new()
	obj.shape = shape
	obj.set_meta("type", "rectangle")
	get_node_or_null(path).add_child(obj)
	get_node(path+"/"+name2).set_owner(get_node(owner2))

func mk_circle(owner2, name2, path):
	var obj = CollisionShape2D.new()
	obj.name = name2
	var shape = CircleShape2D.new()
	obj.shape = shape
	obj.set_meta("type", "circle")
	get_node_or_null(path).add_child(obj)
	get_node(path+"/"+name2).set_owner(get_node(owner2))





func _on_create_particle_pressed():
	if not(get_node_or_null("object/particles")):
		mk_node("object", "particles")
	if($Windows/new_particle/enviroment/s/e/e/n/name.text == "" or get_node("object/particles").has_node($Windows/new_particle/enviroment/s/e/e/n/name.text)):
		MainSymlink.show_error("You can't set this name.")
	else:
		mk_particle("object", $Windows/new_particle/enviroment/s/e/e/n/name.text, "object/particles")
		render_tree()
		$Windows/new_particle.hide()


func mk_particle(owner2, name2, path):
	var obj = Particles2D.new()
	obj.name = name2
	get_node_or_null(path).add_child(obj)
	get_node(path+"/"+name2).set_owner(get_node(owner2))


func _on_new_light_pressed():
	$Windows/new_light.popup_centered()


func mk_light(owner2, name2, path, texture):
	var obj = Light2D.new()
	obj.name = name2
	obj.texture = texture
	get_node(path).add_child(obj)
	get_node(path+"/"+name2).set_owner(get_node(owner2))


func _on_create_light_pressed():
	if not(get_node_or_null("object/lights")):
		mk_node("object", "lights")
	if($Windows/new_light/environment/s/e/e/n/name.text == "" or get_node_or_null("object/lights").has_node($Windows/new_light/environment/s/e/e/n/name.text)):
		MainSymlink.show_error("You can't set this name.")
	elif($Windows/new_light/environment/s/e/e/p/path.text == ""):
		MainSymlink.show_error("Texture path is empty.")
	elif($Windows/new_light/environment/s/e/e/p/path.text.get_base_dir().is_abs_path() == false):
		MainSymlink.show_error("Invalid path.")
	else:
		if($Windows/new_light/environment/s/e/e/t/type.selected == 0):
			var init_texture = lib_main.load_image($Windows/new_light/environment/s/e/e/p/path.text)
			var atlas_texture = AtlasTexture.new()
			atlas_texture.atlas = init_texture
			atlas_texture.region.size.x = init_texture.get_size().x
			atlas_texture.region.size.y = init_texture.get_size().y
			mk_light("object", $Windows/new_light/environment/s/e/e/n/name.text, "object/lights", atlas_texture)
		else:
			var init_texture = load($Windows/new_light/environment/s/e/e/p/path.text)
			var atlas_texture = AtlasTexture.new()
			atlas_texture.atlas = init_texture
			atlas_texture.region.size.x = init_texture.get_size().x
			atlas_texture.region.size.y = init_texture.get_size().y
			mk_light("object", $Windows/new_light/environment/s/e/e/n/name.text, "object/lights", atlas_texture)
		render_tree()
		$Windows/new_light.hide()


func _on_select_texture_light_pressed():
	$Windows/select_light_texture.popup_centered()


func _on_select_light_texture_file_selected(path):
	$Windows/new_light/environment/s/e/e/p/path.text = path


func _on_new_light_occluder_pressed():
	$Windows/new_lightoccluder.popup_centered()


func _on_create_light_occluder_pressed():
	if not(get_node_or_null("object/occluders")):
		mk_node("object", "occluders")
	if($Windows/new_lightoccluder/environment/s/e/e/n/name.text == "" or get_node_or_null("object/occluders").has_node($Windows/new_lightoccluder/environment/s/e/e/n/name.text)):
		MainSymlink.show_error("You can't set this name.")
	else:
		mk_occluder("object", $Windows/new_lightoccluder/environment/s/e/e/n/name.text, "object/occluders")
		render_tree()
		$Windows/new_lightoccluder.hide()

func mk_occluder(owner2, name2, path):
	var obj = LightOccluder2D.new()
	obj.name = name2
	var shape = OccluderPolygon2D.new()
	obj.occluder = shape
	get_node(path).add_child(obj)
	get_node(path+"/"+name2).set_owner(get_node(owner2))



func render_tree():
	$GUI/LeftPanel/enviroment/s/e/e/tree.clear()
	var root = $GUI/LeftPanel/enviroment/s/e/e/tree.create_item()
	for child in get_node("object").get_children():
		var obj = $GUI/LeftPanel/enviroment/s/e/e/tree.create_item(root)
		obj.set_text(0, child.name)
		obj.set_meta("path", child.get_path())
		obj.set_icon(0, load("res://textures/editors/icons/node_icon.png"))
		for child_child in child.get_children():
			var obj2 = $GUI/LeftPanel/enviroment/s/e/e/tree.create_item(obj)
			obj2.set_text(0, child_child.name)
			obj2.set_meta("path", child_child.get_path())
			if(child_child is Sprite):
				obj2.set_icon(0, load("res://textures/editors/icons/texture_icon.png"))
			elif(child_child is Particles2D):
				obj2.set_icon(0, load("res://textures/editors/icons/particle_icon.png"))
			#elif(child_child is Node2D):
			#	obj2.set_icon(0, load("res://textures/editors/icons/node_icon.png"))
			elif(child_child is Light2D):
				obj2.set_icon(0, load("res://textures/editors/icons/light_icon.png"))
			elif(child_child is LightOccluder2D):
				obj2.set_icon(0, load("res://textures/editors/icons/light_occluder_icon.png"))
			elif(child_child is RigidBody2D or child_child is KinematicBody2D or child_child is StaticBody2D):
				obj2.set_icon(0, load("res://textures/editors/icons/collision_icon.png"))
			elif(child_child is AnimationPlayer or child_child is AnimationTree or child_child is AnimationTreePlayer):
				obj2.set_icon(0, load("res://textures/editors/icons/animation_icon.png"))
			elif(child_child is Node):
				obj2.set_icon(0, load("res://textures/editors/icons/cfg_icon.png"))
			else:
				obj2.set_icon(0, load("res://textures/editors/icons/txt_icon.png"))

func _input(event):
	if(event.is_action_pressed("ui_right_click")):
		get_node("object").position = get_global_mouse_position()
	if(event.is_action_pressed("ui_down")):
		get_node("object").position.y += 5
	elif(event.is_action_pressed("ui_up")):
		get_node("object").position.y -= 5
	elif(event.is_action_pressed("ui_left")):
		get_node("object").position.x -= 5
	elif(event.is_action_pressed("ui_right")):
		get_node("object").position.x += 5


func _on_load_file_selected(path):
	var scene = load(path).instance()
	scene.name = "object"
	if(scene.get_node_or_null("OBJECT_REG")):
		var n = str(OS.get_system_time_msecs())
		get_node("object").name = n
		get_node(n).visible = false
		add_child(scene)
		get_node(n).queue_free()
		render_tree()
		$GUI/UpPanel/enviroment/left/name.text = path.get_file().get_basename()
	else:
		MainSymlink.show_warn("Scene is not defined as object")


func _on_save_as_file_selected(path):
	var scene = PackedScene.new()
	scene.pack(get_node("object"))
	scene.name = path.get_filename()
	$GUI/UpPanel/enviroment/left/name.text = path.get_file()
	ResourceSaver.save(path, scene)


func _on_sc_toggled(_button_pressed):
	if(get_node_or_null("object/collisions")):
		get_node("object/collisions").visible = _button_pressed



func _on_sen_toggled(_button_pressed):
	if(get_node_or_null("object/navigation")):
		get_node("object/navigation").visible = _button_pressed

func _on_tree_item_selected():
	var selected = $GUI/LeftPanel/enviroment/s/e/e/tree.get_selected()
	var path = selected.get_meta("path")
	if(get_node(path) is Node2D):
		$GUI/RightPanel/enviroment/s/e/e/node2d.hide()
		$GUI/RightPanel/enviroment/s/e/e/texture.hide()
		$GUI/RightPanel/enviroment/s/e/e/cstatic.hide()
		$GUI/RightPanel/enviroment/s/e/e/particle.hide()
		_initialize_node2d(path)
		$GUI/RightPanel/enviroment/s/e/e/node2d.show()
	else:
		$GUI/RightPanel/enviroment/s/e/e/node2d.hide()
		$GUI/RightPanel/enviroment/s/e/e/texture.hide()
		$GUI/RightPanel/enviroment/s/e/e/cstatic.hide()
		$GUI/RightPanel/enviroment/s/e/e/particle.hide()

var main_path = "object"

func _initialize_node2d(path):
	# Transform
	$GUI/RightPanel/enviroment/s/e/e/node2d/Transform/px/SpinBox.value = get_node(path).position.x
	$GUI/RightPanel/enviroment/s/e/e/node2d/Transform/py/SpinBox.value = get_node(path).position.y
	$GUI/RightPanel/enviroment/s/e/e/node2d/Transform/r/SpinBox.value = get_node(path).rotation
	$GUI/RightPanel/enviroment/s/e/e/node2d/Transform/sx/SpinBox.value = get_node(path).scale.x
	$GUI/RightPanel/enviroment/s/e/e/node2d/Transform/sy/SpinBox.value = get_node(path).scale.y
	$GUI/RightPanel/enviroment/s/e/e/node2d/Transform/z/SpinBox.value = get_node(path).z_index
	$GUI/RightPanel/enviroment/s/e/e/node2d/Transform/z2/z.pressed = get_node(path).z_as_relative
	# Visibility
	$GUI/RightPanel/enviroment/s/e/e/node2d/Visibility/v/v.pressed = get_node(path).visible
	$GUI/RightPanel/enviroment/s/e/e/node2d/Visibility/sm/sm.color = get_node(path).self_modulate
	$GUI/RightPanel/enviroment/s/e/e/node2d/Visibility/m/m.color = get_node(path).modulate
	$GUI/RightPanel/enviroment/s/e/e/node2d/Visibility/sbp/sbp.pressed = get_node(path).show_behind_parent
	main_path = path


func _on_Node2d_pos_x_value_changed(value):
	get_node(main_path).position.x = value


func _on_Node2d_pos_y_value_changed(value):
	get_node(main_path).position.y = value


func _on_Node2d_rotation_value_changed(value):
	get_node(main_path).rotation = value


func _on_Node2d_scale_x_value_changed(value):
	get_node(main_path).scale.x = value


func _on_Node2d_scale_y_value_changed(value):
	get_node(main_path).scale.y = value


func _on_Node2d_z_index_value_changed(value):
	get_node(main_path).z_index = value


func _on_Node2d_z_2_toggled(button_pressed):
	get_node(main_path).z_as_relative = button_pressed


func _on_Node2d_visible_toggled(button_pressed):
	get_node(main_path).visible = button_pressed


func _on_Node2d_modulate_color_changed(color):
	get_node(main_path).modulate = color


func _on_Node2d_self_modulate_color_changed(color):
	get_node(main_path).self_modulate = color


func _on_Node2d_sbp_toggled(button_pressed):
	get_node(main_path).show_behind_parent = button_pressed
