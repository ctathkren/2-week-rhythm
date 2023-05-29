extends Control

# VARIABLES
var is_level_unlocked = Global.is_level_unlocked

const LEVEL_PATH = "res://game/scenes/main/gameplay/gameplay.tscn"
const BACK_PATH = "res://ui/scenes/main/title_screen/title_screen.tscn"

const DEFAULT_ROTATE_SPEED = 10
const GROWTH_ROTATE_SPEED = 60
const DECAY_ROTATE_SPEED = 100
var bunnies_rotate_speed := DEFAULT_ROTATE_SPEED

const LEVEL_GROWTH_EASY_PATH = "res://levels/Level1a"
const LEVEL_GROWTH_HARD_PATH = "res://levels/Level1b"
const LEVEL_DECAY_EASY_PATH = "res://levels/Level2a"
const LEVEL_DECAY_HARD_PATH = "res://levels/Level2b"

enum Levels {EASY, HARD}
var current_level_mode = Levels.EASY

const DEFAULT_MUSIC_PATH = "res://ui/assets/sound/music/sleepless.ogg"
const GROWTH_MUSIC_PATH = "res://game/assets/sound/music/level_1/growth_draft.ogg"
const DECAY_MUSIC_PATH = "res://game/assets/sound/music/level_2/decay_ost.ogg"

# MAIN FUNCTIONS
# Testing Decay Unlock
func _ready():
	current_level_mode = Levels.EASY

	if Global.is_level_unlocked["decay_easy"]:
		decay_text_unlocked()
	else:
		decay_text_locked()

	$Music.play()

func _process(delta):
	$Bunnies.rect_rotation -= bunnies_rotate_speed * delta
	
func _input(event):
	# go back with Escape button
	if InputMap.event_is_action(event, "ui_cancel"):
		_on_BackButton_pressed()
		
# SIGNALS
# Growth Button
func _on_GrowthButton_mouse_entered():
	match current_level_mode:
		Levels.EASY:
			if Global.is_level_unlocked["growth_easy"]:
				default_off()
				growth_on()
				decay_off()
			else:
				return
		Levels.HARD:
			if Global.is_level_unlocked["growth_hard"]:
				default_off()
				growth_on()
				decay_off()
			else:
				return
	
func _on_GrowthButton_mouse_exited():
	match current_level_mode:
		Levels.EASY:
			if Global.is_level_unlocked["growth_easy"]:
				default_on()
				growth_off()
				decay_off()
			else:
				default_on()
				growth_off()
				decay_off()
		Levels.HARD:
			if Global.is_level_unlocked["growth_hard"]:
				default_on()
				growth_off()
				decay_off()

func _on_GrowthButton_pressed():
	match current_level_mode:
		Levels.EASY:
			if Global.is_level_unlocked["growth_easy"]:
				Global.path_to_level_to_load = LEVEL_GROWTH_EASY_PATH
				
				change_scene(LEVEL_PATH)
		Levels.HARD:
			if Global.is_level_unlocked["growth_hard"]:
				Global.path_to_level_to_load = LEVEL_GROWTH_HARD_PATH
	
				change_scene(LEVEL_PATH)

# Decay Button
func _on_DecayButton_mouse_entered():
	match current_level_mode:
		Levels.EASY:
			if Global.is_level_unlocked["decay_easy"]:
				default_off()
				growth_off()
				decay_on()
			else:
				return
		Levels.HARD:
			if Global.is_level_unlocked["decay_hard"]:
				default_off()
				growth_off()
				decay_on()
			else:
				return
		
func _on_DecayButton_mouse_exited():
	match current_level_mode:
		Levels.EASY:
			if Global.is_level_unlocked["decay_easy"]:
				default_on()
				growth_off()
				decay_off()
		Levels.HARD:
			if Global.is_level_unlocked["decay_hard"]:
				default_on()
				growth_off()
				decay_off()

func _on_DecayButton_pressed():
	match current_level_mode:
		Levels.EASY:
			if Global.is_level_unlocked["decay_easy"]:
				Global.path_to_level_to_load = LEVEL_DECAY_EASY_PATH
				
				change_scene(LEVEL_PATH)
		Levels.HARD:
			if Global.is_level_unlocked["decay_hard"]:
				Global.path_to_level_to_load = LEVEL_DECAY_HARD_PATH
	
				change_scene(LEVEL_PATH)

func _on_HardButton_pressed():
	match current_level_mode:
		Levels.EASY:
			# Switch from EASY to HARD
			current_level_mode = Levels.HARD
			
			if Global.is_level_unlocked["growth_hard"]:
				growth_text_unlocked()
			else:
				growth_text_locked()
			
			if Global.is_level_unlocked["decay_hard"]:
				decay_text_unlocked()
			else:
				decay_text_locked()
		Levels.HARD:
			# Switch from HARD to EASY
			current_level_mode = Levels.EASY
			
			if Global.is_level_unlocked["growth_easy"]:
				growth_text_unlocked()
			else:
				growth_text_locked()
			
			if Global.is_level_unlocked["decay_easy"]:
				decay_text_unlocked()
			else:
				decay_text_locked()

# Back Button (Title Screen)
func _on_BackButton_pressed():
	change_scene(BACK_PATH)

# HELPER FUNCTIONS
func default_on():
	$Backgrounds/Default.visible = true
	$Music.stream = load(DEFAULT_MUSIC_PATH)
	$Music.play()
	$DefaultMusicLabel.visible = true

	bunnies_rotate_speed = DEFAULT_ROTATE_SPEED
	
func default_off():
	$Backgrounds/Default.visible = false
	$Music.stop()

func growth_on():
	$Backgrounds/Growth.visible = true
	$Music.stream = load(GROWTH_MUSIC_PATH)
	$Music.play()
	$DefaultMusicLabel.visible = false

	bunnies_rotate_speed = GROWTH_ROTATE_SPEED
	
func growth_off():
	$Backgrounds/Growth.visible = false
	$Music.stop()

func decay_on():
	$Backgrounds/Decay.visible = true
	$Music.stream = load(DECAY_MUSIC_PATH)
	$Music.play()
	$DefaultMusicLabel.visible = false

	bunnies_rotate_speed = DECAY_ROTATE_SPEED
	
func decay_off():
	$Backgrounds/Decay.visible = false
	$Music.stop()

func growth_text_unlocked():
	# hide
	$Buttons/GrowthButton.text = ""

	# show
	$Buttons/GrowthButton/SongTitleLabel.visible = true
	$Buttons/GrowthButton/ArtistLabel.visible = true
	
	match current_level_mode:
		Levels.EASY:
			$Buttons/GrowthButton/SongTitleLabel.text = "Growth"
			$Buttons/GrowthButton/ArtistLabel.text = "by Zach"
		Levels.HARD:
			$Buttons/GrowthButton/SongTitleLabel.text = "Growth+"
			$Buttons/GrowthButton/ArtistLabel.text = "by Zach"

	#$Buttons/GrowthButton/VineSprite2.visible = false

func growth_text_locked():
	# hide
	$Buttons/GrowthButton/SongTitleLabel.visible = false
	$Buttons/GrowthButton/ArtistLabel.visible = false

	# show
	$Buttons/GrowthButton.text = "Locked"

func decay_text_unlocked():
	# hide
	$Buttons/DecayButton.text = ""
	$Buttons/DecayButton/VineSprite2.visible = false
	
	# show
	$Buttons/DecayButton/SongTitleLabel.visible = true
	$Buttons/DecayButton/ArtistLabel.visible = true

	match current_level_mode:
		Levels.EASY:
			$Buttons/DecayButton/SongTitleLabel.text = "Decay"
			$Buttons/DecayButton/ArtistLabel.text = "by Raco"
		Levels.HARD:
			$Buttons/DecayButton/SongTitleLabel.text = "Decay+"
			$Buttons/DecayButton/ArtistLabel.text = "by Raco"
	
func decay_text_locked():
	# hide
	$Buttons/DecayButton/SongTitleLabel.visible = false
	$Buttons/DecayButton/ArtistLabel.visible = false

	# show
	$Buttons/DecayButton.text = "Locked"
	$Buttons/DecayButton/VineSprite2.visible = true

func change_scene(scene):
	var _change_scene = get_tree().change_scene(scene)



