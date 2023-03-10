extends AudioStreamPlayer

"""
Conductor
	- compares time of events(button press) to beats -> perfect, good, early, late, miss
	- tracks current measure and beat
		- since measures have repeated patterns, beats can override these
		- ex. growth1 note every 3rd measure; on beat#9, change to decay3 note
	- determines exact song position (time, in seconds)
		- since software & hardware clocks are not 100% synced
		- and sound doesn't play asap in godot
		- gives us control and accuracy
"""

signal song_info_loaded

# VARIABLES
# Exports
	# depends PER SONG
	# set via editor view of conductor node
	# walrus case (:=) for explicit type declaration in editor
var bpm = 180
export var measures := 4

# Tracking the beat and song position
var position_in_seconds = 0.0 # prev.: song_position
var position_in_beats = 0
	# prev.: song_position_in_beats
	# does not repeat (1, 2, 3, 4, *5*, ...)
var measure = 1
	# repeats (1, 2, 3, 4, *1*, ...)
	# can use to repeat notes on certain measures
		# ex. growth1 note every 3rd measure

var seconds_per_beat = 60.0/bpm
	# for conversion from seconds to beats

var last_reported_beat = 0
var beats_before_start = 0

# Determining how close to the beat an event is
var closest_beat = 0 # best to specify
var time_off_beat = 0.0


# SIGNALS
	# report EVERY CURRENT beat & measure TO GAME SCENE
signal send_measure(current_measure)
signal send_beat(current_beat)


# FUNCTIONS

# LOOPS

# Game Loop
func _physics_process(_delta): 
	# _physics_process for most consistent call-time intervals

	if playing: # AudioStreamPlayer.playing
		update_position_values()
		report_beat_to_game()

func load_song_info(full_audio_file_path, bpm_to_load):
	stream = load(full_audio_file_path)
	bpm = bpm_to_load
	seconds_per_beat = 60.0 / bpm
	
	emit_signal("song_info_loaded")

# Get Position Values (seconds, beats)
func get_position_in_seconds():
	position_in_seconds = get_playback_position()
		# AudioStreamPlayer.get_playback_position()
		# gives "rounded" position
	position_in_seconds += AudioServer.get_time_since_last_mix()
		# "smooths" the position with slight additions for accuracy
	position_in_seconds -= AudioServer.get_output_latency()
		# accounts for time from computer playing sound and human hearing it
	
	return position_in_seconds

func get_position_in_beats(seconds):
	position_in_beats = seconds / seconds_per_beat
	position_in_beats = floor(position_in_beats) # gets last beat passed to game via signal
	position_in_beats = int(position_in_beats) # beats are integers
	position_in_beats += beats_before_start # account for notes played before song starts

	return position_in_beats

func update_position_values():
	position_in_seconds = get_position_in_seconds()
	position_in_beats = get_position_in_beats(position_in_seconds)

# ---

func send_beat():
	# received by "game/play.gd" as "_on_Conductor_send_beat(beat)"
	emit_signal("send_beat", position_in_beats)
	emit_signal("send_measure", measure)

func update_last_reported_beat():
	last_reported_beat = position_in_beats
		# for checking in report_beat_to_game() if statement
		# every beat reported only once

func report_beat_to_game():
	# separate function because called in different places
	# "_physics_process(delta)" and "_on_StartTimer_timeout()"

	if position_in_beats > last_reported_beat: 
		# ensures a beat is only reported once
		# recall: called in _physics_process (looped)
		send_beat()
		update_last_reported_beat()

# ONREADY (once, called in level.gd)

# Play needed notes before start of song
func get_beats_before_start(beats):
	return beats

func set_start_timer():
	$StartTimer.wait_time = seconds_per_beat
		# recall: timers use seconds
		# ex. 60 sec / 180 bpm = 0.33 sec
	$StartTimer.start()


func get_wait_time_adjustments():
	var seconds
	seconds = AudioServer.get_time_to_next_mix()
	seconds += AudioServer.get_output_latency()

	return seconds


func _on_StartTimer_timeout():
	"""
	Start Timer
		- initially oneshot (but not in practice)
		- NOT auto-start timer
		- set and started via set_start_timer() under play_with_beat_offset(num)
		- 1 timeout = 1 beat in seconds
		
		- Desired effect:
			- if level.gd passes 8 beats to play_beats_before_start(beats)
			- then, the timer will wait the time in seconds to play 1 beat
			- it will do this 8 times
			- then, it plays the song
	"""

	position_in_beats += 1
		# let's the timer know what beat it's on for if statement below

	# at start of level
	if position_in_beats < beats_before_start - 1:
		# recall: beats_before_start was just set using set_beats_before_start()
		
		$StartTimer.start()
	
	# on the beat right before song starts
	elif position_in_beats == beats_before_start - 1:
		# accounts for delay before AudioStreamPlayer.play() works

		var wait_time_adjustments = get_wait_time_adjustments()
		$StartTimer.wait_time = $StartTimer.wait_time - wait_time_adjustments

		$StartTimer.start()

	# when song should start
	else:
		play()

		$StartTimer.stop()

	report_beat_to_game()


func play_beats_before_start(beats):
	"""
	Play Beats Before Start

	- the normal way to start the level
	- called only once in level.gd under _ready()
	- used to set how many beats before start song
	- sets and starts the one-shot timer
	- argument (beats) is set manaually IN level.gd
		- might want to move it here as export along with bpm and measures
	"""
	
	beats_before_start = get_beats_before_start(beats)
	set_start_timer()

	
# Play from Beat (a convenience)
func play_from_beat(seconds, beats_offset):
	# jump to time
	play()
	seek(seconds * seconds_per_beat) # AudioStreamPlayer.seek()

	# set offset before music
	beats_before_start = beats_offset

	# set measure
	measure = position_in_beats % measures


# idk where this is used yet, wasn't mentioned in vid
# possible: button.gd or note.gd
# possible: used for play_from_beat(), passes vector2
# lawrence says: it's a failsafe, but we'll have to figure out where to call it
func get_closest_beat(seconds, nth_beat): # time, beat
	var current_beat
	current_beat = (seconds / seconds_per_beat)
	current_beat /= nth_beat
	current_beat = round(current_beat)
	current_beat = int(current_beat)

	closest_beat = current_beat * nth_beat

	time_off_beat = abs(closest_beat * seconds_per_beat - position_in_seconds)

	return Vector2(closest_beat, time_off_beat)
