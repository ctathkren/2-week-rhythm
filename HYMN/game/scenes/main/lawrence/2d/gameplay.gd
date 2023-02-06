extends Node2D

# VARIABLES

# SCORING & FEEDBACK
var score_stats = {
	"growth": {	
		# Combos
		"combo": 0,
		"max_combo": 0,
		
		# Note Hit Feedback
		score_feedback_to_button_hit_feedback = {
			Global.Judgements.SCORE_PERFECT : 0,
			Global.Judgements.SCORE_GOOD : 0,
			Global.Judgements.SCORE_MISS : 0
		}
	},
	"decay": {		
		# Combos
		"combo": 0,
		"max_combo": 0,
		
		# Note Hit Feedback
		score_feedback_to_button_hit_feedback = {
			Global.Judgements.SCORE_PERFECT : 0,
			Global.Judgements.SCORE_GOOD : 0,
			Global.Judgements.SCORE_MISS : 0
		}
	},
	"combined": {
		# Scoring
		"score": 0
	}
}

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
	# want to rename these with "measure" in them
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
var note = load("res://game/scenes/components/lawrence/note/note.tscn")

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
	#randomize()
	pass
	#choose_level_start()
	
func load_level(level_file):
	pass

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

	$GameplayPerspectivized/Gameplay3DViewport/Gameplay3D.gameplay_node.play_beats_before_start(beats_before_start)

	# $Conductor.play_from_beat(30, 4)


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
func update_combo(input_type, score_to_add):
	# current combo
	if score_to_add != 0:
		score_stats[input_type].combo += 1
		
		# max combo
		if score_stats[input_type].combo > score_stats[input_type].max_combo:
			score_stats[input_type].max_combo = score_stats[input_type].combo
	else:
		score_stats[input_type].combo = 0

func update_score(input_type, score_to_add):
	score_stats.combined.score += score_to_add * score_stats[input_type].combo

func count_hit_feedback(input_type, score_to_add):
	score_stats[input_type].score_feedback_to_button_hit_feedback[score_to_add] += 1

func update_score_label():
	$Score.text = str(score_stats.combined.score)

func update_combo_labels():
	if score_stats.growth.combo > 0:
		$GrowthCombo.text = str(score_stats.growth.combo) + " COMBO!"
	else:
		$GrowthCombo.text = ""
		
	if score_stats.decay.combo > 0:
		$DecayCombo.text = str(score_stats.decay.combo) + " COMBO!"
	else:
		$DecayCombo.text = ""


func increment_score(input_type, score_to_add):
	# called from button.gd under hit_score_and_destroy(score)
	# 1 big function because called outside

	# Tracking
	update_combo(input_type, score_to_add)
	update_score(input_type, score_to_add)
	count_hit_feedback(input_type, score_to_add)
	
	# Labels
	update_score_label()
	update_combo_labels()


# SIGNALS

func _on_Gameplay3D_score_incremented(input_type, score_to_add):
	print("gameplay3d score incremented")
	increment_score(input_type, score_to_add)

func _on_Gameplay3D_level_ended():
	level_end()
