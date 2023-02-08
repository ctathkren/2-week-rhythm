extends Control

# VARIABLES
export var growth_passed := false

const LEVEL_PATH = "res://game/scenes/main/gameplay/gameplay.tscn"
const BACK_PATH = "res://ui/scenes/main/title_screen/title_screen.tscn"


# MAIN FUNCTIONS
# Testing Decay Unlock
func _ready():
	growth_passed = Global.growth_passed

	if Global.growth_passed:
		decay_text("Decay")
	else:
		decay_text("Locked")


# SIGNALS
# Growth Button
func _on_GrowthButton_mouse_entered():
	default_off()
	decay_off()

	growth_on()

func _on_GrowthButton_mouse_exited():
	growth_off()

	default_on()

func _on_GrowthButton_pressed():
	change_scene(LEVEL_PATH)


# Decay Button
func _on_DecayButton_mouse_entered():
	if not Global.growth_passed:
		return

	default_off()
	growth_off()

	# Decay On
	decay_on()
	decay_text("Decay")
		
func _on_DecayButton_mouse_exited():
	decay_off()
	if not Global.growth_passed:
		decay_text("Locked")

	default_on()

func _on_DecayButton_pressed():
	if Global.growth_passed:
		change_scene(LEVEL_PATH)


# Back Button (Title Screen)
func _on_BackButton_pressed():
	change_scene(BACK_PATH)


# HELPER FUNCTIONS
func default_on():
	$Backgrounds/Default.visible = true
	$Music/Default.play()
func default_off():
	$Backgrounds/Default.visible = false
	$Music/Default.stop()

func growth_on():
	$Backgrounds/Growth.visible = true
	$Music/Growth.play()
func growth_off():
	$Backgrounds/Growth.visible = false
	$Music/Growth.stop()

func decay_on():
	$Backgrounds/Decay.visible = true
	$Music/Decay.play()
func decay_off():
	$Backgrounds/Decay.visible = false
	$Music/Decay.stop()
func decay_text(text):
	$Content/VBoxContainer/Buttons/Decay/DecayButton.text = str(text)

func change_scene(scene):
	var _change_scene = get_tree().change_scene(scene)
