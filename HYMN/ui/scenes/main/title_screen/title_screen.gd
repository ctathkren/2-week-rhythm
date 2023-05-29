extends Control

# VARIABLES
const LEVEL_SELECT_PATH = "res://ui/scenes/main/level_select/level_select.tscn"
var credits_showing := false

# SIGNALS
func _on_LevelSelectButton_pressed():
	change_scene(LEVEL_SELECT_PATH)

func _on_SettingsButton_pressed():
	$Content.visible = false
	$Settings.visible = true

func _on_Settings_settings_back_button_pressed():
	$Settings.visible = false
	$Content.visible = true

func _on_CreditsButton_pressed():
	$Content.visible = false
	$Credits.visible = true

func _on_Credits_credits_back_button_pressed():
	$Credits.visible = false
	$Content.visible = true
	
func _on_ExitButton_pressed():
	get_tree().quit()

# HELPER FUNCTIONS
func change_scene(scene):
	var _change_scene = get_tree().change_scene(scene)



