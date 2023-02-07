extends Control

# VARIABLES
export var decay_unlocked := false

const GROWTH_LEVEL_PATH = "res://game/scenes/main/lawrence/2d/gameplay.tscn"
const DECAY_LEVEL_PATH = GROWTH_LEVEL_PATH # to change later if decide on separate scene
const BACK_PATH = "res://ui/scenes/main/title_screen/title_screen.tscn"


# MAIN FUNCTIONS
# Testing Decay Unlock
func _ready():
	Global.decay_unlocked = decay_unlocked

	if Global.decay_unlocked:
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
	change_scene(GROWTH_LEVEL_PATH)


# Decay Button
func _on_DecayButton_mouse_entered():
	if not Global.decay_unlocked:
		return

	default_off()
	growth_off()

	# Decay On
	decay_on()
	decay_text("Decay")
		
func _on_DecayButton_mouse_exited():
	decay_off()
	if not Global.decay_unlocked:
		decay_text("Locked")

	default_on()

func _on_DecayButton_pressed():
	if Global.decay_unlocked:
		change_scene(DECAY_LEVEL_PATH)


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
