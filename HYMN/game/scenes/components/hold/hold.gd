extends Node2D

# VARIABLES
var note_type
var NOTE_OBJECT_TYPE = "hold"

# Vertical Positions (y)
const SPAWN_Y = -1000
const TARGET_Y = 800 # ~button Y
const DIST_TO_TARGET = TARGET_Y - SPAWN_Y

const HIGHWAY_BOTTOM_Y = 900

# Lane Positions (x, y)
const LEFT_LANE_SPAWN   = Vector2(-200, SPAWN_Y)
const CENTER_LANE_SPAWN = Vector2(0, SPAWN_Y)
const RIGHT_LANE_SPAWN  = Vector2(200, SPAWN_Y)

# Speed
var speed = 0

"""
Note Movement Speed
	# doesn't seem like bpm is involved?
		# lawrence wanted this
	# if so, is hardcoded?
	# found a formula under initialize()
		# speed = DIST_TO_TARGET / 2.0
		# the 2.0 is for time it takes to reach target
"""

var time_to_target = 2.0 
	
# Movement Tracking
var button_hit_ok = false

# Sprite Handling
var sprite_frames_to_lane_positions = {
	0 : LEFT_LANE_SPAWN,
	1 : CENTER_LANE_SPAWN,
	2 : RIGHT_LANE_SPAWN,
}

# Hit Feedback to Label Text and Label Color
var feedback_score_to_text_and_color = {
  Global.Judgements.SCORE_PERFECT : ["PERFECT", "f6d6b6"],
  Global.Judgements.SCORE_GOOD : ["GOOD", "c3a38a"],
}

# ---

func _ready():
	pass

func _physics_process(delta):	
	# move down by scroll_speed * delta * whatever mess is caused by the highway parallax
	# also move to the left/right based on the parallax
	pass

# ---

func set_scroll_speed(spd):
	scroll_speed = spd
	
func set_hold_duration_in_beats(hold_dur):
	hold_duration_in_beats = hold_dur
	
	#$HoldBodySprite.update_note_sprite()
	#$HoldBodyGlowSprite.update_note_sprite()

func update_note_sprite():
	var animation_name = ""
	
	if column_number > 0:
		animation_name += "growth"
	elif column_number < 0:
		animation_name += "decay"
	
	animation_name += String(abs(column_number))
	
	$NoteSprite.play(animation_name)
	$NoteGlowSprite.play(animation_name)

func get_note_type():
	return NOTE_INPUT_TYPE
	
func get_column_number():
	return column_number
	
func set_column_number(col):
	column_number = col
	update_note_sprite()

# ---

func be_hit():
	# fade out
	
	
	# delete note
	# find a way to only queue_free once all the 3 parts area are also freed
	queue_free()

# if the HoldHead is not hit perfectly, then the HoldBody and HoldTail just disappear
func be_partly_hit():
	# disappear abruptly
	
	
	# delete note
	queue_free()
