extends Control

enum ChangeableKeys {
	NONE,
	GROWTH_LEFT,
	GROWTH_CENTER,
	GROWTH_RIGHT,
	DECAY_LEFT,
	DECAY_CENTER,
	DECAY_RIGHT
}
var currently_changeable_key = ChangeableKeys.NONE

onready var slider_volume_master = $SettingsBody/SettingsTabContainer/Volume/VolumeSettings/MasterVolumeSettingSlider
onready var slider_volume_music = $SettingsBody/SettingsTabContainer/Volume/VolumeSettings/MusicVolumeSettingSlider
onready var slider_volume_sfx = $SettingsBody/SettingsTabContainer/Volume/VolumeSettings/SfxVolumeSettingSlider

onready var keylabel_button_growth1 = $SettingsBody/SettingsTabContainer/Controls/ControlsSettings/GrowthLeftSettingValue
onready var keylabel_button_growth2 = $SettingsBody/SettingsTabContainer/Controls/ControlsSettings/GrowthCenterSettingValue
onready var keylabel_button_growth3 = $SettingsBody/SettingsTabContainer/Controls/ControlsSettings/GrowthRightSettingValue
onready var keylabel_button_decay1 = $SettingsBody/SettingsTabContainer/Controls/ControlsSettings/DecayLeftSettingValue
onready var keylabel_button_decay2 = $SettingsBody/SettingsTabContainer/Controls/ControlsSettings/DecayCenterSettingValue
onready var keylabel_button_decay3 = $SettingsBody/SettingsTabContainer/Controls/ControlsSettings/DecayRightSettingValue

signal settings_back_button_pressed

# ---

func _ready():
	# load default settings
	slider_volume_master = Global.settings['volume']['master']
	slider_volume_music = Global.settings['volume']['music']
	slider_volume_sfx = Global.settings['volume']['sfx']
	
	keylabel_button_growth1.text = Global.settings['controls']['button_growth1']
	keylabel_button_growth2.text = Global.settings['controls']['button_growth2']
	keylabel_button_growth3.text = Global.settings['controls']['button_growth3']
	keylabel_button_decay1.text = Global.settings['controls']['button_decay1']
	keylabel_button_decay2.text = Global.settings['controls']['button_decay2']
	keylabel_button_decay3.text = Global.settings['controls']['button_decay3']
	
func _input(event: InputEvent):
	if currently_changeable_key == ChangeableKeys.NONE:
		if InputMap.event_is_action(event, "ui_cancel"):
			emit_signal("settings_back_button_pressed")
	else:
		if InputMap.event_is_action(event, "ui_cancel"):
			currently_changeable_key = ChangeableKeys.NONE
			$SettingsBackButton.visible = true
		elif InputMap.event_is_action(event, "button_valid_gameplay_input"):
			match currently_changeable_key:
				ChangeableKeys.GROWTH_LEFT:
					InputMap.action_erase_events("button_growth1")
					InputMap.action_add_event("button_growth1", event)
					Global.settings["controls"]["button_growth1"] = char(event.scancode)
					keylabel_button_growth1.text = char(event.scancode)
				ChangeableKeys.GROWTH_CENTER:
					InputMap.action_erase_events("button_growth2")
					InputMap.action_add_event("button_growth2", event)
					Global.settings["controls"]["button_growth2"] = char(event.scancode)
					keylabel_button_growth2.text = char(event.scancode)
				ChangeableKeys.GROWTH_RIGHT:
					InputMap.action_erase_events("button_growth3")
					InputMap.action_add_event("button_growth3", event)
					Global.settings["controls"]["button_growth3"] = char(event.scancode)
					keylabel_button_growth3.text = char(event.scancode)
				ChangeableKeys.DECAY_LEFT:
					InputMap.action_erase_events("button_decay1")
					InputMap.action_add_event("button_decay1", event)
					Global.settings["controls"]["button_decay1"] = char(event.scancode)
					keylabel_button_decay1.text = char(event.scancode)
				ChangeableKeys.DECAY_CENTER:
					InputMap.action_erase_events("button_decay2")
					InputMap.action_add_event("button_decay2", event)
					Global.settings["controls"]["button_decay2"] = char(event.scancode)
					keylabel_button_decay2.text = char(event.scancode)
				ChangeableKeys.DECAY_RIGHT:
					InputMap.action_erase_events("button_decay3")
					InputMap.action_add_event("button_decay3", event)
					Global.settings["controls"]["button_decay3"] = char(event.scancode)
					keylabel_button_decay3.text = char(event.scancode)
			
			currently_changeable_key = ChangeableKeys.NONE
			$SettingsBackButton.visible = true

func _on_GrowthLeftSettingValue_gui_input(event):
	if event is InputEventMouseButton:
		$SettingsBackButton.visible = false
		currently_changeable_key = ChangeableKeys.GROWTH_LEFT
		
func _on_GrowthCenterSettingValue_gui_input(event):
	if event is InputEventMouseButton:
		$SettingsBackButton.visible = false
		currently_changeable_key = ChangeableKeys.GROWTH_CENTER
		
func _on_GrowthRightSettingValue_gui_input(event):
	if event is InputEventMouseButton:
		$SettingsBackButton.visible = false
		currently_changeable_key = ChangeableKeys.GROWTH_RIGHT
	
func _on_DecayLeftSettingValue_gui_input(event):
	if event is InputEventMouseButton:
		$SettingsBackButton.visible = false
		currently_changeable_key = ChangeableKeys.DECAY_LEFT
		
func _on_DecayCenterSettingValue_gui_input(event):
	if event is InputEventMouseButton:
		$SettingsBackButton.visible = false
		currently_changeable_key = ChangeableKeys.DECAY_CENTER
		
func _on_DecayRightSettingValue_gui_input(event):
	if event is InputEventMouseButton:
		$SettingsBackButton.visible = false
		currently_changeable_key = ChangeableKeys.DECAY_RIGHT

func _on_SettingsBackButton_pressed():
	emit_signal("settings_back_button_pressed")
