extends AudioStreamPlayer

# VARIABLES
# Exports
export var bpm := 100
export var measures := 4

# Tracking the beat and song position
var time = 0.0 # song_position
var beat = 1 # song_position_in_beats; does not repeat (1, 2, 3, 4, *5*, ...)
var measure = 1 # repeats (1, 2, 3, 4, *1*, ...)

var seconds_per_beat = 60.0 / bpm # seconds_per_beat; for conversion to beats

var last_reported_beat = 0
var beats_before_start = 0

# Determining how close to the beat an event is
var closest_beat = 0 # best to specify
var time_off_beat = 0.0


# SIGNALS
signal send_beat(position)
signal send_measure(position)


# FUNCTIONS
# Loop
func _physics_process(_delta): 
	# _physics_process for most consistent call-time intervals

	if playing: # AudioStreamPlayer.playing
		time = get_time()
		beat = get_beat(time)
		report_beat_to_game()


# Calculate Time & Beat
func get_time():
	time = get_playback_position()
	time += AudioServer.get_time_since_last_mix()
	time -= AudioServer.get_output_latency()

	return time


func get_beat(seconds):
	beat = seconds / seconds_per_beat
	beat = floor(beat) # round down
	beat = int(beat) # beats are whole numbers
	beat += beats_before_start # account for notes that need to play before song starts

	return beat


# Report Beat to Game
func reset_overshot_measures():
	if measure > measures:
		measure = 1


func send_beat_and_measure():
	# received by "game/play.gd" as "_on_Conductor_send_beat/measure(beat/measure)"

	emit_signal("send_beat", beat)
	emit_signal("send_measure", measure)


func update_beat_and_measure():
	last_reported_beat = beat
	measure += 1


func report_beat_to_game():
	# called in "_physics_process(delta)" and "_on_StartTimer_timeout()"

	if last_reported_beat < beat: # security measure? not sure why this if statement yet
		reset_overshot_measures()
		send_beat_and_measure()
		update_beat_and_measure()


# Play beats before start
func set_beats_before_start(beats):
	return beats


func set_start_timer():
	$StartTimer.wait_time = seconds_per_beat
	$StartTimer.start()


func play_beats_before_start(beats):
	# called in "Game.gd" under "_ready()"
	# used to set how many beats before start song
	# sets and starts the one-shot timer
	# called once

	beats_before_start = set_beats_before_start(beats)
	set_start_timer()

	

# idk where this is used yet
func get_closest_beat(seconds, nth_beat): # time, beat
	var current_beat
	current_beat = (seconds / seconds_per_beat)
	current_beat /= nth_beat
	current_beat = round(current_beat)
	current_beat = int(current_beat)

	closest_beat = current_beat * nth_beat

	time_off_beat = abs(closest_beat * seconds_per_beat - time)

	return Vector2(closest_beat, time_off_beat)


# idk, but seems to be a shortcut to specific times, and with offset before music
func play_from_beat(seconds, beats_offset):
	# jump to time
	play()
	seek(seconds * seconds_per_beat)

	# set offset before music
	beats_before_start = beats_offset

	# set measure
	measure = beat % measures


# stopped here
func _on_StartTimer_timeout(): 
	# oneshot, NOT auto-start time
	# to account for beats before start playing music
	# set and started via "play_with_beat_offset(num)"

	beat += 1

	if beat < beats_before_start - 1:
		$StartTimer.start()
	elif beat == beats_before_start - 1:
		var time_adjustments = AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency()
		$StartTimer.wait_time = $StartTimer.wait_time - time_adjustments
		$StartTimer.start()
	else:
		play()
		$StartTimer.stop()

	report_beat_to_game()
