extends Control

var help = "Available commands: \n  * help - displaying commands; \n * list nodes - listing all nodes from main node; \n * ls gui - loading new scene into init/envoirment (base workspace); \n * rm gui - removing nodes/scenes from init/envoirment; \n * clear - clearing console; \n * exit - closing console;"
var time = OS.get_datetime()
func _ready():
	if(get_node_or_null("selectscene")):
		$selectscene.add_filter("*.tscn ; Scene file")

func _input(event):
	if(event.is_action_pressed("ui_open_console")):
		$WindowDialog.popup()
		$WindowDialog/LineEdit.grab_focus()
	if(event.is_action_pressed("ui_accept") and $WindowDialog/LineEdit.focus_mode and $WindowDialog/LineEdit.text != ""):
		time = OS.get_datetime()
		var h = time["hour"]
		var m = time["minute"]
		var s = time["second"]
		var msg = "["+str(h)+":"+str(m)+":"+str(s)+"] >> "+$WindowDialog/LineEdit.text
		print("> "+msg)
		$WindowDialog/RichTextLabel.bbcode_text += "\n"+"[color=white]"+msg+"[/color]"
		exec_command($WindowDialog/LineEdit.text)
		$WindowDialog/LineEdit.text = ""
		$WindowDialog/LineEdit.release_focus()

func get_error(text):
	time = OS.get_datetime()
	var h = time["hour"]
	var m = time["minute"]
	var s = time["second"]
	var error = "["+str(h)+":"+str(m)+":"+str(s)+"] -!- "+text
	print(error)
	$WindowDialog/RichTextLabel.bbcode_text += "\n"+"[color=red]"+error+"[/color]"
	$WindowDialog.popup()

func get_warn(text):
	time = OS.get_datetime()
	var h = time["hour"]
	var m = time["minute"]
	var s = time["second"]
	var warn = "["+str(h)+":"+str(m)+":"+str(s)+"] -*- "+text
	print(warn)
	$WindowDialog/RichTextLabel.bbcode_text += "\n"+"[color=yellow]"+warn+"[/color]"

func get_msg(text):
	time = OS.get_datetime()
	var h = time["hour"]
	var m = time["minute"]
	var s = time["second"]
	var msg = "["+str(h)+":"+str(m)+":"+str(s)+"] -INFO- "+text
	print(msg)
	$WindowDialog/RichTextLabel.bbcode_text += "\n"+"[color=green]"+msg+"[/color]"

onready var rm2 = OS.get_system_time_msecs()

func exec_command(command):
	if(command == "close game"):
		get_tree().quit()
	elif(command == "ls gui" and get_node_or_null("selectscene") and OS.is_debug_build()):
		$selectscene.popup()
	elif(command == "list nodes"):
		get_msg(list_childs())
	elif(command == "clear"):
		$WindowDialog/RichTextLabel.bbcode_text = ""
	elif(command == "rm gui" and get_node_or_null("WindowDialog/rm") and OS.is_debug_build()):
		$WindowDialog/rm.visible = true
	elif(command == "help"):
		get_msg(help)
	elif(command == "exit"):
		$WindowDialog.hide()
	else:
		get_warn("Unknown command. Please check if command, what you are looking for is in 'help' command.")

func open_scene(path):
	var scene = load(path).instance()
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

