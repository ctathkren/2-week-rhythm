extends Control

# VARIABLES
export var score := 0
onready var score_label = $Content/VBoxContainer/Buttons/Score/ScoreLabel

export var laurels := 0
onready var laurel1 = $Content/VBoxContainer/Buttons/Laurels/Laurel1
onready var laurel2 = $Content/VBoxContainer/Buttons/Laurels/Laurel2
onready var laurel3 = $Content/VBoxContainer/Buttons/Laurels/Laurel3

const LEVEL_PATH = "res://game/scenes/main/lawrence/2d/gameplay.tscn"
const LEVEL_SELECT_PATH = "res://ui/scenes/main/title_screen/level_select/level_select.tscn"
const TITLE_SCREEN_PATH = "res://ui/scenes/main/title_screen/title_screen.tscn"


# MAIN FUNCTIONS
func _ready():
    score_label.text = "Score: " + str(score)
    show_laurels()


# SIGNALS
func _on_RetryButton_pressed():
	change_scene(LEVEL_PATH)

func _on_LevelSelectButton_pressed():
	change_scene(LEVEL_SELECT_PATH)

func _on_TitleScreenButton_pressed():
	change_scene(TITLE_SCREEN_PATH)


# HELPER FUNCTIONS
func show_laurels():
    if laurels >= 1:
        laurel1.frame = 1
    if laurels >= 2:
        laurel2.frame = 1
    if laurels >= 3:
        laurel3.frame = 1

func change_scene(scene):
    var _change_scene = get_tree().change_scene(scene)