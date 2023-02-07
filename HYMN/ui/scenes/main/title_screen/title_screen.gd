extends Control

# from ctath old code:
# export var MainGameScene : PackedScene

const START_PATH = "res://ui/scenes/main/title_screen/start/start.tscn"
const OPTIONS_PATH = "res://ui/scenes/main/title_screen/options/options.tscn"
const CREDITS_PATH = "res://ui/scenes/main/title_screen/credits/credits.tscn"


func _on_StartButton_pressed():
	var _start = get_tree().change_scene(START_PATH)


func _on_OptionsButton_pressed():
	var _options = get_tree().change_scene(OPTIONS_PATH)


func _on_CreditsButton_pressed():
	var _credits = get_tree().change_scene(CREDITS_PATH)


func _on_ExitButton_pressed():
    get_tree().quit()
