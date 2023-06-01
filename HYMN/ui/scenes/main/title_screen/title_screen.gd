extends Control

# VARIABLES
const LEVEL_SELECT_PATH = "res://ui/scenes/main/level_select/level_select.tscn"

enum PopupScenes {
	CONTENT,
	SETTINGS,
	CREDITS
}
var visible_scene = PopupScenes.CONTENT

func _input(event):
	if get_focus_owner() == null:
		if event.is_action_pressed("ui_up"):
			$Content/Buttons/LevelSelectButton.grab_focus()
		elif event.is_action_pressed("ui_down"):
			# BUG: this has a bug where it autoomatically goes to settings
			$Content/Buttons/LevelSelectButton.grab_focus()
		elif event.is_action_pressed("ui_left"):
			$Content/Buttons/LevelSelectButton.grab_focus()
		elif event.is_action_pressed("ui_right"):
			# BUG: this has a bug where it autoomatically goes to settings
			$Content/Buttons/LevelSelectButton.grab_focus()
		
func update_visible_scene():
	match visible_scene:
		PopupScenes.CONTENT:
			$Content.visible = true
			$Settings.visible = false
			$Credits.visible = false
		PopupScenes.SETTINGS:
			$Content.visible = false
			$Settings.visible = true
			$Credits.visible = false
		PopupScenes.CREDITS:
			$Content.visible = false
			$Settings.visible = false
			$Credits.visible = true

# SIGNALS
func _on_LevelSelectButton_pressed():
	change_scene(LEVEL_SELECT_PATH)

func _on_SettingsButton_pressed():
	if visible_scene == PopupScenes.CONTENT:
		visible_scene = PopupScenes.SETTINGS
		update_visible_scene()

func _on_Settings_settings_back_button_pressed():
	if visible_scene == PopupScenes.SETTINGS:
		visible_scene = PopupScenes.CONTENT
		update_visible_scene()

func _on_CreditsButton_pressed():
	if visible_scene == PopupScenes.CONTENT:
		visible_scene = PopupScenes.CREDITS
		update_visible_scene()

func _on_Credits_credits_back_button_pressed():
	if visible_scene == PopupScenes.CREDITS:
		visible_scene = PopupScenes.CONTENT
		update_visible_scene()

# when the mouse hovers over a button, force it to be on focus
func _on_LevelSelectButton_mouse_entered():
	$Content/Buttons/LevelSelectButton.grab_focus()

func _on_SettingsButton_mouse_entered():
	$Content/Buttons/SettingsButton.grab_focus()

func _on_CreditsButton_mouse_entered():
	$Content/Buttons/CreditsButton.grab_focus()

func _on_ExitButton_mouse_entered():
	$Content/Buttons/ExitButton.grab_focus()


			

func _on_ExitButton_pressed():
	get_tree().quit()

# HELPER FUNCTIONS
func change_scene(scene):
	var _change_scene = get_tree().change_scene(scene)
