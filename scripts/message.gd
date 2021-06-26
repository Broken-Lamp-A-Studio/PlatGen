extends WindowDialog




func _on_ok_pressed():
	self.hide()

func show_info(text):
	self.window_title = "Info"
	$MarginContainer/VBoxContainer/Label.text = text
	popup_centered()

func show_warn(text):
	self.window_title = "Warning"
	$MarginContainer/VBoxContainer/Label.text = text
	popup_centered()

func show_error(text):
	self.window_title = "Error"
	$MarginContainer/VBoxContainer/Label.text = text
	popup_centered()
