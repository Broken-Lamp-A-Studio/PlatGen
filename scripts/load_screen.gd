extends Control

onready var time = OS.get_system_time_msecs()



func popup(work_text, progress):
	MainSymlink.popup_logo()
	logo_p = true
	time = OS.get_system_time_msecs()
	$ProgressBar/Label.text = work_text
	$ProgressBar.value = progress
	set_tip()

func update_progress(work_text, progress):
	$ProgressBar/Label.text = work_text
	$ProgressBar.value = progress

func hide():
	MainSymlink.switch_logo()

var tips = [
	"Don't try produce more energy than machines can take.",
	"If you don't want to get electrocuted, use a screwdriver.",
	"Always take only things that are useful to you.",
	"The so-called AbyssMaker is a creature inhabiting the Abyss of the Underworld.",
]

func set_tip():
	$tip.text = "Tip:\n"+get_tip()

func get_tip():
	if(tips.size() > 0):
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		var selected = round(rng.randf_range(0, tips.size()-1))
		return tips[selected]
	else:
		return "?"

var logo_p = false

func _process(_delta):
	if(logo_p and OS.get_system_time_msecs() - time > 1000):
		MainSymlink.hide_logo()
		time = OS.get_system_time_msecs()
		logo_p = false


func _on_AnimationPlayer_animation_finished(anim_name):
	if(anim_name == "show_up"):
		self.visible = true
	


func _on_AnimationPlayer_animation_started(anim_name):
	if(anim_name == "show_down2"):
		self.visible = false
