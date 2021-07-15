extends Node2D


func _ready():
	set_process(false)
	set_process_input(false)
	set_physics_process(false)


func _on_down_body_entered(_body):
	$particles/down.one_shot = false




func _on_down_body_exited(_body):
	$particles/down.one_shot = true


func _on_top_body_entered(_body):
	$particles/up.one_shot = false


func _on_top_body_exited(_body):
	$particles/up.one_shot = true


func _on_right_body_entered(_body):
	$particles/right.one_shot = false


func _on_right_body_exited(_body):
	$particles/right.one_shot = true


func _on_left_body_entered(_body):
	$particles/left.one_shot = false


func _on_left_body_exited(_body):
	$particles/left.one_shot = true
