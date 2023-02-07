extends Control

# CONSTANTS
const CREDITS_PATH = "res://ui/scenes/main/title_screen/credits/credits.tscn"
const TITLE_SCREEN_PATH = "res://ui/scenes/main/title_screen/title_screen.tscn"


# SIGNALS
func _on_CreditsButton_pressed():
	change_scene(CREDITS_PATH)

func _on_TitleScreenButton_pressed():
    change_scene(TITLE_SCREEN_PATH)


# HELPER FUNCTIONS
func change_scene(scene):
    var _change_scene = get_tree().change_scene(scene)