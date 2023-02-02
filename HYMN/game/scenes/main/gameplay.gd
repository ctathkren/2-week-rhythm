extends Node2D

var BPM

# ---

func _ready():
	pass

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_down"):
		resetLevel()

# ---

func resetLevel():
	get_tree().reload_current_scene()
