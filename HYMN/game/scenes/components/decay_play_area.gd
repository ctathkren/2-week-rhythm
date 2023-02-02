extends Node2D

var SCROLL_SPEED

# ---

func _ready():
	pass 

func _physics_process(delta):
	$Button_Decay1.COLUMN_NUMBER = -1
	$Button_Decay2.COLUMN_NUMBER = -2
	$Button_Decay3.COLUMN_NUMBER = -3

# ---

func _on_Button_Decay1_hit_perfect():
	print("perfect")

func _on_Button_Decay1_hit_good():
	print("good")

func _on_Button_Decay1_hit_miss():
	print("miss")

func _on_Button_Decay2_hit_perfect():
	print("perfect")

func _on_Button_Decay2_hit_good():
	print("good")

func _on_Button_Decay2_hit_miss():
	print("miss")

func _on_Button_Decay3_hit_perfect():
	print("perfect")

func _on_Button_Decay3_hit_good():
	print("good")

func _on_Button_Decay3_hit_miss():
	print("miss")
