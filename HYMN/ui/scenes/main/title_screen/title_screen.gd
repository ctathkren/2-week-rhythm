extends Control

# VARIABLES
const LEVEL_SELECT_PATH = "res://ui/scenes/main/title_screen/level_select/level_select.tscn"
var credits_showing := false

enum changeable_keys {
	NONE,
	GROWTH_LEFT,
	GROWTH_CENTER,
	GROWTH_RIGHT,
	DECAY_LEFT,
	DECAY_CENTER,
	DECAY_RIGHT
}
var currently_changeable_key = changeable_keys.NONE

func _input(event: InputEvent):
	if currently_changeable_key == changeable_keys.NONE:
		if InputMap.event_is_action(event, "ui_cancel"):
			if !($Content.visible):
				if $Credits.visible:
					_on_CreditsBackButton_pressed()
				elif $Settings.visible:
					_on_SettingsBackButton_pressed()
	else:
		if InputMap.event_is_action(event, "ui_cancel"):
			currently_changeable_key = changeable_keys.NONE
			$Settings/SettingsBackButton.visible = true
		elif InputMap.event_is_action(event, "button_valid_gameplay_input"):
			match currently_changeable_key:
				changeable_keys.GROWTH_LEFT:
					InputMap.action_erase_events("button_growth1")
					InputMap.action_add_event("button_growth1", event)
					Global.settings["controls"]["button_growth1"] = char(event.scancode)
					
					$Settings/Body/SettingsTabContainer/Controls/ControlsSettings/GrowthLeftSettingValue.text = char(event.scancode)
				changeable_keys.GROWTH_CENTER:
					InputMap.action_erase_events("button_growth2")
					InputMap.action_add_event("button_growth2", event)
					Global.settings["controls"]["button_growth2"] = char(event.scancode)
					
					$Settings/Body/SettingsTabContainer/Controls/ControlsSettings/GrowthCenterSettingValue.text = char(event.scancode)
				changeable_keys.GROWTH_RIGHT:
					InputMap.action_erase_events("button_growth3")
					InputMap.action_add_event("button_growth3", event)
					Global.settings["controls"]["button_growth3"] = char(event.scancode)
					
					$Settings/Body/SettingsTabContainer/Controls/ControlsSettings/GrowthRightSettingValue.text = char(event.scancode)
				changeable_keys.DECAY_LEFT:
					InputMap.action_erase_events("button_decay1")
					InputMap.action_add_event("button_decay1", event)
					Global.settings["controls"]["button_decay1"] = char(event.scancode)
					
					$Settings/Body/SettingsTabContainer/Controls/ControlsSettings/DecayLeftSettingValue.text = char(event.scancode)
				changeable_keys.DECAY_CENTER:
					InputMap.action_erase_events("button_decay2")
					InputMap.action_add_event("button_decay2", event)
					Global.settings["controls"]["button_decay2"] = char(event.scancode)
					
					$Settings/Body/SettingsTabContainer/Controls/ControlsSettings/DecayCenterSettingValue.text = char(event.scancode)
				changeable_keys.DECAY_RIGHT:
					InputMap.action_erase_events("button_decay3")
					InputMap.action_add_event("button_decay3", event)
					Global.settings["controls"]["button_decay3"] = char(event.scancode)
					
					$Settings/Body/SettingsTabContainer/Controls/ControlsSettings/DecayRightSettingValue.text = char(event.scancode)
			
			currently_changeable_key = changeable_keys.NONE
			$Settings/SettingsBackButton.visible = true
# LOOPS
func _process(_delta):
	pass

# SIGNALS
func _on_LevelSelectButton_pressed():
	change_scene(LEVEL_SELECT_PATH)

func _on_SettingsButton_pressed():
	$Content.visible = false
	$Settings.visible = true

func _on_SettingsBackButton_pressed():
	$Settings.visible = false
	$Content.visible = true

func _on_GrowthLeftSettingValue_gui_input(event):
	if event is InputEventMouseButton:
		$Settings/SettingsBackButton.visible = false
		currently_changeable_key = changeable_keys.GROWTH_LEFT
		
func _on_GrowthCenterSettingValue_gui_input(event):
	if event is InputEventMouseButton:
		$Settings/SettingsBackButton.visible = false
		currently_changeable_key = changeable_keys.GROWTH_CENTER
		
func _on_GrowthRightSettingValue_gui_input(event):
	if event is InputEventMouseButton:
		$Settings/SettingsBackButton.visible = false
		currently_changeable_key = changeable_keys.GROWTH_RIGHT
	
func _on_DecayLeftSettingValue_gui_input(event):
	if event is InputEventMouseButton:
		$Settings/SettingsBackButton.visible = false
		currently_changeable_key = changeable_keys.DECAY_LEFT
		
func _on_DecayCenterSettingValue_gui_input(event):
	if event is InputEventMouseButton:
		$Settings/SettingsBackButton.visible = false
		currently_changeable_key = changeable_keys.DECAY_CENTER
		
func _on_DecayRightSettingValue_gui_input(event):
	if event is InputEventMouseButton:
		$Settings/SettingsBackButton.visible = false
		currently_changeable_key = changeable_keys.DECAY_RIGHT


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






pass # Replace with function body.
