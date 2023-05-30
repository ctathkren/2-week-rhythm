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
const LEVEL_SELECT_PATH = "res://ui/scenes/main/level_select/level_select.tscn"
const TITLE_SCREEN_PATH = "res://ui/scenes/main/title_screen/title_screen.tscn"


# MAIN FUNCTIONS
func _ready():
	get_globals()
	set_locals()


# SIGNALS
func _on_RetryButton_pressed():
	change_scene(LEVEL_PATH)

func _on_LevelSelectButton_pressed():
	change_scene(LEVEL_SELECT_PATH)

# HELPER FUNCTIONS
func get_globals():
	level_name = Global.level_info.title
	score_end = Global.score_stats.combined.score
	laurels_earned = Global.laurels_earned
	
	# unlock levels
	if level_name == "growth_easy" and laurels_earned >= 2:
		Global.is_level_unlocked["decay_easy"] = true
	if level_name == "growth_easy" and laurels_earned == 3:
		Global.is_level_unlocked["growth_hard"] = true
	if level_name == "decay_easy" and laurels_earned == 3:
		Global.is_level_unlocked["decay_hard"] = true
	
func set_locals():
	song_label.text = level_name
	
	if level_name == "growth":
		$Backgrounds/Growth.visible = true
	elif level_name == "decay":
		$Backgrounds/Decay.visible = true
	else:
		$Backgrounds/Default.visible = true
	
	score_label.text = "Score: " + str(score_end)
	show_laurels(laurels_earned)

func show_laurels(laurels):
	if laurels >= 1:
		laurel1.frame = 1
	if laurels >= 2:
		laurel2.frame = 1
	if laurels >= 3:
		laurel3.frame = 1

func change_scene(scene):
	var _change_scene = get_tree().change_scene(scene)
