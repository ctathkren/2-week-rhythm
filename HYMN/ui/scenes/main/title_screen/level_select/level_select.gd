extends Control

# VARIABLES
export var growth_passed := false

const LEVEL_PATH = "res://game/scenes/main/gameplay/gameplay.tscn"
const BACK_PATH = "res://ui/scenes/main/title_screen/title_screen.tscn"

const DEFAULT_ROTATE_SPEED = 10
const GROWTH_ROTATE_SPEED = 60
const DECAY_ROTATE_SPEED = 100
var bunnies_rotate_speed := DEFAULT_ROTATE_SPEED

const LEVEL_1_PATH = "res://levels/Level1"
const LEVEL_2_PATH = "res://levels/Level2"

const DEFAULT_MUSIC_PATH = "res://ui/assets/sound/music/sleepless.ogg"
const GROWTH_MUSIC_PATH = "res://game/assets/sound/music/level_1/growth_draft.ogg"
const DECAY_MUSIC_PATH = "res://game/assets/sound/music/level_2/decay_ost.ogg"
var current_track = DEFAULT_MUSIC_PATH

var decay_exited := true

# MAIN FUNCTIONS
# Testing Decay Unlock
func _ready():
	# for testing in-editor
	Global.growth_passed = growth_passed

	if Global.growth_passed:
		decay_text_unlocked()
	else:
		decay_text_locked()

	$Music.play()

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
	Global.level_name = "growth"
  
	Global.path_to_level_to_load = LEVEL_1_PATH

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
	decay_exited = false
		
func _on_DecayButton_mouse_exited():
	decay_off()
	if not Global.growth_passed:
		decay_text_locked()
	decay_exited = true

	default_on()

func _on_DecayButton_pressed():
	if Global.growth_passed:
  
		Global.level_name = "decay"
    
		Global.path_to_level_to_load = LEVEL_2_PATH
    
		change_scene(LEVEL_PATH)


# Back Button (Title Screen)
func _on_BackButton_pressed():
	change_scene(BACK_PATH)


# HELPER FUNCTIONS
func play_track(track):
	current_track = track
	$Music.stream = load(current_track)
	$Music.play()

func default_on():
	$Backgrounds/Default.visible = true
	bunnies_rotate_speed = DEFAULT_ROTATE_SPEED
	$MusicLabel.visible = true

	# prevents music repeating if exit decay button & decay locked
	
	# if exit decay -> default on
		# if decay locked (not growth passed)
			# don't play music (return)
	if not Global.growth_passed:
		pass
	else:
		play_track(DEFAULT_MUSIC_PATH)
func default_off():
	$Backgrounds/Default.visible = false
	$Music.stop()

func growth_on():
	$Backgrounds/Growth.visible = true
	play_track(GROWTH_MUSIC_PATH)

	bunnies_rotate_speed = GROWTH_ROTATE_SPEED
	$MusicLabel.visible = false
func growth_off():
	$Backgrounds/Growth.visible = false
	$Music.stop()

func decay_on():
	$Backgrounds/Decay.visible = true
	play_track(DECAY_MUSIC_PATH)

	bunnies_rotate_speed = DECAY_ROTATE_SPEED
	$MusicLabel.visible = false
func decay_off():
	$Backgrounds/Decay.visible = false
	$Music.stop()
	
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
