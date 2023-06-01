extends Node2D

# VARIABLES
# Key Guides
onready var label_growth1 = $KeyGuides/Growth/Growth1
onready var label_growth2 = $KeyGuides/Growth/Growth2
onready var label_growth3 = $KeyGuides/Growth/Growth3
onready var label_decay1 = $KeyGuides/Decay/Decay1
onready var label_decay2 = $KeyGuides/Decay/Decay2
onready var label_decay3 = $KeyGuides/Decay/Decay3

# Gameplay
onready var conductor = $Conductor
onready var highway_growth = $HighwayGrowth
onready var highway_decay = $HighwayDecay

# SONG TRACKING
var bpm
	# seems only used for seconds_per_beat
	# which seems unused

var song_position_in_seconds = 0.0
	# doesn't seem used atm
var song_position_in_beats = 0

var last_spawned_beat = 0
	# doesn't seem used
var seconds_per_beat
	# doesn't seem used atm

export var beats_before_start := 7

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

signal button_pressed(lane)
signal button_released(lane)
signal score_incremented(input_type, score_to_add)
signal level_ended

# Spawning
var note = load("res://game/scenes/components/note/note.tscn")
var note_bar = load("res://game/scenes/components/note_bar/note_bar.tscn")

var notes_to_spawn = []

var has_level_started_ending = false


# FUNCTIONS

# LOOPS

# ON READY
func _ready():
	label_growth1.text = Global.settings["controls"]["button_growth1"]
	label_growth2.text = Global.settings["controls"]["button_growth2"]
	label_growth3.text = Global.settings["controls"]["button_growth3"]
	label_decay1.text = Global.settings["controls"]["button_decay1"]
	label_decay2.text = Global.settings["controls"]["button_decay2"]
	label_decay3.text = Global.settings["controls"]["button_decay3"]
	
	#fetch_level_info()
	
	# reference uses random lanes for note spawning
	#randomize()
	#choose_level_start()
	pass
	
func load_level_info(full_audio_file_path, bpm_level, notes):
	conductor.load_song_info(full_audio_file_path, bpm_level)
	bpm = bpm_level
	seconds_per_beat = 60.0 / bpm_level

	notes_to_spawn = notes

func choose_level_start():
	"""
	Ways to Start the Level
		- from beat 0
			- uncomment conductor.play_beats_before_start(beats)
		- from certain time or beat
			- uncomment conductor.play_from_beat(seconds, beat)
			- pass the arguments
		- DON'T FORGET TO COMMENT THE OTHER
	"""

	conductor.play_beats_before_start(beats_before_start)

	#conductor.play_from_beat(30, 4)
	

# ON CONDUCTOR SIGNALS (from Conductor.gd)
#func _on_Conductor_send_measure(current_measure):
	# sets how many notes to spawn depending on what measure it is
	"""
	if current_measure == 1:
		spawn_notes_randomly(spawn_notes_measure_1)
	elif current_measure == 2:
		spawn_notes_randomly(spawn_notes_measure_2)
	elif current_measure == 3:
		spawn_notes_randomly(spawn_notes_measure_3)
	elif current_measure == 4:
		spawn_notes_randomly(spawn_notes_measure_4)
	"""
	
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
	#print(song_position_in_beats)
	
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
	
	"""
	if song_position_in_beats > 36:
		spawn_notes_measure_1 = 1
		spawn_notes_measure_2 = 1
		spawn_notes_measure_3 = 1
		spawn_notes_measure_4 = 1
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
		emit_signal("level_ended")
	"""
	
	for n in range(notes_to_spawn.size()):
		if notes_to_spawn[n][0] == song_position_in_beats:
			for lane in notes_to_spawn[n][1]:
				instantiate_note(lane)
			
			# check if the note spawned is the last note
			if n == notes_to_spawn.size()-1:
				for _n_past in range(notes_to_spawn.size()):
					notes_to_spawn.pop_front()
		else:
			# remove all notes from notes_to_spawn[0] to notes_to_spawn[n-1]
			for _n_past in range(n):
				notes_to_spawn.pop_front()
				
			break
	
	if notes_to_spawn.size() == 0 and not has_level_started_ending:
		# wait until the last note is hit/missed, + 1 second, before ending level
		$EndTimer.wait_time = (Global.time_to_target+0.5) + 1
		$EndTimer.start()
		
		# only run this if statement once
		has_level_started_ending = true
# ---

# Spawn Notes
func instantiate_note(lane):
	var instance = note.instance()
	instance.initialize(lane)
	instance.connect("note_missed", self, "_on_Note_note_missed")
	
	if lane > 0:
		$HighwayGrowth.add_child(instance)
	elif lane < 0:
		$HighwayDecay.add_child(instance)

func instantiate_multiple_notes(lane1, lane2):	
	var note1_instance = note.instance()
	note1_instance.initialize(lane1)
	note1_instance.connect("note_missed", self, "_on_Note_note_missed")

	var note2_instance = note.instance()
	note2_instance.initialize(lane2)
	note2_instance.connect("note_missed", self, "_on_Note_note_missed")
		
	var note_bar_instance = note_bar.instance()
	note_bar_instance.initialize(lane1, lane2)
		
	note1_instance.partner_bar = note_bar_instance
	note2_instance.partner_bar = note_bar_instance
	
	if lane1 > 0:
		highway_growth.add_child(note1_instance)
		highway_growth.add_child(note2_instance)
		highway_growth.add_child(note_bar_instance)
	elif lane1 < 0:
		highway_decay.add_child(note1_instance)
		highway_decay.add_child(note2_instance)
		highway_decay.add_child(note_bar_instance)

#func instantiate_hold(lane, length):
	#var instance = hold.instance()
	#instance.initialize(lane, length)
	
	#if lane > 0:
	#	$HighwayGrowth.add_child(instance)
	#elif lane < 0:
	#	$HighwayDecay.add_child(instance)

func spawn_notes_randomly(number_of_notes_to_spawn):
	# called from _on_Conductor_send_measure()
	# recall: number_of_notes_to_spawn is the function parameter

	# Spawn Note on a Lane
	var lane_numbers = [1, 2, 3, -1, -2, -3]
	var chosen_lanes = []
	var lane

	for _i in range(number_of_notes_to_spawn):
		lane = lane_numbers[randi() % lane_numbers.size()]
		while lane in chosen_lanes:
			# loop  until it generates a random late that hasn't been chosen yet
			lane = lane_numbers[randi() % lane_numbers.size()]
		
		chosen_lanes.append(lane)

	for _lane in chosen_lanes:
		instantiate_note(lane)

# SIGNALS

func _on_ButtonGrowthLeft_button_pressed():
	emit_signal("button_pressed", "button_growth_left")

func _on_ButtonGrowthLeft_button_released():
	emit_signal("button_released", "button_growth_left")
	
func _on_ButtonGrowthCenter_button_pressed():
	emit_signal("button_pressed", "button_growth_center")

func _on_ButtonGrowthCenter_button_released():
	emit_signal("button_released", "button_growth_center")

func _on_ButtonGrowthRight_button_pressed():
	emit_signal("button_pressed", "button_growth_right")

func _on_ButtonGrowthRight_button_released():
	emit_signal("button_released", "button_growth_right")

func _on_ButtonDecayLeft_button_pressed():
	emit_signal("button_pressed", "button_decay_left")

func _on_ButtonDecayLeft_button_released():
	emit_signal("button_released", "button_decay_left")

func _on_ButtonDecayCenter_button_pressed():
	emit_signal("button_pressed", "button_decay_center")

func _on_ButtonDecayCenter_button_released():
	emit_signal("button_released", "button_decay_center")

func _on_ButtonDecayRight_button_pressed():
	emit_signal("button_pressed", "button_decay_right")
	
func _on_ButtonDecayRight_button_released():
	emit_signal("button_released", "button_decay_right")

# ---

func _on_ButtonGrowthLeft_score_incremented(input_type, score_to_add):
	# pass it from gameplay_orthogonal.tscn to gameplay.tscn
	emit_signal("score_incremented", input_type, score_to_add)

func _on_ButtonGrowthCenter_score_incremented(input_type, score_to_add):
	# pass it from gameplay_orthogonal.tscn to gameplay.tscn
	emit_signal("score_incremented", input_type, score_to_add)

func _on_ButtonGrowthRight_score_incremented(input_type, score_to_add):
	# pass it from gameplay_orthogonal.tscn to gameplay.tscn
	emit_signal("score_incremented", input_type, score_to_add)

func _on_ButtonDecayLeft_score_incremented(input_type, score_to_add):
	# pass it from gameplay_orthogonal.tscn to gameplay.tscn
	emit_signal("score_incremented", input_type, score_to_add)

func _on_ButtonDecayCenter_score_incremented(input_type, score_to_add):
	# pass it from gameplay_orthogonal.tscn to gameplay.tscn
	emit_signal("score_incremented", input_type, score_to_add)
	
func _on_ButtonDecayRight_score_incremented(input_type, score_to_add):
	# pass it from gameplay_orthogonal.tscn to gameplay.tscn
	emit_signal("score_incremented", input_type, score_to_add)
	
func _on_Note_note_missed(input_type):
	# pass it from gameplay_orthogonal.tscn to gameplay.tscn
	emit_signal("score_incremented", input_type, 0)

func _on_KeyGuidesTimer_timeout():
	$KeyGuides.visible = false

func _on_Conductor_song_info_loaded():
	choose_level_start()

func _on_EndTimer_timeout():
	emit_signal("level_ended")




