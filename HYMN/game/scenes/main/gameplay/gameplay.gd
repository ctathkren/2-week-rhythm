extends Node2D

# VARIABLES

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

var level_current_measure

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

var paused := false

# FUNCTIONS

# LOOPS

# fill later with mouse controls for UI
# can consider buttons also

func _unhandled_input(event):
	if event.is_action_pressed("button_pause"):
		pause()

# ON READY
func _ready():
	get_tree().paused = false # for restart 
	
func load_level(level_file):
	pass

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
	score_label.text = str(score_stats.combined.score)

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
	var measure = level_current_measure
	var notes
	
	"""
	if measure == 1:
		notes = spawn_notes_measure_1
	elif measure == 2:
		notes = spawn_notes_measure_2
	elif measure == 3:
		notes = spawn_notes_measure_3
	elif measure == 4:
		notes = spawn_notes_measure_4
	"""

	# resolve zero-division error
	if notes == 0:
		notes = 1
	
	feedback_label_timer.wait_time = (0.33 / 2) - (0.025)
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


# SIGNALS

func _on_Gameplay3D_score_incremented(input_type, score_to_add):
	increment_score(input_type, score_to_add)

func _on_Gameplay3D_level_ended():
	level_end()
	
func _on_FeedbackVisibleTimer_timeout():
	feedback_label.visible = false


func _on_PauseButton_pressed():
	pause()

func _on_RestartButton_pressed():
	get_tree().paused = false
	var _restart = get_tree().reload_current_scene()

func _on_QuitButton_pressed():
	get_tree().paused = false
	var _quit = get_tree().change_scene("res://ui/scenes/main/title_screen/level_select/level_select.tscn")


# HELPER FUNCTIONS
func pause():
	paused = get_tree().is_paused()

	# SET PAUSE
	# don't bother optimizing with a function xD the logic escapes me
	if paused: # turning play
		$UI/PauseLayer.set_frame_color(Color(0,0,0,0))
		$UI/Buttons/Restart/RestartButton.disabled = true
		$UI/Buttons/Quit/QuitButton.disabled = true
		$UI/Buttons/Pause/PauseButton.text = "Pause"
		$UI/Buttons/Restart/RestartButton.visible = false
		$UI/Buttons/Quit/QuitButton.visible = false
	else: 
		$UI/PauseLayer.set_frame_color(Color(0,0,0,0.5))
		$UI/Buttons/Restart/RestartButton.disabled = false
		$UI/Buttons/Quit/QuitButton.disabled = false
		$UI/Buttons/Pause/PauseButton.text = "Play"
		$UI/Buttons/Restart/RestartButton.visible = true
		$UI/Buttons/Quit/QuitButton.visible = true

	paused = not paused

	get_tree().set_pause(paused)
