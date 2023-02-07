extends Node2D

# VARIABLES

# Appearance
export var highway_type := "growth"

# SCORING & FEEDBACK
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

var note_type # to be assigned via signal
onready var combo_label_theme = $ComboLabel.get("theme")

var level_current_measure

onready var feedback_label_theme = $FeedbackLabel.get("theme")

const TEXT_MISS = "MISS"
const TEXT_GOOD = "GOOD"
const TEXT_PERFECT = "PERFECT!"

const COLOR_GROWTH = "eb8f54"
const COLOR_DECAY  = "393ea2"

# SONG TRACKING
var bpm = 115
	# seems only used for seconds_per_beat
	# which seems unused

var song_position_in_seconds = 0.0
	# doesn't seem used atm
var song_position_in_beats = 0

var last_spawned_beat = 0
	# doesn't seem used
var seconds_per_beat = 60.0 / bpm
	# doesn't seem used atm

export var beats_before_start := 8

# NOTE SPAWNING
# Spawn Note on Measure
	# want to rename t1se with "measure" in them
var spawn_notes_measure_1 = 0
var spawn_notes_measure_2 = 0
var spawn_notes_measure_3 = 1
	# why is this 1?
var spawn_notes_measure_4 = 0

# for optimization
var measure_to_spawn_notes = {
	1 : spawn_notes_measure_1,
	2 : spawn_notes_measure_2,
	3 : spawn_notes_measure_3,
	4 : spawn_notes_measure_4,
}

# Spawning
var note = load("res://game/scenes/components/aljo/note/note.tscn")


# FUNCTIONS

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
	# reference uses random lanes for note spawning
	randomize()
	set_labels_color()
	choose_level_start()


func set_labels_color():
	if highway_type == "growth":
		combo_label_theme.set("Label/colors/font_color", Color(COLOR_GROWTH))
		feedback_label_theme.set("Label/colors/font_color", Color(COLOR_GROWTH))
	elif highway_type == "decay":
		combo_label_theme.set("Label/colors/font_color", Color(COLOR_DECAY))
		feedback_label_theme.set("Label/colors/font_color", Color(COLOR_DECAY))


func choose_level_start():
	"""
	Ways to Start the Level
		- from beat 0
			- uncomment $Conductor.play_beats_before_start(beats)
		- from certain time or beat
			- uncomment $Conductor.play_from_beat(seconds, beat)
			- pass the arguments
		- DON'T FORGET TO COMMENT THE OTHER
	"""

	$Conductor.play_beats_before_start(beats_before_start)

	# $Conductor.play_from_beat(30, 4)
	

# ON CONDUCTOR SIGNALS (from Conductor.gd)
func _on_Conductor_send_measure(current_measure):
	# sets how many notes to spawn depending on what measure it is
	level_current_measure = current_measure

	if current_measure == 1:
		spawn_notes_randomly(spawn_notes_measure_1)
	elif current_measure == 2:
		spawn_notes_randomly(spawn_notes_measure_2)
	elif current_measure == 3:
		spawn_notes_randomly(spawn_notes_measure_3)
	elif current_measure == 4:
		spawn_notes_randomly(spawn_notes_measure_4)
	
	"""
	# proposed optimization for the above if-statement:
	# PROBLEM:
		# doesn't allow for many notes on same measure
		# possible cause: uses variables to pass values, not actual value
		# resolution: revert to original

	for measure in measure_to_spawn_notes:
		# recall: current_measure is the function parameter

		if current_measure == measure:
			var notes_to_spawn = measure_to_spawn_notes[measure]
			spawn_notes(notes_to_spawn)
	"""

# currently has the note mapping system from reference
func _on_Conductor_send_beat(current_beat):
	song_position_in_beats = current_beat

	"""
	to-do:
		- think of optimization 
		- way to read from file
		- HOW TO MANUALLY EDIT BY BEAT, NOT MEASURE
	"""

	"""
	Sample Optimization for the Many Lines Below
	
	var beats_before_to_measure_patterns = {
		36 : [1,1,1,1],
		98 : [2,0,1,0],
		123: [0,2,0,2],
	}

	var measures = [0,0,0,0]

	var spawn_notes_to_measure = {
		spawn_notes_measure_1 : measures[0],
		spawn_notes_measure_2 : measures[1],
		spawn_notes_measure_3 : measures[2],
		spawn_notes_measure_4 : measures[3],
	}

	for beat_before in beats_before_to_measure_patterns:
		var measures = beats_before_to_measure_patterns[beat_before]
		# ex. [1,1,1,1]
		for notes_to_spawn in spawn_notes_to_measure:
			var measure = spawn_notes_to_measure[notes_to_spawn]
			notes_to_spawn = measure 

	"""

	if song_position_in_beats > 36:
		spawn_notes_measure_1 = 0
		spawn_notes_measure_2 = 0
		spawn_notes_measure_3 = 1
		spawn_notes_measure_4 = 0
	if song_position_in_beats > 98:
		spawn_notes_measure_1 = 2
		spawn_notes_measure_2 = 0
		spawn_notes_measure_3 = 1
		spawn_notes_measure_4 = 0
	if song_position_in_beats > 132:
		spawn_notes_measure_1 = 0
		spawn_notes_measure_2 = 2
		spawn_notes_measure_3 = 0
		spawn_notes_measure_4 = 2
	if song_position_in_beats > 162:
		spawn_notes_measure_1 = 2
		spawn_notes_measure_2 = 2
		spawn_notes_measure_3 = 1
		spawn_notes_measure_4 = 1
	if song_position_in_beats > 194:
		spawn_notes_measure_1 = 2
		spawn_notes_measure_2 = 2
		spawn_notes_measure_3 = 1
		spawn_notes_measure_4 = 2
	if song_position_in_beats > 228:
		spawn_notes_measure_1 = 0
		spawn_notes_measure_2 = 2
		spawn_notes_measure_3 = 1
		spawn_notes_measure_4 = 2
	if song_position_in_beats > 258:
		spawn_notes_measure_1 = 1
		spawn_notes_measure_2 = 2
		spawn_notes_measure_3 = 1
		spawn_notes_measure_4 = 2
	if song_position_in_beats > 288:
		spawn_notes_measure_1 = 0
		spawn_notes_measure_2 = 2
		spawn_notes_measure_3 = 0
		spawn_notes_measure_4 = 2
	if song_position_in_beats > 322:
		spawn_notes_measure_1 = 3
		spawn_notes_measure_2 = 2
		spawn_notes_measure_3 = 2
		spawn_notes_measure_4 = 1
	if song_position_in_beats > 388:
		spawn_notes_measure_1 = 1
		spawn_notes_measure_2 = 0
		spawn_notes_measure_3 = 0
		spawn_notes_measure_4 = 0
	if song_position_in_beats > 396:
		spawn_notes_measure_1 = 0
		spawn_notes_measure_2 = 0
		spawn_notes_measure_3 = 0
		spawn_notes_measure_4 = 0
	
	# end of song!
	if song_position_in_beats > 404:
		level_end()

# ---

func update_global_score_stats():
	Global.set_score_stats(score_stats)

func switch_scene_level_end():
	if get_tree().change_scene("res://Scenes/End.tscn") != OK:
		print ("Error changing scene to End")

func level_end():
	update_global_score_stats()

	switch_scene_level_end()

# Spawn Notes
func instantiate_note(lane):
	var instance = note.instance()
	instance.initialize(lane)
	add_child(instance)

func spawn_notes_randomly(number_of_notes_to_spawn):
	# called from _on_Conductor_send_measure()
	# recall: number_of_notes_to_spawn is the function parameter

	# Spawn Note on a Lane
	var lane_numbers = [0, 1, 2]
	var chosen_lanes = []
	var lane

	for i in range(number_of_notes_to_spawn):
		lane = lane_numbers[randi() % lane_numbers.size()]
		while lane in chosen_lanes:	
			lane = lane_numbers[randi() % lane_numbers.size()]
		
		chosen_lanes.append(lane)

	for l in chosen_lanes:
		instantiate_note(lane)


# On Button Hit OK (Increment Score)
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
	$ScoreLabel.text = str(score_stats.combined.score)

func update_combo_label():
	# Color
	if note_type == "growth":
		combo_label_theme.set("Label/colors/font_color", Color(COLOR_GROWTH))
	elif note_type == "decay":
		combo_label_theme.set("Label/colors/font_color", Color(COLOR_DECAY))
		
	# Text
	if score_stats.growth.combo > 0:
		$ComboLabel.text = str(score_stats.growth.combo) + " COMBO!"
	else:
		$ComboLabel.text = ""


func update_feedback_label(feedback):
	# visibility
	$FeedbackLabel.visible = true

	# color
	if note_type == "growth":
		feedback_label_theme.set("Label/colors/font_color", Color(COLOR_GROWTH))
	elif note_type == "decay":
		feedback_label_theme.set("Label/colors/font_color", Color(COLOR_DECAY))

	# text
	if feedback == Global.Judgements.SCORE_PERFECT:
		$FeedbackLabel.text = TEXT_PERFECT
	elif feedback == Global.Judgements.SCORE_GOOD:
		$FeedbackLabel.text = TEXT_GOOD
	else:
		$FeedbackLabel.text = TEXT_MISS

	# timer
	var measure = level_current_measure
	var notes
	
	if measure == 1:
		notes = spawn_notes_measure_1
	elif measure == 2:
		notes = spawn_notes_measure_2
	elif measure == 3:
		notes = spawn_notes_measure_3
	elif measure == 4:
		notes = spawn_notes_measure_4

	# resolve zero-division error
	if notes == 0:
		notes = 1
	
	$FeedbackLabel/FeedbackVisibleTimer.wait_time = (seconds_per_beat / notes) - (0.025)
	
	$FeedbackLabel/FeedbackVisibleTimer.start()


func increment_score(score_to_add):
	# called from button.gd under hit_score_and_destroy(score)
	# 1 big function because called outside

	# Tracking
	update_combo(score_to_add)
	update_score(score_to_add)
	count_hit_feedback(highway_type, score_to_add)
	
	# Labels
	update_score_label()
	update_combo_label()
	update_feedback_label(score_to_add)


# ON MISSED BUTTON PRESS
func reset_combo():
	# called from Note.gd, physics_process() -> miss_delete()
	score_stats.growth.combo = 0
	
	update_combo_label()

func _on_FeedbackVisibleTimer_timeout():
	$FeedbackLabel.visible = false
