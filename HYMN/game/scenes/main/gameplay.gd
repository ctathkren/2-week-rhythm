extends Node2D

var BPM

# ---

func _ready():
	$Note2.setColumnNumber(1)
	$Note2.setColumnNumber(3)
	$Note3.setColumnNumber(2)
	$Note4.setColumnNumber(-1)
	$Note5.setColumnNumber(-2)
	$Note6.setColumnNumber(-3)
	$Note7.setColumnNumber(-3)
	$Note8.setColumnNumber(-2)
	$Note9.setColumnNumber(3)

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_down"):
		resetLevel()
	

# ---

func resetLevel():
	get_tree().reload_current_scene()
