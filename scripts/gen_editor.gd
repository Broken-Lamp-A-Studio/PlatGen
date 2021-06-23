extends Control

var gen = ["CFG", {"biomes":[], "objects":[], "main_noise":{"octaves":4, "period":20.0, "persistence":0.8}, "other_noises":[], "biomes_meta":[], "objects_meta":[]}]
var SEED = 00000000
var save_path = ""

func _ready():
	$gui/left/content/VBoxContainer/MenuButton.get_popup().connect("index_pressed", self, "_menu_one_index_pressed")
	#gen = lib_main.rdfile("user://objects/generator.var", "var")
	

func get_metadata_from_biomes():
	if($gui/left/content/VBoxContainer/biomes/ItemList.get_item_count() != 0):
		var tick = 0
		var array = []
		while(tick != $gui/left/content/VBoxContainer/biomes/ItemList.get_item_count()):
			array += [$gui/left/content/VBoxContainer/biomes/ItemList.get_item_metadata(tick)]
			tick += 1
		return array
	else:
		return []

func get_metadata_from_objects():
	if($gui/left/content/VBoxContainer/objects/ItemList.get_item_count() != 0):
		var tick = 0
		var array = [
		]
		while(tick != $gui/left/content/VBoxContainer/objects/ItemList.get_item_count()):
			array += [$gui/left/content/VBoxContainer/objects/ItemList.get_item_metadata(tick)]
			tick += 1
		return array
	else:
		return []

func _on_load_file_selected(path):
	gen = lib_main.rdfile(path, "var")
	$"gui/CORNER up_left/Label".text = "Gen file path: '"+path+"'"
	$gui/left/content/VBoxContainer/biomes/ItemList.items = gen[1].biomes
	$gui/right/MarginContainer/VBoxContainer/octaves.value = gen[1].main_noise.octaves
	$gui/right/MarginContainer/VBoxContainer/period.value = gen[1].main_noise.period
	$gui/right/MarginContainer/VBoxContainer/persistence.value = gen[1].main_noise.persistence
	var tick = 0
	var imgtexture = ImageTexture.new()
	var image = Image.new()
	for data in gen[1].biomes_meta:
		$gui/left/content/VBoxContainer/biomes/ItemList.set_item_metadata(tick, data)
		image = Image.new()
		imgtexture = ImageTexture.new()
		image.crop(50, 50)
		image.convert(Image.FORMAT_RGB8)
		image.lock()
		image.fill(data.color)
		image.unlock()
		imgtexture.create_from_image(image)
		$gui/left/content/VBoxContainer/biomes/ItemList.set_item_icon(tick, imgtexture)
		tick += 1
	$gui/left/content/VBoxContainer/objects/ItemList.items = gen[1].objects
	tick = 0
	for data in gen[1].objects_meta:
		$gui/left/content/VBoxContainer/objects/ItemList.set_item_metadata(tick, data)
		image = Image.new()
		imgtexture = ImageTexture.new()
		image.crop(50, 50)
		image.convert(Image.FORMAT_RGB8)
		image.lock()
		image.fill(data.color)
		image.unlock()
		imgtexture.create_from_image(image)
		$gui/left/content/VBoxContainer/objects/ItemList.set_item_icon(tick, imgtexture)
		tick += 1
	# other noises



func _on_save_as_file_selected(path):
	gen[1].biomes = $gui/left/content/VBoxContainer/biomes/ItemList.items
	gen[1].objects = $gui/left/content/VBoxContainer/objects/ItemList.items
	gen[1].biomes_meta = get_metadata_from_biomes()
	gen[1].objects_meta = get_metadata_from_objects()
	lib_main.mkfile(path, "var", gen)
	save_path = path



func _on_gen_seed_pressed():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	$"gui/CORNER down_left/HBoxContainer/seed".text = "%d"%rng.randf_range(0, 99999999)
	SEED = int($"gui/CORNER down_left/HBoxContainer/seed".text)

func _on_seed_text_changed(new_text):
	SEED = int(new_text)


func _menu_one_index_pressed(index):
	if(index == 0):
		$gui/left/content/VBoxContainer/biomes.visible = false
		$gui/left/content/VBoxContainer/objects.visible = true
	else:
		$gui/left/content/VBoxContainer/objects.visible = false
		$gui/left/content/VBoxContainer/biomes.visible = true

var _object_index = 0

func _objects_item_selected(index):
	_object_index = index
	$Windows/block_settings/MarginContainer/VBoxContainer/blu/Block_lookup/texture.texture = $gui/left/content/VBoxContainer/objects/ItemList.get_item_icon(index)
	$Windows/block_settings/MarginContainer/VBoxContainer/blu/Block_lookup/name.text = $gui/left/content/VBoxContainer/objects/ItemList.get_item_text(index)
	var data = $gui/left/content/VBoxContainer/objects/ItemList.get_item_metadata(index)
	$Windows/block_settings/MarginContainer/VBoxContainer/scrollc/VBoxContainer/biomes/VBoxContainer/bb.items = $gui/left/content/VBoxContainer/biomes/ItemList.items
	$Windows/block_settings/MarginContainer/VBoxContainer/scrollc/VBoxContainer/biomes/VBoxContainer/bb.unselect_all()
	for object in data.biomes:
		$Windows/block_settings/MarginContainer/VBoxContainer/scrollc/VBoxContainer/biomes/VBoxContainer/bb.select(object)
	$Windows/block_settings/MarginContainer/VBoxContainer/scrollc/VBoxContainer/min_b_pos.value = data.render.pos.min
	$Windows/block_settings/MarginContainer/VBoxContainer/scrollc/VBoxContainer/max_b_pos.value = data.render.pos.max
	$Windows/block_settings/MarginContainer/VBoxContainer/scrollc/VBoxContainer/m_r_h_c.pressed = data.render.height.min.bool
	$Windows/block_settings/MarginContainer/VBoxContainer/scrollc/VBoxContainer/m_r_h.editable = data.render.height.min.bool
	$Windows/block_settings/MarginContainer/VBoxContainer/scrollc/VBoxContainer/m_r_h.value = data.render.height.min.value
	$Windows/block_settings/MarginContainer/VBoxContainer/scrollc/VBoxContainer/m_r_h_c2.pressed = data.render.height.max.bool
	$Windows/block_settings/MarginContainer/VBoxContainer/scrollc/VBoxContainer/m_r_h2.editable = data.render.height.max.bool
	$Windows/block_settings/MarginContainer/VBoxContainer/scrollc/VBoxContainer/m_r_h2.value = data.render.height.max.value
	$Windows/block_settings/MarginContainer/VBoxContainer/scrollc/VBoxContainer/m_r_h_w.pressed = data.render.width.min.bool
	$Windows/block_settings/MarginContainer/VBoxContainer/scrollc/VBoxContainer/m_r_w.editable = data.render.width.min.bool
	$Windows/block_settings/MarginContainer/VBoxContainer/scrollc/VBoxContainer/m_r_w.value = data.render.width.min.value
	$Windows/block_settings/MarginContainer/VBoxContainer/scrollc/VBoxContainer/m_r_h_w2.pressed = data.render.width.max.bool
	$Windows/block_settings/MarginContainer/VBoxContainer/scrollc/VBoxContainer/m_r_w2.editable = data.render.width.max.bool
	$Windows/block_settings/MarginContainer/VBoxContainer/scrollc/VBoxContainer/m_r_w2.value = data.render.width.max.value
	$Windows/block_settings.popup_centered()

func _objects_new_pressed():
	$Windows/nblock.popup_centered()


func _objects_delete_pressed():
	$"Windows/delete object/MarginContainer/ScrollContainer/VBoxContainer/ItemList".items = $gui/left/content/VBoxContainer/objects/ItemList.items
	$"Windows/delete object".popup_centered()

func _object_delete_list(index):
	$gui/left/content/VBoxContainer/objects/ItemList.remove_item(index)
	$"Windows/delete object".hide()
	$"Windows/delete object/MarginContainer/ScrollContainer/VBoxContainer/ItemList".remove_item(index)



var _biome_index = 0

func _biome_item_selected(index):
	_biome_index = index
	var data = $gui/left/content/VBoxContainer/biomes/ItemList.get_item_metadata(index)
	$"Windows/Biome settings/VBoxContainer/VBoxContainer/a".value = data.render.zone.x.min
	$"Windows/Biome settings/VBoxContainer/VBoxContainer/b".value = data.render.zone.x.max
	$"Windows/Biome settings/VBoxContainer/VBoxContainer/a2".value = data.render.zone.y.min
	$"Windows/Biome settings/VBoxContainer/VBoxContainer/b2".value = data.render.zone.y.max
	$"Windows/Biome settings/VBoxContainer/VBoxContainer/c".value = data.render.noise.min
	$"Windows/Biome settings/VBoxContainer/VBoxContainer/d".value = data.render.noise.max
	$"Windows/Biome settings/VBoxContainer/VBoxContainer/biome_name".text = $gui/left/content/VBoxContainer/biomes/ItemList.get_item_text(index)
	$"Windows/Biome settings".popup_centered()


func _new_biome_pressed():
	$Windows/nbiome.popup_centered()


func _biome_delete_pressed():
	$"Windows/delete biome/MarginContainer/ScrollContainer/VBoxContainer/ItemList".items = $gui/left/content/VBoxContainer/biomes/ItemList.items
	$"Windows/delete biome".popup_centered()

func _biome_delete_list(index):
	$gui/left/content/VBoxContainer/biomes/ItemList.remove_item(index)
	$"Windows/delete biome".hide()
	$"Windows/delete biome/MarginContainer/ScrollContainer/VBoxContainer/ItemList".remove_item(index)

### WINDOWS ###



func _biome_settings_a_value_changed(value):
	var data = $gui/left/content/VBoxContainer/biomes/ItemList.get_item_metadata(_biome_index)
	data.render.zone.x.min = value
	$gui/left/content/VBoxContainer/biomes/ItemList.set_item_metadata(_biome_index, data)


func _biome_settings_b_value_changed(value):
	var data = $gui/left/content/VBoxContainer/biomes/ItemList.get_item_metadata(_biome_index)
	data.render.zone.x.max = value
	$gui/left/content/VBoxContainer/biomes/ItemList.set_item_metadata(_biome_index, data)


func _biome_settings_atwo_value_changed(value):
	var data = $gui/left/content/VBoxContainer/biomes/ItemList.get_item_metadata(_biome_index)
	data.render.zone.y.min = value
	$gui/left/content/VBoxContainer/biomes/ItemList.set_item_metadata(_biome_index, data)


func _biome_settings_btwo_value_changed(value):
	var data = $gui/left/content/VBoxContainer/biomes/ItemList.get_item_metadata(_biome_index)
	data.render.zone.y.max = value
	$gui/left/content/VBoxContainer/biomes/ItemList.set_item_metadata(_biome_index, data)


func _biome_settings_c_value_changed(value):
	var data = $gui/left/content/VBoxContainer/biomes/ItemList.get_item_metadata(_biome_index)
	data.render.noise.min = value
	$gui/left/content/VBoxContainer/biomes/ItemList.set_item_metadata(_biome_index, data)


func _biome_settings_d_value_changed(value):
	var data = $gui/left/content/VBoxContainer/biomes/ItemList.get_item_metadata(_biome_index)
	data.render.noise.max = value
	$gui/left/content/VBoxContainer/biomes/ItemList.set_item_metadata(_biome_index, data)



func _object_settings_biome_multi_selected(_index, _selected):
	var data
	var tick = 0
	var s = []
	var init_array = []
	while(tick != $gui/left/content/VBoxContainer/biomes/ItemList.get_item_count()-1):
		s = $Windows/block_settings/MarginContainer/VBoxContainer/scrollc/VBoxContainer/biomes/VBoxContainer/bb.get_selected_items()
		#MainSymlink.console_output(s)
		init_array = Array(s)
		if(init_array.has(tick)):
			data = $gui/left/content/VBoxContainer/biomes/ItemList.get_item_metadata(tick)
			if(data.objects.has(_object_index) == false):
				data.objects += [_object_index]
			$gui/left/content/VBoxContainer/biomes/ItemList.set_item_metadata(tick, data)
			
		else:
			data = $gui/left/content/VBoxContainer/biomes/ItemList.get_item_metadata(tick)
			if(data.objects.has(_object_index)):
				data.objects.remove(data.objects.find(_object_index))
			$gui/left/content/VBoxContainer/biomes/ItemList.set_item_metadata(tick, data)
		tick += 1
	data = $gui/left/content/VBoxContainer/objects/ItemList.get_item_metadata(_object_index)
	data.biomes = $Windows/block_settings/MarginContainer/VBoxContainer/scrollc/VBoxContainer/biomes/VBoxContainer/bb.get_selected_items()
	$gui/left/content/VBoxContainer/objects/ItemList.set_item_metadata(_object_index, data)

func _object_settings_min_b_pos_value_changed(value):
	var data = $gui/left/content/VBoxContainer/objects/ItemList.get_item_metadata(_object_index)
	data.render.pos.min = value
	$gui/left/content/VBoxContainer/objects/ItemList.set_item_metadata(_object_index, data)

func _object_settings_max_b_pos_value_changed(value):
	var data = $gui/left/content/VBoxContainer/objects/ItemList.get_item_metadata(_object_index)
	data.render.pos.max = value
	$gui/left/content/VBoxContainer/objects/ItemList.set_item_metadata(_object_index, data)

func _object_settings_m_r_h_c_toggled(button_pressed):
	$Windows/block_settings/MarginContainer/VBoxContainer/scrollc/VBoxContainer/m_r_h.editable = button_pressed
	var data = $gui/left/content/VBoxContainer/objects/ItemList.get_item_metadata(_object_index)
	data.render.height.min.bool = button_pressed
	$gui/left/content/VBoxContainer/objects/ItemList.set_item_metadata(_object_index, data)

func _object_settings_m_r_h_text_changed(value):
	var data = $gui/left/content/VBoxContainer/objects/ItemList.get_item_metadata(_object_index)
	data.render.height.min.value = value
	$gui/left/content/VBoxContainer/objects/ItemList.set_item_metadata(_object_index, data)

func _object_settings_m_r_h_ctwo_toggled(button_pressed):
	$Windows/block_settings/MarginContainer/VBoxContainer/scrollc/VBoxContainer/m_r_h2.editable = button_pressed
	var data = $gui/left/content/VBoxContainer/objects/ItemList.get_item_metadata(_object_index)
	data.render.height.max.bool = button_pressed
	$gui/left/content/VBoxContainer/objects/ItemList.set_item_metadata(_object_index, data)

func _object_settings_m_r_htwo_value_changed(value):
	var data = $gui/left/content/VBoxContainer/objects/ItemList.get_item_metadata(_object_index)
	data.render.height.max.value = value
	$gui/left/content/VBoxContainer/objects/ItemList.set_item_metadata(_object_index, data)

func _object_settings_m_r_h_w_toggled(button_pressed):
	$Windows/block_settings/MarginContainer/VBoxContainer/scrollc/VBoxContainer/m_r_w.editable = button_pressed
	var data = $gui/left/content/VBoxContainer/objects/ItemList.get_item_metadata(_object_index)
	data.render.width.min.bool = button_pressed
	$gui/left/content/VBoxContainer/objects/ItemList.set_item_metadata(_object_index, data)

func _object_settings_m_r_w_value_changed(value):
	var data = $gui/left/content/VBoxContainer/objects/ItemList.get_item_metadata(_object_index)
	data.render.width.min.value = value
	$gui/left/content/VBoxContainer/objects/ItemList.set_item_metadata(_object_index, data)

func _object_settings_m_r_h_wtwo_toggled(button_pressed):
	$Windows/block_settings/MarginContainer/VBoxContainer/scrollc/VBoxContainer/m_r_w2.editable = button_pressed
	var data = $gui/left/content/VBoxContainer/objects/ItemList.get_item_metadata(_object_index)
	data.render.width.max.bool = button_pressed
	$gui/left/content/VBoxContainer/objects/ItemList.set_item_metadata(_object_index, data)

func _object_settings_m_r_wtwo_value_changed(value):
	var data = $gui/left/content/VBoxContainer/objects/ItemList.get_item_metadata(_object_index)
	data.render.width.max.value = value
	$gui/left/content/VBoxContainer/objects/ItemList.set_item_metadata(_object_index, data)





func _nbiome_create_pressed():
	if($"Windows/nbiome/MarginContainer/ScrollContainer/VBoxContainer/biomenm".text != ""):
		var cc = $Windows/nbiome/MarginContainer/ScrollContainer/VBoxContainer/ColorPicker.color
		var image = Image.new()
		image.crop(50, 50)
		image.convert(Image.FORMAT_RGB8)
		image.lock()
		image.set_pixel(0, 0, cc)
		image.set_pixel(49, 49, cc)
		image.fill(cc)
		image.unlock()
		image.save_png("user://test.png")
		var imgtexture = ImageTexture.new()
		imgtexture.create_from_image(image)
		var data_delta = {"color":cc, "render":{"noise":{"min":0, "max":0}, "zone":{"x":{"min":0, "max":0}, "y":{"min":0, "max":0}}}, "objects":[]}
		$gui/left/content/VBoxContainer/biomes/ItemList.add_item($Windows/nbiome/MarginContainer/ScrollContainer/VBoxContainer/biomenm.text, imgtexture)
		$gui/left/content/VBoxContainer/biomes/ItemList.set_item_metadata($gui/left/content/VBoxContainer/biomes/ItemList.get_item_count()-1, data_delta)
		$Windows/nbiome.hide()
		$Windows/nbiome/MarginContainer/ScrollContainer/VBoxContainer/biomenm.text = "biome"+str(OS.get_system_time_msecs())


func _nblock_select_path_pressed():
	$load_block.popup_centered()


func _nblock_create_pressed():
	if($Windows/nblock/MarginContainer/ScrollContainer/VBoxContainer/LineEdit.text != "" and $Windows/nblock/MarginContainer/ScrollContainer/VBoxContainer/HBoxContainer/path.text != ""):
		var cc = $Windows/nblock/MarginContainer/ScrollContainer/VBoxContainer/ColorPicker.color
		var image = Image.new()
		image.crop(50, 50)
		image.convert(Image.FORMAT_RGB8)
		image.lock()
		image.fill(cc)
		image.unlock()
		var imgtexture = ImageTexture.new()
		imgtexture.create_from_image(image)
		var data_delta = {"color":cc, "path":$Windows/nblock/MarginContainer/ScrollContainer/VBoxContainer/HBoxContainer/path.text, "biomes":[], "render":{"pos":{"max":0, "min":0}, "height":{"max":{"bool":false, "value":0}, "min":{"bool":false, "value":0}}, "width":{"min":{"bool":false, "value":0}, "max":{"bool":false, "value":0}}}}
		$gui/left/content/VBoxContainer/objects/ItemList.add_item($Windows/nblock/MarginContainer/ScrollContainer/VBoxContainer/LineEdit.text, imgtexture, true)
		$gui/left/content/VBoxContainer/objects/ItemList.set_item_metadata($gui/left/content/VBoxContainer/objects/ItemList.get_item_count()-1, data_delta)
		$Windows/nblock.hide()
		$Windows/nblock/MarginContainer/ScrollContainer/VBoxContainer/HBoxContainer/path.text = ""
		$Windows/nblock/MarginContainer/ScrollContainer/VBoxContainer/LineEdit.text = "object"+str(OS.get_system_time_msecs())

func _on_load_block_file_selected(path):
	$Windows/nblock/MarginContainer/ScrollContainer/VBoxContainer/HBoxContainer/path.text = path






func _on_load_gen_pressed():
	$load.popup_centered()


func _on_save_as_gen_pressed():
	$save_as.popup_centered()


func _on_save_gen_pressed():
	if(save_path != ""):
		lib_main.mkfile(save_path, "var", gen)
	else:
		_on_save_as_gen_pressed()


func _on_exit_pressed():
	get_tree().quit()

var gen_texture = OpenSimplexNoise.new()
var gen_image = Image.new()

var tick2 = 0
var x2 = 0
var y2 = 0


func _render_world():
	var render_time = OS.get_system_time_msecs()
	#$"gui/CORNER down/MarginContainer/HBoxContainer/MarginContainer/GEN_INFO".text = "Initializing..."
	gen[1].biomes = $gui/left/content/VBoxContainer/biomes/ItemList.items
	gen[1].objects = $gui/left/content/VBoxContainer/objects/ItemList.items
	gen[1].biomes_meta = get_metadata_from_biomes()
	gen[1].objects_meta = get_metadata_from_objects()
	gen_texture = GeneratorLib.get_gen_texture(SEED, gen[1].main_noise.octaves, gen[1].main_noise.period, gen[1].main_noise.persistence)
	gen_image = Image.new()
	gen_image.crop(get_viewport_rect().size.x, get_viewport_rect().size.y)
	gen_image.convert(Image.FORMAT_RGB8)
	gen_image.lock()
	tick2 = 0
	x2 = 1
	y2 = 1
	while(tick2 != (get_viewport_rect().size.x*get_viewport_rect().size.y)):
		if(x2 == get_viewport_rect().size.x):
			y2 += 1
			x2 = 1
		else:
			x2 += 1
		#$"gui/CORNER down/MarginContainer/HBoxContainer/MarginContainer/GEN_INFO".text = "Rendering image ("+str(tick2)+"/"+str(get_viewport_rect().size.x*get_viewport_rect().size.y)+")"
		var color = _initialize_object(x2, y2)
		if(color != null):
			if not(x2-1 > get_viewport_rect().size.x and y2-1 > get_viewport_rect().size.y):
				gen_image.set_pixel(x2-1, y2-1, color)
		tick2 += 1
		if(tick2 >= (get_viewport_rect().size.x*get_viewport_rect().size.y)):
			gen_image.unlock()
			var imgtexture = ImageTexture.new()
			imgtexture.create_from_image(gen_image)
			$render.texture = imgtexture
			$"gui/CORNER down/MarginContainer/HBoxContainer/MarginContainer/GEN_INFO".text = "Rendered("+str((round((OS.get_system_time_msecs()-render_time)/10))/100)+"s)!"
			break

func _initialize_object(x, y):
	var noise = gen_texture.get_noise_2d(x, y)
	var rng = RandomNumberGenerator.new()
	rng.seed = SEED
	rng.randomize()
	var biomes_tick = 0
	var biomes = []
	for biome_cfg in gen[1].biomes_meta:
		if(noise > biome_cfg.render.noise.min and biome_cfg.render.noise.max > noise):
			if(biome_cfg.render.zone.x.min != 0 and biome_cfg.render.zone.x.max != 0):
				if(biome_cfg.render.zone.y.min != 0 and biome_cfg.render.zone.y.max != 0):
					if(x > biome_cfg.render.zone.x.min and x < biome_cfg.render.zone.x.max and y > biome_cfg.render.zone.y.min and y < biome_cfg.render.zone.y.max):
						biomes += [biomes_tick]
				else:
					if(x > biome_cfg.render.zone.x.min and x < biome_cfg.render.zone.x.max):
						biomes += [biomes_tick]
			else:
				if(biome_cfg.render.zone.y.min != 0 and biome_cfg.render.zone.y.max != 0):
					if(y > biome_cfg.render.zone.y.min and y < biome_cfg.render.zone.y.max):
						biomes += [biomes_tick]
				else:
					biomes += [biomes_tick]
		biomes_tick += 1
	
	if(biomes.size() > 0):
		var biome_select = biomes[round(rng.randf_range(0, biomes.size()-1))]
		
		
		var objects_tick = 0
		var objects = []
		for object_cfg in gen[1].objects_meta:
			if(Array(object_cfg.biomes).has(biome_select)):
				if(noise > object_cfg.render.pos.min and object_cfg.render.pos.max > noise):
					if(object_cfg.render.height.max.bool):
						if(y < object_cfg.render.height.max.value):
							if(object_cfg.render.height.min.bool):
								if(y > object_cfg.render.height.min.value):
									if(object_cfg.render.width.max.bool):
										if(x < object_cfg.render.width.max.value):
											if(object_cfg.render.width.min.bool):
												if(x > object_cfg.render.width.min.value):
													objects += [objects_tick]
											else:
												objects += [objects_tick]
									else:
										if(object_cfg.render.width.min.bool):
											if(x > object_cfg.render.width.min.value):
												objects += [objects_tick]
										else:
											objects += [objects_tick]
							else:
								if(object_cfg.render.width.max.bool):
									if(x < object_cfg.render.width.max.value):
										if(object_cfg.render.width.min.bool):
											if(x > object_cfg.render.width.min.value):
												objects += [objects_tick]
										else:
											objects += [objects_tick]
								else:
									if(object_cfg.render.width.min.bool):
										if(x > object_cfg.render.width.min.value):
											objects += [objects_tick]
									else:
										objects += [objects_tick]
					else:
						if(object_cfg.render.height.min.bool):
							if(y > object_cfg.render.height.min.value):
								if(object_cfg.render.width.max.bool):
									if(x < object_cfg.render.width.max.value):
										if(object_cfg.render.width.min.bool):
											if(x > object_cfg.render.width.min.value):
												objects += [objects_tick]
										else:
											objects += [objects_tick]
								else:
									if(object_cfg.render.width.min.bool):
										if(x > object_cfg.render.width.min.value):
											objects += [objects_tick]
									else:
										objects += [objects_tick]
						else:
							if(object_cfg.render.width.max.bool):
								if(x < object_cfg.render.width.max.value):
									if(object_cfg.render.width.min.bool):
										if(x > object_cfg.render.width.min.value):
											objects += [objects_tick]
									else:
										objects += [objects_tick]
							else:
								if(object_cfg.render.width.min.bool):
									if(x > object_cfg.render.width.min.value):
										objects += [objects_tick]
								else:
									objects += [objects_tick]
			objects_tick += 1
		if(objects.size() > 0):
			var object_select = objects[round(rng.randf_range(0, objects.size()-1))]
			return gen[1].objects_meta[object_select].color
		else:
			return null
	else:
		return null



func _on_refresh_render_pressed():
	_render_world()


func _on_octaves_value_changed(value):
	gen[1].main_noise.octaves = value


func _on_period_value_changed(value):
	gen[1].main_noise.period = value


func _on_persistence_value_changed(value):
	gen[1].main_noise.persistence = value
