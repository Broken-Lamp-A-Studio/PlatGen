extends Control

var help = "Available commands: \n  * help - displaying commands; \n * list nodes - listing all nodes from main node; \n * ls gui - loading new scene into init/envoirment (base workspace); \n * rm gui - removing nodes/scenes from init/envoirment; \n * clear - clearing console; \n * exit - closing console;"
func _ready():
	if(get_node_or_null("selectscene")):
		$selectscene.add_filter("*.tscn ; Scene file")

func _input(event):
	if(event.is_action_pressed("ui_open_console")):
		$WindowDialog.popup_centered()
		$"WindowDialog/MarginContainer/MarginContainer2/LineEdit".grab_focus()
	if(event.is_action_pressed("ui_accept") and $"WindowDialog/MarginContainer/MarginContainer2/LineEdit".focus_mode and $"WindowDialog/MarginContainer/MarginContainer2/LineEdit".text != ""):
		var msg = "["+lib_main.generate_time()+"] >> "+$"WindowDialog/MarginContainer/MarginContainer2/LineEdit".text
		print("> "+msg)
		$"WindowDialog/MarginContainer/MarginContainer/RichTextLabel".bbcode_text += "\n"+"[color=white]"+msg+"[/color]"
		exec_command($"WindowDialog/MarginContainer/MarginContainer2/LineEdit".text)
		$"WindowDialog/MarginContainer/MarginContainer2/LineEdit".text = ""
		$"WindowDialog/MarginContainer/MarginContainer2/LineEdit".release_focus()
	if(event.is_action_pressed("ui_select") and $WindowDialog/MarginContainer/MarginContainer2/LineEdit.focus_mode):
		$WindowDialog/MarginContainer/MarginContainer2/LineEdit.release_focus()
	if(event.is_action_pressed("ui_open_chat") and $WindowDialog.visible):
		$WindowDialog/MarginContainer/MarginContainer2/LineEdit.grab_focus()
		#$WindowDialog/MarginContainer/MarginContainer2/LineEdit.text.left($WindowDialog/MarginContainer/MarginContainer2/LineEdit.text.length()-1)

func _process(_delta):
	_resize_container()

func get_error(text):
	var error = "["+lib_main.generate_time()+"] -!- "+text
	print(error)
	$"WindowDialog/MarginContainer/MarginContainer/RichTextLabel".bbcode_text += "\n"+"[color=red]"+error+"[/color]"
	$WindowDialog/MarginContainer/MarginContainer/RichTextLabel.scroll_to_line($WindowDialog/MarginContainer/MarginContainer/RichTextLabel.get_line_count()-1)
	$WindowDialog.popup()

func get_warn(text):
	var warn = "["+lib_main.generate_time()+"] -*- "+text
	print(warn)
	$"WindowDialog/MarginContainer/MarginContainer/RichTextLabel".bbcode_text += "\n"+"[color=yellow]"+warn+"[/color]"
	$WindowDialog/MarginContainer/MarginContainer/RichTextLabel.scroll_to_line($WindowDialog/MarginContainer/MarginContainer/RichTextLabel.get_line_count()-1)
func get_msg(text):
	var msg = "["+lib_main.generate_time()+"] -INFO- "+text
	print(msg)
	$"WindowDialog/MarginContainer/MarginContainer/RichTextLabel".bbcode_text += "\n"+"[color=green]"+msg+"[/color]"
	$WindowDialog/MarginContainer/MarginContainer/RichTextLabel.scroll_to_line($WindowDialog/MarginContainer/MarginContainer/RichTextLabel.get_line_count()-1)

onready var rm2 = OS.get_system_time_msecs()

func exec_command(command):
	if(command == "close game"):
		get_tree().quit()
	elif(command == "ls gui" and get_node_or_null("selectscene") and OS.is_debug_build()):
		$selectscene.popup()
	elif(command == "list nodes"):
		get_msg(list_childs())
	elif(command == "clear"):
		$"WindowDialog/MarginContainer/MarginContainer/RichTextLabel".bbcode_text = ""
	elif(command == "rm gui" and get_node_or_null("WindowDialog/rm") and OS.is_debug_build()):
		$WindowDialog/rm.visible = true
	elif(command == "help"):
		get_msg(help)
	elif(command == "exit"):
		$WindowDialog.hide()
	else:
		get_warn("Unknown command. Please check if command, what you are looking for is in 'help' command.")

func open_scene(path):
	var scene = load(str(path)).instance()
	get_tree().get_root().get_node("init/envoirment").add_child(scene)
	get_msg("Scene '"+path+"' loaded into init/envoirment.")

func _on_selectscene_file_selected(path):
	var dir = Directory.new()
	#print(path)
	get_msg("Loading scene: "+path)
	if(dir.file_exists(path) and path.get_extension() == "tscn"):
		open_scene(path)
	else:
		get_error("Failed to load file/scene: "+path)
	#$selectscene.clear_filters()
	$selectscene.deselect_items()

func list_childs():
	var childs = get_tree().get_root().get_node("init").get_children()
	var t = 0
	var text = "List of nodes of main node:"
	while(t != childs.size()):
		text += "\n - 'init/"+childs[t].name+"';"
		text += list_actual_path("init/"+childs[t].name)
		t += 1
	return text

func list_actual_path(parent):
	var childs = get_tree().get_root().get_node(parent).get_children()
	var t = 0
	var text = ""
	while(t != childs.size()):
		text += "\n - '"+parent+"/"+childs[t].name+"';"
		var text2 = list_actual_path(parent+"/"+childs[t].name)
		text += text2
		#print(text)
		t += 1
	return text


func _on_ok_pressed():
	remove_node($WindowDialog/rm/LineEdit.text)
	$WindowDialog/rm/LineEdit.text = ""
	$WindowDialog/rm.visible = false
	
func remove_node(path):
	if(get_tree().get_root().get_node_or_null("init/envoirment/"+path) and path != ""):
		get_tree().get_root().get_node_or_null("init/envoirment/"+path).queue_free()
		get_msg("Node '"+path+"' successfully removed!")
	else:
		get_error("Failed to remove '"+path+"' - node not found!")

func _resize_container():
	$WindowDialog/MarginContainer.rect_size = $WindowDialog.rect_size
	#$WindowDialog/MarginContainer/VBoxContainer/RichTextLabel.rect_size.y = $WindowDialog.rect_size.y-$WindowDialog/rm/LineEdit.rect_size.y-20
