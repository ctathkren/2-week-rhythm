extends Node2D

var BPM

# ---

func _ready():
	$Note2.set_column_number(1)
	$Note2.set_column_number(3)
	$Note3.set_column_number(2)
	$Note4.set_column_number(-1)
	$Note5.set_column_number(-2)
	$Note6.set_column_number(-3)
	$Note7.set_column_number(-3)
	$Note8.set_column_number(-2)
	$Note9.set_column_number(3)


func _physics_process(_delta):
	if Input.is_action_just_pressed("ui_down"):
		reset_level()
	

# ---

func reset_level():
	var _reload = get_tree().reload_current_scene()
