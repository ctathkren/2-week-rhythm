extends Node2D

# VARIABLES

# Level Info from File
const LEVEL_INFO_FILENAME = "level.hymn"

# Gameplay Logic Export
onready var gameplay_3d_node = $GameplayPerspectivized/Gameplay3DViewport/Gameplay3D

# Gameplay UI Elements
onready var background_texture = $Backgrounds/Background

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

onready var scale_node = $UI/Scale

var paused := false

# Scoring & Feedback
var current_score_stats = {
	"growth": {	
		# Note Hit Feedback
		"score_feedback_to_button_hit_feedback": {
			Global.Judgements.SCORE_PERFECT : 0,
			Global.Judgements.SCORE_GOOD : 0,
			Global.Judgements.SCORE_MISS : 0
		},
		
		# Computed Accuracies
		"active_accuracy": 100.0,
		"rampup_accuracy": 0.0
	},
	"decay": {		
		# Note Hit Feedback
		"score_feedback_to_button_hit_feedback": {
			Global.Judgements.SCORE_PERFECT : 0,
			Global.Judgements.SCORE_GOOD : 0,
			Global.Judgements.SCORE_MISS : 0
		},
		
		# Computed Accuracies
		"active_accuracy": 100.0,
		"rampup_accuracy": 0.0
	},
	"combined": {
		# Scoring
		"score": 0,
		
		# Combos
		"combo": 0,
		"max_combo": 0,
		
		# Note Hit Feedback
		"score_feedback_to_button_hit_feedback": {
			Global.Judgements.SCORE_PERFECT : 0,
			Global.Judgements.SCORE_GOOD : 0,
			Global.Judgements.SCORE_MISS : 0
		},
		
		# Computed Accuracies
		"active_accuracy": 100.0,
		"rampup_accuracy": 0.0
	}
}

# LOOPS

# fill later with mouse controls for UI
# can consider buttons also

func _unhandled_input(event):
	if event.is_action_pressed("button_pause"):
		pause()

# ON READY
func _ready():
	get_tree().paused = false # for restart 
	load_level("res://levels/Level2")
	
func load_level(level_folder_path):
	if level_folder_path[-1] != '/':
		level_folder_path += "/"
	
	var level_info_file_path = level_folder_path + LEVEL_INFO_FILENAME
	

func load_level(level_file):

	# ---
	
	Global.reset_level_info()
	
	# Load level data from file
	var level_config = ConfigFile.new()
	
	var err = level_config.load(level_info_file_path)
	if err != OK:
		printerr("Failed to load level from path: \"" + level_info_file_path + "\".")
		return
	
	# Update level info into global
	for key in level_config.get_section_keys("LevelInfo"):
		Global.level_info[key] = level_config.get_value("LevelInfo", key)
	
	# ---
	
	# Notes preprocessing
	
	"""
	; beat_number
	; lanes: [-1, -2, -3, 1, 2, 3]
	; note_type: 0 (note), 1  (hold)
	; (if hold) beat_duration

	notes = [
		[beat_number,[],0],
	]
	"""
	
	for n in range(Global.level_info.notes.size()):
		# Standardize notes format
		# if lane parameter is a single lane integer, then store it inside an array
		if typeof(Global.level_info.notes[n][1]) != TYPE_ARRAY:
			Global.level_info.notes[n][1] = [Global.level_info.notes[n][1]]
		
		# Count the total number of notes to hit
		if Global.level_info.notes[n][2] == 0:		# note
			# check every lane specified
			for lane in Global.level_info.notes[n][1]:
				Global.level_info.number_of_notes.combined += 1
				
				if lane > 0:
					Global.level_info.number_of_notes.growth += 1
				elif lane < 0:
					Global.level_info.number_of_notes.decay += 1
		elif Global.level_info.notes[n][2] == 1:		# hold, currently unused
			# check every lane specified
			for lane in Global.level_info.notes[n][1]:
				Global.level_info.number_of_notes.combined += 2
				
				if lane > 0:
					Global.level_info.number_of_notes.growth += 2	# hold_head + hold_tail
				elif lane < 0:
					Global.level_info.number_of_notes.decay += 2	# hold_head + hold_tail

	# ---

	background_texture.texture = load(level_folder_path + Global.level_info.background_file_path)
	
	gameplay_3d_node.load_level_info(
		level_folder_path + Global.level_info.audio_file_path,
		Global.level_info.notes
	)

# ---

# Set Score Stats after finishing level
func update_global_score_stats():
	Global.set_score_stats(current_score_stats)

func switch_scene_level_end():
	if get_tree().change_scene("res://Scenes/End.tscn") != OK:
		print("Error changing scene to End")

func level_end():
	update_global_score_stats()

	switch_scene_level_end()

# ---

# Increment Score
func count_hit_feedback(input_type, score_to_add):
	current_score_stats[input_type].score_feedback_to_button_hit_feedback[score_to_add] += 1
	current_score_stats.combined.score_feedback_to_button_hit_feedback[score_to_add] += 1

func update_combo(score_to_add):
	if score_to_add != Global.Judgements.SCORE_MISS:
		# current combo
		current_score_stats.combined.combo += 1
		
		# max combo
		if current_score_stats.combined.combo > current_score_stats.combined.max_combo:
			current_score_stats.combined.max_combo = current_score_stats.combined.combo
	else:
		# if miss received, reset current combo
		current_score_stats.combined.combo = 0

func update_score(score_to_add):
	current_score_stats.combined.score += score_to_add * current_score_stats.combined.combo

func update_accuracies():
	var growth_numerator = 0.0	
	var active_growth_denominator = 0.0
	var rampup_growth_denominator = 1
	
	var decay_numerator = 0.0
	var active_decay_denominator = 0.0
	var rampup_decay_denominator = 1
	
	var combined_numerator = 0.0
	var active_combined_denominator = 0.0
	var rampup_combined_denominator = 1

	for judgement_name in Global.Judgements:
		var judgement = Global.Judgements[judgement_name]
		
		# get the total weighted hits from the button_hit_feedback values of each highway
		growth_numerator += current_score_stats.growth.score_feedback_to_button_hit_feedback[judgement] * Global.ACCURACY_WEIGHTS[judgement]
		decay_numerator += current_score_stats.decay.score_feedback_to_button_hit_feedback[judgement] * Global.ACCURACY_WEIGHTS[judgement]
		combined_numerator += current_score_stats.combined.score_feedback_to_button_hit_feedback[judgement] * Global.ACCURACY_WEIGHTS[judgement]
		
		# active_accuracy uses the number of notes so far as a denominator
		active_growth_denominator += current_score_stats.growth.score_feedback_to_button_hit_feedback[judgement] * Global.ACCURACY_WEIGHTS[Global.Judgements.SCORE_PERFECT]
		active_decay_denominator += current_score_stats.decay.score_feedback_to_button_hit_feedback[judgement] * Global.ACCURACY_WEIGHTS[Global.Judgements.SCORE_PERFECT]
		active_combined_denominator += current_score_stats.combined.score_feedback_to_button_hit_feedback[judgement] * Global.ACCURACY_WEIGHTS[Global.Judgements.SCORE_PERFECT]
	
	# rampup_accuracy uses the total number of notes in the level as a denominator
	rampup_growth_denominator = Global.level_info.number_of_notes.growth * Global.ACCURACY_WEIGHTS[Global.Judgements.SCORE_PERFECT]
	rampup_decay_denominator = Global.level_info.number_of_notes.decay * Global.ACCURACY_WEIGHTS[Global.Judgements.SCORE_PERFECT]
	rampup_combined_denominator = Global.level_info.number_of_notes.combined * Global.ACCURACY_WEIGHTS[Global.Judgements.SCORE_PERFECT]
	
	# ---
	
	# Set Growth accuracies

	# active_accuracy defaults to 100.0 if there are no notes total (division by zero)
	if active_growth_denominator > 0:
		current_score_stats.growth.active_accuracy = (growth_numerator / active_growth_denominator)	* 100.0
	else:
		current_score_stats.growth.active_accuracy = 100.0
	
	# rampup_accuracy defaults to 0.0 if there are no notes yet (division by zero)
	if rampup_growth_denominator > 0:
		current_score_stats.growth.rampup_accuracy = (growth_numerator / rampup_growth_denominator) * 100.0
	else:
		current_score_stats.growth.rampup_accuracy = 0.0
	
	#--- 
	
	# Set Decay accuracies
	
	# active_accuracy defaults to 100.0 if there are no notes total (division by zero)
	if active_decay_denominator > 0:
		current_score_stats.decay.active_accuracy = (decay_numerator / active_decay_denominator) * 100.0
	else:
		current_score_stats.decay.active_accuracy = 100.0
	
	# rampup_accuracy defaults to 0.0 if there are no notes yet (division by zero)
	if rampup_decay_denominator > 0:
		current_score_stats.decay.rampup_accuracy = (decay_numerator / rampup_decay_denominator) * 100.0
	else:
		current_score_stats.decay.rampup_accuracy = 0.0
	
	# ---
	
	# Set Combined accuracies
	
	# active_accuracy defaults to 100.0 if there are no notes total (division by zero)
	if active_combined_denominator > 0:
		current_score_stats.combined.active_accuracy = (combined_numerator / active_combined_denominator) * 100.0
	else:
		current_score_stats.combined.active_accuracy = 100.0
	
	# rampup_accuracy defaults to 0.0 if there are no notes yet (division by zero)
	if rampup_combined_denominator > 0:
		current_score_stats.combined.rampup_accuracy = (combined_numerator / rampup_combined_denominator) * 100.0
	else:
		current_score_stats.combined.rampup_accuracy = 0.0
		
	# ---
	
	var print_accuracy_data = false
	
	if print_accuracy_data:
		print("##########")
		print("Growth - Active: " + str(current_score_stats.growth.active_accuracy))
		print("Growth - Rampup: " + str(current_score_stats.growth.rampup_accuracy))
		print("Decay - Active: " + str(current_score_stats.decay.active_accuracy))
		print("Decay - Rampup: " + str(current_score_stats.decay.rampup_accuracy))
		print("Combined - Active: " + str(current_score_stats.combined.active_accuracy))
		print("Combined - Rampup: " + str(current_score_stats.combined.rampup_accuracy))
		print("----------")
	
# Update Labels
func update_score_label():
	score_label.text = "SCORE: " + str(current_score_stats.combined.score)

func update_combo_label():
	if current_score_stats.combined.combo > 0:
		combo_label.text = "COMBO\n" + str(current_score_stats.combined.combo) + "x"
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

func update_accuracy_scale():
	scale_node.set_accuracies(
		current_score_stats.growth.rampup_accuracy,
		current_score_stats.decay.rampup_accuracy
	)

func increment_score(input_type, score_to_add):
	# called from button.gd under hit_score_and_destroy(score)
	# 1 big function because called outside

	# Tracking
	count_hit_feedback(input_type, score_to_add)
	update_combo(score_to_add)
	update_score(score_to_add)
	update_accuracies()
	
	# Labels
	update_score_label()
	update_combo_label()
	update_feedback_label(input_type, score_to_add)
	update_accuracy_scale()


# SIGNALS

func _on_Gameplay3D_score_incremented(input_type, score_to_add):
	increment_score(input_type, score_to_add)

func _on_Gameplay3D_level_ended():
	level_end()
	
func _on_FeedbackVisibleTimer_timeout():
	feedback_label.visible = false

func _on_Scale_scale_overtipped():
	print("deadge")
	
	# add game over screen here

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
