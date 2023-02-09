extends Control

# VARIABLES
export var level_name := ""
onready var song_label = $Content/Labels/SongLabel

export var score_end := 0
onready var score_label = $Content/Labels/ScoreLabel

export var laurels_earned := 0
onready var laurel1 = $Content/Laurels/Laurel1
onready var laurel2 = $Content/Laurels/Laurel2
onready var laurel3 = $Content/Laurels/Laurel3

const LEVEL_PATH = "res://game/scenes/main/gameplay/gameplay.tscn"
const LEVEL_SELECT_PATH = "res://ui/scenes/main/title_screen/level_select/level_select.tscn"
const TITLE_SCREEN_PATH = "res://ui/scenes/main/title_screen/title_screen.tscn"


# MAIN FUNCTIONS
func _ready():
	set_globals() # for testing
	set_locals()


# SIGNALS
func _on_RetryButton_pressed():
	change_scene(LEVEL_PATH)

func _on_LevelSelectButton_pressed():
	# unlock decay if 2 laurels in growth
	if Global.level_name == "growth" and Global.laurels_earned >= 2:
		Global.growth_passed = true

	change_scene(LEVEL_SELECT_PATH)


# HELPER FUNCTIONS
# for testing only
func set_globals():
	Global.level_name = level_name
	Global.score_end = score_end
	Global.laurels_earned = laurels_earned

func set_locals():
	song_label.text = Global.level_name
	
	if Global.level_name == "growth":
		$Backgrounds/Growth.visible = true
	elif Global.level_name == "decay":
		$Backgrounds/Decay.visible = true
	else:
		$Backgrounds/Default.visible = true
	
	score_label.text = "Score: " + str(Global.score_end)
	show_laurels(Global.laurels_earned)

func show_laurels(laurels):
	if laurels >= 1:
		laurel1.frame = 1
	if laurels >= 2:
		laurel2.frame = 1
	if laurels >= 3:
		laurel3.frame = 1

func change_scene(scene):
	var _change_scene = get_tree().change_scene(scene)
