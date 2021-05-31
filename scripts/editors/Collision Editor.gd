extends Control


onready var symlink = get_node("/root/MainSymlink")

var symlink2 = false
var path = ""

func _process(_delta):
	if(symlink2 != symlink.collision_editor):
		if(symlink.collision_editor):
			$collisionlist.popup_centered_minsize()
		else:
			$collisionlist.hide()
			$editcollision.hide()
		symlink2 = symlink.collision_editor

var shape_selected = 0

func _on_nc_pressed():
	$newcollision.popup_centered_minsize()


func _on_create_pressed():
	if($newcollision/name/LineEdit.text != ""):
		var json = {}
		if(shape_selected == 0):
			json = {"name":$newcollision/name/LineEdit.text, "size":{"x":10, "y":10}, "type":"rectangle", "interact":{"layer":["player"], "mask":["block"]}, "position":{"x":0, "y":0}}
		elif(shape_selected == 1):
			json = {"name":$newcollision/name/LineEdit.text, "size":{"r":5}, "type":"circle", "interact":{"layer":["player"], "mask":["block"]}, "position":{"x":0, "y":0}}
		elif(shape_selected == 2):
			json = {"name":$newcollision/name/LineEdit.text, "pos":{"one":{"x":10, "y":10}, "two":{"x":20, "y":20}}, "type":"line", "interact":{"layer":["player"], "mask":["block"]}, "position":{"x":0, "y":0}}
		$collisionlist/collisions.add_item($newcollision/name/LineEdit.text, $newcollision/type/ItemList.get_item_icon(shape_selected))
		$collisionlist/collisions.set_item_metadata($collisionlist/collisions.get_item_count()-1, json)
		$newcollision.hide()
		$newcollision/name/LineEdit.text = ""


func _on_ItemList_item_selected(index):
	shape_selected = index

var selected = -1

func _on_rc_pressed():
	#print($collisionlist/collisions.items)
	if not(selected == -1):
		#print($collisionlist/collisions.get_item_metadata(selected))
		$collisionlist/collisions.remove_item(selected)
		selected = -1


var collision_data = {}

func _on_collisions_item_selected(index):
	selected = index
	#$collisionlist.hide()
	collision_data = $collisionlist/collisions.get_item_metadata(index)
	if(collision_data.type == "rectangle"):
		$"editcollision/Pos X1/slider".editable = false
		$"editcollision/Pos X2/slider".editable = false
		$"editcollision/Pos Y1/slider".editable = false
		$"editcollision/Pos Y2/slider".editable = false
		$"editcollision/Size R/slider".editable = false
		$"editcollision/Size X/slider".editable = true
		$"editcollision/Size Y/slider".editable = true
		$"editcollision/Size X/slider".value = collision_data.size.x
		$"editcollision/Size Y/slider".value = collision_data.size.y
	elif(collision_data.type == "circle"):
		$"editcollision/Pos X1/slider".editable = false
		$"editcollision/Pos X2/slider".editable = false
		$"editcollision/Pos Y1/slider".editable = false
		$"editcollision/Pos Y2/slider".editable = false
		$"editcollision/Size R/slider".editable = true
		$"editcollision/Size X/slider".editable = false
		$"editcollision/Size Y/slider".editable = false
		$"editcollision/Size R/slider".value = collision_data.size.r
	else:
		$"editcollision/Pos X1/slider".editable = true
		$"editcollision/Pos X2/slider".editable = true
		$"editcollision/Pos Y1/slider".editable = true
		$"editcollision/Pos Y2/slider".editable = true
		$"editcollision/Size R/slider".editable = false
		$"editcollision/Size X/slider".editable = false
		$"editcollision/Size Y/slider".editable = false
		$"editcollision/Pos X1/slider".value = collision_data.pos.one.x
		$"editcollision/Pos Y1/slider".value = collision_data.pos.one.y
		$"editcollision/Pos X2/slider".value = collision_data.pos.two.x
		$"editcollision/Pos Y2/slider".value = collision_data.pos.two.y
	$"editcollision/Position X/slider".value = collision_data.position.x
	$"editcollision/Position Y/slider".value = collision_data.position.y


func _on_ec_pressed():
	if(selected != -1):
		collision_data = $collisionlist/collisions.get_item_metadata(selected)
		$editcollision.popup_centered_minsize()


func _on_size_x_slider_value_changed(value):
	var data = $collisionlist/collisions.get_item_metadata(selected)
	data.size.x = value
	$collisionlist/collisions.set_item_metadata(selected, data)


func _on_size_y_slider_value_changed(value):
	var data = $collisionlist/collisions.get_item_metadata(selected)
	data.size.y = value
	$collisionlist/collisions.set_item_metadata(selected, data)


func _on_size_r_slider_value_changed(value):
	var data = $collisionlist/collisions.get_item_metadata(selected)
	data.size.r = value
	$collisionlist/collisions.set_item_metadata(selected, data)


func _on_pos_x_one_slider_value_changed(value):
	var data = $collisionlist/collisions.get_item_metadata(selected)
	data.pos.one.x = value
	$collisionlist/collisions.set_item_metadata(selected, data)


func _on_pos_y_one_slider_value_changed(value):
	var data = $collisionlist/collisions.get_item_metadata(selected)
	data.pos.one.y = value
	$collisionlist/collisions.set_item_metadata(selected, data)

func _on_pos_x_two_slider_value_changed(value):
	var data = $collisionlist/collisions.get_item_metadata(selected)
	data.pos.two.x = value
	$collisionlist/collisions.set_item_metadata(selected, data)

func _on_pos_y_two_slider_value_changed(value):
	var data = $collisionlist/collisions.get_item_metadata(selected)
	data.pos.two.y = value
	$collisionlist/collisions.set_item_metadata(selected, data)


func _on_position_x_slider_value_changed(value):
	var data = $collisionlist/collisions.get_item_metadata(selected)
	data.position.x = value
	$collisionlist/collisions.set_item_metadata(selected, data)


func _on_position_y_slider_value_changed(value):
	var data = $collisionlist/collisions.get_item_metadata(selected)
	data.position.y = value
	$collisionlist/collisions.set_item_metadata(selected, data)

