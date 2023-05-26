extends Control

# VARIABLES
const LEVEL_SELECT_PATH = "res://ui/scenes/main/title_screen/level_select/level_select.tscn"
var credits_showing := false

# LOOPS
func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if !($Content.visible) and $Credits.visible:
			_on_CreditsBackButton_pressed()

# SIGNALS
func _on_LevelSelectButton_pressed():
	change_scene(LEVEL_SELECT_PATH)

func _on_SettingsButton_pressed():
	$Content.visible = false
	$Settings.visible = true

func _on_SettingsBackButton_pressed():
	$Settings.visible = false
	$Content.visible = true
	
func _on_CreditsButton_pressed():
	$Content.visible = false
	$Credits.visible = true

func _on_CreditsBackButton_pressed():
	$Credits.visible = false
	$Content.visible = true
	

func _on_ExitButton_pressed():
	get_tree().quit()


# HELPER FUNCTIONS
func change_scene(scene):
	var _change_scene = get_tree().change_scene(scene)






