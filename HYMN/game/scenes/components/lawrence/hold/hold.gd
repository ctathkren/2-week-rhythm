extends Node2D

var NOTE_TYPE = "hold"
var column_number = 1

var scroll_speed = 500		# pixels per second
var hold_duration_in_beats

# not sure if we'll use these variables if our timing is Area2D-based
var correct_hit_time
var actual_hit_time
var judgement = "do_nothing"



# ---

func _ready():
	pass

func _physics_process(delta):	
	# move down by scroll_speed * delta * whatever mess is caused by the highway parallax
	# also move to the left/right based on the parallax
	position.y += scroll_speed * delta	
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
	return NOTE_TYPE
	
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
