extends Control

const TITLE_SCREEN_PATH = "res://ui/scenes/main/title_screen/title_screen.tscn"


func _on_BackButton_pressed():
	visible = false
	$Content.visible = true
	# var _title_screen = get_tree().change_scene(TITLE_SCREEN_PATH)
