extends Node2D

### VARIABLES

# Level Info from File
const LEVEL_INFO_FILENAME = "level.hymn"

onready var gameplay_3d_node = $GameplayPerspectivized/Gameplay3DViewport/Gameplay3D

# Gameplay UI Elements
onready var combo_label = $UI/ComboLabel
onready var score_label = $UI/ScoreLabel

var feedback_label
var feedback_label_timer

onready var feedback_growth_label = $UI/FeedbackGrowthLabel
onready var feedback_growth_label_timer = $UI/FeedbackGrowthLabel/FeedbackVisibleTimer
onready var feedback_decay_label = $UI/FeedbackDecayLabel
onready var feedback_decay_label_timer = $UI/FeedbackDecayLabel/FeedbackVisibleTimer

const TEXT_MISS = "MISS"
const TEXT_GOOD = "GOOD"
const TEXT_PERFECT = "PERFECT!"

#const COLOR_GROWTH = "eb8f54"
#const COLOR_DECAY  = "393ea2"

# Scoring & Feedback
var score_stats = {
	"growth": {	
		# Note Hit Feedback
		score_feedback_to_button_hit_feedback = {
			Global.Judgements.SCORE_PERFECT : 0,
			Global.Judgements.SCORE_GOOD : 0,
			Global.Judgements.SCORE_MISS : 0
		}
	},
	"decay": {		
		# Note Hit Feedback
		score_feedback_to_button_hit_feedback = {
			Global.Judgements.SCORE_PERFECT : 0,
			Global.Judgements.SCORE_GOOD : 0,
			Global.Judgements.SCORE_MISS : 0
		}
	},
	"combined": {
		# Scoring
		"score": 0,
		
		# Combos
		"combo": 0,
		"max_combo": 0,
		
		# Note Hit Feedback
		score_feedback_to_button_hit_feedback = {
			Global.Judgements.SCORE_PERFECT : 0,
			Global.Judgements.SCORE_GOOD : 0,
			Global.Judgements.SCORE_MISS : 0
		}
	}
}

# --- -----

### FUNCTIONS

# LOOPS

# fill later with mouse controls for UI
# can consider buttons also
"""
func _input(event):
	if event.is_action("escape"):
		if get_tree().change_scene("res://Scenes/Menu.tscn") != OK:
			print ("Error changing scene to Menu")
"""

# ON READY
func _ready():
	load_level("res://levels/Level2")

func load_level(level_folder_path):
	var level_info_file_path = level_folder_path
	
	if level_info_file_path[-1] != '/':
		level_info_file_path += "/"
		
	level_info_file_path += LEVEL_INFO_FILENAME
	
	# ---
	
	var level_config = ConfigFile.new()
	
	var err = level_config.load(level_info_file_path)
	if err != OK:
		printerr("Failed to load level from path: \"" + level_info_file_path + "\".")
		return
		
	for key in level_config.get_section_keys("LevelInfo"):
		Global.level_info[key] = level_config.get_value("LevelInfo", key)
	
	gameplay_3d_node.fetch_level_notes()
	
# ---

# Set Score Stats after finishing level
func update_global_score_stats():
	Global.set_score_stats(score_stats)

func switch_scene_level_end():
	if get_tree().change_scene("res://Scenes/End.tscn") != OK:
		print("Error changing scene to End")

func level_end():
	update_global_score_stats()

	switch_scene_level_end()

# ---

# Increment Score
func update_combo(score_to_add):
	if score_to_add != Global.Judgements.SCORE_MISS:
		# current combo
		score_stats.combined.combo += 1
		
		# max combo
		if score_stats.combined.combo > score_stats.combined.max_combo:
			score_stats.combined.max_combo = score_stats.combined.combo
	else:
		# if miss received, reset current combo
		score_stats.combined.combo = 0

func update_score(score_to_add):
	score_stats.combined.score += score_to_add * score_stats.combined.combo

func count_hit_feedback(input_type, score_to_add):
	score_stats[input_type].score_feedback_to_button_hit_feedback[score_to_add] += 1
	score_stats.combined.score_feedback_to_button_hit_feedback[score_to_add] += 1

func update_score_label():
	score_label.text = "SCORE: " + str(score_stats.combined.score)

func update_combo_label():
	if score_stats.combined.combo > 0:
		combo_label.text = "COMBO\n" + str(score_stats.combined.combo) + "x"
	else:
		combo_label.text = ""

func update_feedback_label(input_type, score_to_add):
	if input_type == "growth":
		feedback_label = feedback_growth_label
		feedback_label_timer = feedback_growth_label_timer
	elif input_type == "decay":
		feedback_label = feedback_decay_label
		feedback_label_timer = feedback_decay_label_timer
	
	feedback_label.visible = true

	# text
	if score_to_add == Global.Judgements.SCORE_PERFECT:
		feedback_label.text = TEXT_PERFECT
	elif score_to_add == Global.Judgements.SCORE_GOOD:
		feedback_label.text = TEXT_GOOD
	else:
		feedback_label.text = TEXT_MISS

	# timer
	var seconds_per_beat = 60.0 / Global.level_info.bpm
	
	feedback_label_timer.wait_time = (seconds_per_beat / 2) - (0.025)
	feedback_label_timer.start()

func increment_score(input_type, score_to_add):
	# called from button.gd under hit_score_and_destroy(score)
	# 1 big function because called outside

	# Tracking
	update_combo(score_to_add)
	update_score(score_to_add)
	count_hit_feedback(input_type, score_to_add)
	
	# Labels
	update_score_label()
	update_combo_label()
	update_feedback_label(input_type, score_to_add)

# --- -----

### SIGNALS

func _on_Gameplay3D_score_incremented(input_type, score_to_add):
	increment_score(input_type, score_to_add)

func _on_Gameplay3D_level_ended():
	level_end()
	
func _on_FeedbackVisibleTimer_timeout():
	feedback_label.visible = false
