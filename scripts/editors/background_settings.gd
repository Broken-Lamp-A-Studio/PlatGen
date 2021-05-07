extends Control


func _process(_delta):
	$WindowDialog/Panel.rect_size = $WindowDialog/Panel/ColorPicker.rect_size*1.05
	$WindowDialog.rect_size = $WindowDialog/Panel.rect_size

