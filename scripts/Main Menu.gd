extends CenterContainer


func _ready():
	if(OS.get_name() == "X11"):
		$MarginContainer/logo/gui/ScrollContainer/VBoxContainer/Exit/exit.text = "Exit to Linux"
	elif(OS.get_name() == "Windows"):
		$MarginContainer/logo/gui/ScrollContainer/VBoxContainer/Exit/exit.text = "Exit to Windows"
	elif(OS.get_name() == "OSX"):
		$MarginContainer/logo/gui/ScrollContainer/VBoxContainer/Exit/exit.text = "Exit to MacOS X"
	# Graphics settings load
	_load_graphics_settings()
	_load_sound_settings()
	
	if(MainSymlink.verify_sound_input):
		$MarginContainer/a/settings_sound/s/e/e/mi/OptionButton.selected = AudioServer.capture_get_device_list().find(AudioServer.capture_get_device())
	else:
		MainSymlink.show_warn("Last selected Input device not found!")
	if(MainSymlink.verify_sound_output):
		$MarginContainer/a/settings_sound/s/e/e/mi2/OptionButton.selected = AudioServer.get_device_list().find(AudioServer.device)
	else:
		MainSymlink.show_warn("Last selected Output device not found!")
	
	#AudioServer.get_bus_effect(AudioServer.get_bus_index("MainVoice"), 0).set_recording_active(true)

func _on_exit_pressed():
	get_tree().quit()

# Settings - Graphics




func _on_fullscreen_toggled(button_pressed):
	OS.window_fullscreen = button_pressed
	$MarginContainer/a/settings_graphics/s/e/e/r/x.editable = not(button_pressed)
	$MarginContainer/a/settings_graphics/s/e/e/r/y.editable = not(button_pressed)
	$MarginContainer/a/settings_graphics/s/e/e/r/x.value = OS.window_size.x
	$MarginContainer/a/settings_graphics/s/e/e/r/y.value = OS.window_size.y
	MainSymlink._save_graphics_settings()


func _on_g_pressed():
	$MarginContainer/a/settings_graphics.visible = not($MarginContainer/a/settings_graphics.visible)
	$MarginContainer/a/settings_general.visible = false
	$"MarginContainer/a/settings_sound".visible = false


func _on_window_size_x_value_changed(value):
	OS.window_size.x = value
	MainSymlink._save_graphics_settings()


func _on_window_size_y_value_changed(value):
	OS.window_size.y = value
	MainSymlink._save_graphics_settings()


func _on_always_stay_on_top_toggled(button_pressed):
	OS.set_window_always_on_top(button_pressed)
	MainSymlink._save_graphics_settings()


func _on_vsync_toggled(button_pressed):
	OS.vsync_enabled = button_pressed
	MainSymlink._save_graphics_settings()


func _on_screen_orientation_value_changed(value):
	OS.screen_orientation = value
	MainSymlink._save_graphics_settings()


func _on_window_borderless_toggled(button_pressed):
	OS.window_borderless = button_pressed
	MainSymlink._save_graphics_settings()


func _on_backup_graphics_settings_pressed():
	OS.window_fullscreen = false
	OS.window_size.x = 800
	OS.window_size.y = 600
	OS.set_window_always_on_top(false)
	OS.vsync_enabled = true
	OS.screen_orientation = 0
	OS.window_borderless = false
	$MarginContainer/a/settings_graphics/s/e/e/r/x.editable = not(OS.window_fullscreen)
	$MarginContainer/a/settings_graphics/s/e/e/r/y.editable = not(OS.window_fullscreen)
	$MarginContainer/a/settings_graphics/s/e/e/r/x.value = OS.window_size.x
	$MarginContainer/a/settings_graphics/s/e/e/r/y.value = OS.window_size.y
	MainSymlink._save_graphics_settings()
	_load_graphics_settings()

func _load_graphics_settings():
	var data = MainSymlink.graphics_settings
	$MarginContainer/a/settings_graphics/s/e/e/wb/wb.pressed = data.border
	$MarginContainer/a/settings_graphics/s/e/e/f/fullscreen.pressed = data.window_fullscreen
	$MarginContainer/a/settings_graphics/s/e/e/r/x.value = data.window_size_x
	$MarginContainer/a/settings_graphics/s/e/e/r/y.value = data.window_size_y
	$MarginContainer/a/settings_graphics/s/e/e/at/at.pressed = data.window_top
	$MarginContainer/a/settings_graphics/s/e/e/vsync/vsync.pressed = data.vsync
	$MarginContainer/a/settings_graphics/s/e/e/so/so.value = data.screen_orientation
	$MarginContainer/a/settings_graphics/s/e/e/r/x.editable = not(data.window_fullscreen)
	$MarginContainer/a/settings_graphics/s/e/e/r/y.editable = not(data.window_fullscreen)

# Settings General

func _on_settings_general_pressed():
	$MarginContainer/a/settings_general.visible = not($MarginContainer/a/settings_general.visible)
	$MarginContainer/a/settings_graphics.visible = false
	$"MarginContainer/a/settings_sound".visible = false


func _on_processor_mode_toggled(button_pressed):
	OS.low_processor_usage_mode = button_pressed
	MainSymlink._save_general_settings()


func _on_backup_path_changed(new_text):
	MainSymlink.backup_path = new_text
	MainSymlink._save_general_settings()


func _on_backup_general_pressed():
	OS.low_processor_usage_mode = false
	MainSymlink.backup_path = "user://backup/"
	MainSymlink._save_general_settings()
	_load_general_settings()

func _load_general_settings():
	var data = MainSymlink.general_settings
	$MarginContainer/a/settings_general/s/e/e/p/p.pressed = data.processor
	$MarginContainer/a/settings_general/s/e/e/bu/bu.text = data.backup

# Settings - Sound

func _on_Master_Sound_value_changed(value):
	var index = AudioServer.get_bus_index("Master")
	var real_value = 0.86*value-80
	AudioServer.set_bus_volume_db(index, real_value)


func _on_Music_Sound_value_changed(value):
	var index = AudioServer.get_bus_index("Game_music")
	var real_value = 0.86*value-80
	AudioServer.set_bus_volume_db(index, real_value)


func _on_Effects_Sound_value_changed(value):
	var index = AudioServer.get_bus_index("Effects")
	var real_value = 0.86*value-80
	AudioServer.set_bus_volume_db(index, real_value)


func _on_Inv_Effects_Sound_value_changed(value):
	var index = AudioServer.get_bus_index("Inv_effects")
	var real_value = 0.86*value-80
	AudioServer.set_bus_volume_db(index, real_value)


func _on_Machines_Sound_value_changed(value):
	var index = AudioServer.get_bus_index("Machines")
	var real_value = 0.86*value-80
	AudioServer.set_bus_volume_db(index, real_value)


func _on_Videos_Sound_value_changed(value):
	var index = AudioServer.get_bus_index("Videos")
	var real_value = 0.86*value-80
	AudioServer.set_bus_volume_db(index, real_value)


func _on_Monsters_Sound_value_changed(value):
	var index = AudioServer.get_bus_index("Monsters")
	var real_value = 0.86*value-80
	AudioServer.set_bus_volume_db(index, real_value)


func _on_Dialogs_Sound_value_changed(value):
	var index = AudioServer.get_bus_index("Dialogs")
	var real_value = 0.86*value-80
	AudioServer.set_bus_volume_db(index, real_value)


func _on_Voicechat_Sound_value_changed(value):
	var index = AudioServer.get_bus_index("Voicechat")
	var real_value = 0.86*value-80
	AudioServer.set_bus_volume_db(index, real_value)


func _on_Voice_Sound_value_changed(value):
	var index = AudioServer.get_bus_index("MainVoice")
	var real_value = 0.86*value-80
	AudioServer.set_bus_volume_db(index, real_value)


func _on_Microphone_status_item_selected(index):
	MainSymlink.sound_settings.microphone = index
	MainSymlink._save_sound_settings()


func _on_Microphone_Input_item_selected(index):
	AudioServer.capture_set_device($"MarginContainer/a/settings_sound/s/e/e/mi/OptionButton".get_item_text(index))
	MainSymlink._save_sound_settings()


func _on_Audio_Output_item_selected(index):
	AudioServer.device = $"MarginContainer/a/settings_sound/s/e/e/mi2/OptionButton".get_item_text(index)
	MainSymlink._save_sound_settings()


func _on_Sound_Settings_reset_pressed():
	$"MarginContainer/a/settings_sound/s/e/e/mi/OptionButton".selected = 0
	MainSymlink.sound_settings.microphone = 0
	
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), 0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Game_music"), 0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Effects"), 0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Inv_effects"), 0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Machines"), 0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Videos"), 0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Monsters"), 0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Dialogs"), 0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Voicechat"), 0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("MainVoice"), 0)
	
	$MarginContainer/a/settings_sound/s/e/e/m/HSlider.value = _read_sound_value(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")))
	$"MarginContainer/a/settings_sound/s/e/e/music/HSlider".value = _read_sound_value(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Game_music")))
	$"MarginContainer/a/settings_sound/s/e/e/effects/HSlider".value =_read_sound_value(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Effects")))
	$"MarginContainer/a/settings_sound/s/e/e/inv_effects/HSlider".value = _read_sound_value(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Inv_effects")))
	$"MarginContainer/a/settings_sound/s/e/e/machines/HSlider".value = _read_sound_value(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Machines")))
	$"MarginContainer/a/settings_sound/s/e/e/videos/HSlider".value = _read_sound_value(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Videos")))
	$"MarginContainer/a/settings_sound/s/e/e/monsters/HSlider".value = _read_sound_value(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Monsters")))
	$"MarginContainer/a/settings_sound/s/e/e/dialogs/HSlider".value = _read_sound_value(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Dialogs")))
	$"MarginContainer/a/settings_sound/s/e/e/voicechat/HSlider".value = _read_sound_value(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Voicechat")))
	$"MarginContainer/a/settings_sound/s/e/e/voice/HSlider".value = _read_sound_value(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("MainVoice")))
	
	MainSymlink._save_sound_settings()


func _on_save_sound_slider():
	MainSymlink._save_sound_settings()

func _read_sound_value(value):
	return (value+80)/0.86

func _load_sound_settings():
	$MarginContainer/a/settings_sound/s/e/e/m/HSlider.value = _read_sound_value(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")))
	$"MarginContainer/a/settings_sound/s/e/e/music/HSlider".value = _read_sound_value(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Game_music")))
	$"MarginContainer/a/settings_sound/s/e/e/effects/HSlider".value =_read_sound_value(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Effects")))
	$"MarginContainer/a/settings_sound/s/e/e/inv_effects/HSlider".value = _read_sound_value(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Inv_effects")))
	$"MarginContainer/a/settings_sound/s/e/e/machines/HSlider".value = _read_sound_value(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Machines")))
	$"MarginContainer/a/settings_sound/s/e/e/videos/HSlider".value = _read_sound_value(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Videos")))
	$"MarginContainer/a/settings_sound/s/e/e/monsters/HSlider".value = _read_sound_value(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Monsters")))
	$"MarginContainer/a/settings_sound/s/e/e/dialogs/HSlider".value = _read_sound_value(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Dialogs")))
	$"MarginContainer/a/settings_sound/s/e/e/voicechat/HSlider".value = _read_sound_value(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Voicechat")))
	$"MarginContainer/a/settings_sound/s/e/e/voice/HSlider".value = _read_sound_value(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("MainVoice")))
	
	$"MarginContainer/a/settings_sound/s/e/e/mi/OptionButton".clear()
	for audio_name in AudioServer.capture_get_device_list():
		$"MarginContainer/a/settings_sound/s/e/e/mi/OptionButton".add_item(audio_name)
	
	$"MarginContainer/a/settings_sound/s/e/e/mi2/OptionButton".clear()
	for audio_name in AudioServer.get_device_list():
		$"MarginContainer/a/settings_sound/s/e/e/mi2/OptionButton".add_item(audio_name)
	
	$"MarginContainer/a/settings_sound/s/e/e/mi/OptionButton".selected = MainSymlink.sound_settings.microphone


func _on_settings_sound_pressed():
	$"MarginContainer/a/settings_sound".visible = not($"MarginContainer/a/settings_sound".visible)
	$"MarginContainer/a/settings_general".visible = false
	$"MarginContainer/a/settings_graphics".visible = false

var record

func _on_micrphone_read():
	record = AudioServer.get_bus_effect(AudioServer.get_bus_index("MainVoice"), 0).get_recording()
	
	AudioServer.get_bus_effect(AudioServer.get_bus_index("MainVoice"), 0).set_recording_active(false)
	AudioServer.get_bus_effect(AudioServer.get_bus_index("MainVoice"), 0).set_recording_active(true)
	
	$"MarginContainer/a/settings_sound/s/e/e/p/ProgressBar".value = 0

# Settings  - Control

func _on_settings_control_pressed():
	pass # Replace with function body.
