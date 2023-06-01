extends Control

onready var slider_volume_master = $SettingsBody/SettingsTabContainer/Volume/VolumeSettingsHBox/VolumeSettings/MasterVolumeSettingSlider
onready var slider_volume_music = $SettingsBody/SettingsTabContainer/Volume/VolumeSettingsHBox/VolumeSettings/MusicVolumeSettingSlider
onready var slider_volume_sfx = $SettingsBody/SettingsTabContainer/Volume/VolumeSettingsHBox/VolumeSettings/SfxVolumeSettingSlider

onready var value_volume_master = $SettingsBody/SettingsTabContainer/Volume/VolumeSettingsHBox/VolumeSettings/MasterVolumeSettingValue
onready var value_volume_music = $SettingsBody/SettingsTabContainer/Volume/VolumeSettingsHBox/VolumeSettings/MusicVolumeSettingValue
onready var value_volume_sfx = $SettingsBody/SettingsTabContainer/Volume/VolumeSettingsHBox/VolumeSettings/SfxVolumeSettingValue

onready var bus_master_index = AudioServer.get_bus_index("Master")
onready var bus_music_index = AudioServer.get_bus_index("Music")
onready var bus_sfx_index = AudioServer.get_bus_index("Sfx")

onready var keylabel_button_growth1 = $SettingsBody/SettingsTabContainer/Controls/ControlsSettingsHBox/ControlsSettings/GrowthLeftSettingValue
onready var keylabel_button_growth2 = $SettingsBody/SettingsTabContainer/Controls/ControlsSettingsHBox/ControlsSettings/GrowthCenterSettingValue
onready var keylabel_button_growth3 = $SettingsBody/SettingsTabContainer/Controls/ControlsSettingsHBox/ControlsSettings/GrowthRightSettingValue
onready var keylabel_button_decay1 = $SettingsBody/SettingsTabContainer/Controls/ControlsSettingsHBox/ControlsSettings/DecayLeftSettingValue
onready var keylabel_button_decay2 = $SettingsBody/SettingsTabContainer/Controls/ControlsSettingsHBox/ControlsSettings/DecayCenterSettingValue
onready var keylabel_button_decay3 = $SettingsBody/SettingsTabContainer/Controls/ControlsSettingsHBox/ControlsSettings/DecayRightSettingValue

onready var control_change_prompt_hbox = $SettingsBody/SettingsTabContainer/Controls/ControlChangePromptHBox

onready var settings_back_button = $SettingsBackButton

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

signal settings_back_button_pressed

# ---

func _ready():	
	# load default settings
	slider_volume_master.value = Global.settings['volume']['master']
	value_volume_master.text = str(Global.settings['volume']['master'])
	slider_volume_music.value = Global.settings['volume']['music']
	value_volume_music.text = str(Global.settings['volume']['music'])
	slider_volume_sfx.value = Global.settings['volume']['sfx']
	value_volume_sfx.text = str(Global.settings['volume']['sfx'])
	
	keylabel_button_growth1.text = Global.settings['controls']['button_growth1']
	keylabel_button_growth2.text = Global.settings['controls']['button_growth2']
	keylabel_button_growth3.text = Global.settings['controls']['button_growth3']
	keylabel_button_decay1.text = Global.settings['controls']['button_decay1']
	keylabel_button_decay2.text = Global.settings['controls']['button_decay2']
	keylabel_button_decay3.text = Global.settings['controls']['button_decay3']
	
func _input(event: InputEvent):
	if currently_changeable_key == ChangeableKeys.NONE:
		if event.is_action_pressed("ui_cancel"):
			emit_signal("settings_back_button_pressed")
	else:
		if event.is_action_pressed("ui_cancel"):
			currently_changeable_key = ChangeableKeys.NONE
			settings_back_button.visible = true
			control_change_prompt_hbox.visible = false
		elif event.is_action_pressed("button_valid_gameplay_input"):
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
			settings_back_button.visible = true
			control_change_prompt_hbox.visible = false

# Volume
func _on_MasterVolumeSettingSlider_value_changed(value):
	Global.settings['volume']['master'] = value
	value_volume_master.text = str(Global.settings['volume']['master'])
	
	AudioServer.set_bus_volume_db(bus_music_index, linear2db(Global.get_music_volume_muliplier()))
	AudioServer.set_bus_volume_db(bus_sfx_index, linear2db(Global.get_sfx_volume_muliplier()))
	
func _on_MusicVolumeSettingSlider_value_changed(value):
	Global.settings['volume']['music'] = value
	value_volume_music.text = str(Global.settings['volume']['music'])
	
	AudioServer.set_bus_volume_db(bus_music_index, linear2db(Global.get_music_volume_muliplier()))
	
func _on_SfxVolumeSettingSlider_value_changed(value):
	Global.settings['volume']['sfx'] = value
	value_volume_sfx.text = str(Global.settings['volume']['sfx'])
	
	AudioServer.set_bus_volume_db(bus_sfx_index, linear2db(Global.get_sfx_volume_muliplier()))

# Controls
func _on_GrowthLeftSettingValue_gui_input(event):
	if event is InputEventMouseButton:
		settings_back_button.visible = false
		control_change_prompt_hbox.visible = true
		currently_changeable_key = ChangeableKeys.GROWTH_LEFT
		
func _on_GrowthCenterSettingValue_gui_input(event):
	if event is InputEventMouseButton:
		settings_back_button.visible = false
		control_change_prompt_hbox.visible = true
		currently_changeable_key = ChangeableKeys.GROWTH_CENTER
		
func _on_GrowthRightSettingValue_gui_input(event):
	if event is InputEventMouseButton:
		settings_back_button.visible = false
		control_change_prompt_hbox.visible = true
		currently_changeable_key = ChangeableKeys.GROWTH_RIGHT
	
func _on_DecayLeftSettingValue_gui_input(event):
	if event is InputEventMouseButton:
		settings_back_button.visible = false
		control_change_prompt_hbox.visible = true
		currently_changeable_key = ChangeableKeys.DECAY_LEFT
		
func _on_DecayCenterSettingValue_gui_input(event):
	if event is InputEventMouseButton:
		settings_back_button.visible = false
		control_change_prompt_hbox.visible = true
		currently_changeable_key = ChangeableKeys.DECAY_CENTER
		
func _on_DecayRightSettingValue_gui_input(event):
	if event is InputEventMouseButton:
		settings_back_button.visible = false
		control_change_prompt_hbox.visible = true
		currently_changeable_key = ChangeableKeys.DECAY_RIGHT

# Back Button
func _on_SettingsBackButton_pressed():
	emit_signal("settings_back_button_pressed")

