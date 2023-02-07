extends Control

# VARIABLES
const LEVEL_SELECT_PATH = "res://ui/scenes/main/title_screen/level_select/level_select.tscn"
const OPTIONS_PATH = "res://ui/scenes/main/title_screen/options/options.tscn"
const CREDITS_PATH = "res://ui/scenes/main/title_screen/credits/credits.tscn"


# SIGNALS
func _on_LevelSelectButton_pressed():
	change_scene(LEVEL_SELECT_PATH)

func _on_OptionsButton_pressed():
	change_scene(OPTIONS_PATH)

func _on_CreditsButton_pressed():
	change_scene(CREDITS_PATH)

func _on_ExitButton_pressed():
    get_tree().quit()


# HELPER FUNCTIONS
func change_scene(scene):
	var _change_scene = get_tree().change_scene(scene)
