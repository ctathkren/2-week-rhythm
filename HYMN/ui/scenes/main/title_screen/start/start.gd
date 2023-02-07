extends Control

const GROWTH_LEVEL_PATH = "res://game/scenes/main/aljo/2d/level.tscn"
const DECAY_LEVEL_PATH = "res://game/scenes/main/aljo/2d/level.tscn"
const BACK_PATH = "res://ui/scenes/main/title_screen/title_screen.tscn"

# Growth Button
func _on_GrowthButton_mouse_entered():
	$Backgrounds/Decay.visible = false
	$Music/Decay.stop()

	
	$Backgrounds/Growth.visible = true
	if $Music/Growth.playing == false:
		$Music/Growth.play()


func _on_GrowthButton_pressed():
	var _level_growth = get_tree().change_scene(GROWTH_LEVEL_PATH)


# Decay Button
func _on_DecayButton_mouse_entered():
	$Backgrounds/Growth.visible = false
	$Music/Growth.stop()

	$Backgrounds/Decay.visible = true
	if $Music/Decay.playing == false:
		$Music/Decay.play()


func _on_DecayButton_pressed():
	var _level_decay = get_tree().change_scene(DECAY_LEVEL_PATH)


# Back Button (Title Screen)
func _on_BackButton_pressed():
	var _back = get_tree().change_scene(BACK_PATH)
