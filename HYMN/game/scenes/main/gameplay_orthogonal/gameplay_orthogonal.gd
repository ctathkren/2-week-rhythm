extends Node2D

# VARIABLES

# SONG TRACKING
var bpm = 180
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

signal score_incremented(input_type, score_to_add)
signal level_ended

# Spawning
var note = load("res://game/scenes/components/note/note.tscn")
var note_bar = load("res://game/scenes/components/note_bar/note_bar.tscn")

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

	choose_level_start()
	

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

	#$Conductor.play_beats_before_start(beats_before_start)

	$Conductor.play_from_beat(30, 4)
	

# ON CONDUCTOR SIGNALS (from Conductor.gd)
func _on_Conductor_send_measure(current_measure):
	# sets how many notes to spawn depending on what measure it is
	
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
		$HighwayGrowth.add_child(note1_instance)
		$HighwayGrowth.add_child(note2_instance)
		$HighwayGrowth.add_child(note_bar_instance)
	elif lane1 < 0:
		$HighwayDecay.add_child(note1_instance)
		$HighwayDecay.add_child(note2_instance)
		$HighwayDecay.add_child(note_bar_instance)

func instantiate_hold(lane, duration_in_beats, BPM):
	pass
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

	for i in range(number_of_notes_to_spawn):
		lane = lane_numbers[randi() % lane_numbers.size()]
		while lane in chosen_lanes:
			# loop  until it generates a random late that hasn't been chosen yet
			lane = lane_numbers[randi() % lane_numbers.size()]
		
		chosen_lanes.append(lane)
	
	print(chosen_lanes.size())

	for l in chosen_lanes:
		instantiate_note(lane)

# SIGNALS

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
	print("deadge")
	# pass it from gameplay_orthogonal.tscn to gameplay.tscn
	emit_signal("score_incremented", input_type, 0)

