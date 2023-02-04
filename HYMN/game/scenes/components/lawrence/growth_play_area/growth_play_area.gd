extends Node2D

var SCROLL_SPEED

# ---

func _ready():
	pass 

func _physics_process(_delta):
	$Button_Growth1.column_number = 1
	$Button_Growth2.column_number = 2
	$Button_Growth3.column_number = 3

# ---

func _on_Button_Growth1_hit_perfect():
	print("perfect")

func _on_Button_Growth1_hit_good():
	print("good")

func _on_Button_Growth1_hit_miss():
	print("miss")

func _on_Button_Growth2_hit_perfect():
	print("perfect")

func _on_Button_Growth2_hit_good():
	print("good")

func _on_Button_Growth2_hit_miss():
	print("miss")

func _on_Button_Growth3_hit_perfect():
	print("perfect")

func _on_Button_Growth3_hit_good():
	print("good")

func _on_Button_Growth3_hit_miss():
	print("miss")
