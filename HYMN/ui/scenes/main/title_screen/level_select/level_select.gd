extends Control

# VARIABLES
export var growth_passed := false

const LEVEL_PATH = "res://game/scenes/main/gameplay/gameplay.tscn"
const BACK_PATH = "res://ui/scenes/main/title_screen/title_screen.tscn"

const DEFAULT_ROTATE_SPEED = 15
const GROWTH_ROTATE_SPEED = 50
const DECAY_ROTATE_SPEED = 90
var bunnies_rotate_speed := DEFAULT_ROTATE_SPEED

# MAIN FUNCTIONS
# Testing Decay Unlock
func _ready():
	Global.growth_passed = growth_passed

	if Global.growth_passed:
		decay_text_unlocked()
	else:
		decay_text_locked()


func _process(delta):
	$Bunnies.rect_rotation -= bunnies_rotate_speed * delta


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
	decay_text_unlocked()
		
func _on_DecayButton_mouse_exited():
	decay_off()
	if not Global.growth_passed:
		decay_text_locked()

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
	
	# prevents music repeating if exit decay button & decay locked
	if not $Music/Default.playing: 
		$Music/Default.play()

	bunnies_rotate_speed = DEFAULT_ROTATE_SPEED
	$MusicLabel.visible = true
func default_off():
	$Backgrounds/Default.visible = false
	$Music/Default.stop()

func growth_on():
	$Backgrounds/Growth.visible = true
	$Music/Growth.play()

	bunnies_rotate_speed = GROWTH_ROTATE_SPEED
	$MusicLabel.visible = false
func growth_off():
	$Backgrounds/Growth.visible = false
	$Music/Growth.stop()

func decay_on():
	$Backgrounds/Decay.visible = true
	$Music/Decay.play()

	bunnies_rotate_speed = DECAY_ROTATE_SPEED
	$MusicLabel.visible = false
func decay_off():
	$Backgrounds/Decay.visible = false
	$Music/Decay.stop()
func decay_text_unlocked():
	# hide
	$Buttons/DecayButton.text = ""

	# show
	$Buttons/DecayButton/SongTitleLabel.visible = true
	$Buttons/DecayButton/SongTitleLabel.text = "Decay"

	$Buttons/DecayButton/ArtistLabel.visible = true
	$Buttons/DecayButton/ArtistLabel.text = "by Raco"

	$Buttons/DecayButton/VineSprite2.visible = false
func decay_text_locked():
	# hide
	$Buttons/DecayButton/SongTitleLabel.visible = false
	$Buttons/DecayButton/ArtistLabel.visible = false

	# show
	$Buttons/DecayButton.text = "Locked"

func change_scene(scene):
	var _change_scene = get_tree().change_scene(scene)
