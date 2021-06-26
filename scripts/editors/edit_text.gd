extends WindowDialog


func _process(_delta):
	$MarginContainer.rect_size = self.rect_size

func get_text():
	return $MarginContainer/TextEdit.text
