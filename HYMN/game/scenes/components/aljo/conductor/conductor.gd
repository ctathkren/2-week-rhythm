extends AudioStreamPlayer

# VARIABLES
# Exports
export var bpm := 100
export var measures := 4

# Tracking the beat and song position
var song_position = 0.0
var song_position_in_beats = 1

var last_reported_beat = 0
var beats_before_start = 0

var measure = 1

# Determining how close to the beat an event is
var closest = 0
var time_off_beat = 0.0


# SIGNALS
signal beat(position)
signal measure(position)


# FUNCTIONS


func _on_StartTimer_timeout():
	pass # Replace with function body.
