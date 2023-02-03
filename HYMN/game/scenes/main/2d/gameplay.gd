extends Node2D

var BPM

# ---

func _ready():
	pass


func _physics_process(_delta):
	if Input.is_action_just_pressed("ui_down"):
		resetLevel()

# ---

func resetLevel():
	var _reload = get_tree().reload_current_scene()
