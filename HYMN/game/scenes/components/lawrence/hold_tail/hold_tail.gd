extends Area2D

var NOTE_TYPE = "hold_tail"
var column_number = 1

# not sure if we'll use these variables if our timing is Area2D-based
var correct_hit_time
var actual_hit_time
var judgement = "hit_miss"

var partner_note_column
var partner_note_bar

# ---

func _ready():
	pass

func _physics_process(delta):
	update_note_sprite()
	
	pass

# ---

func update_note_sprite():
	var animation_name = ""
	
	if column_number > 0:
		animation_name += "growth"
	elif column_number < 0:
		animation_name += "decay"
	
	animation_name += String(abs(column_number))
	
	$HoldTailSprite.play(animation_name)
	$HoldTailGlowSprite.play(animation_name)

func get_note_type():
	return NOTE_TYPE
	
func get_column_number():
	return column_number
	
func set_column_number(col):
	column_number = col
	update_note_sprite()

func get_judgement():
	return judgement
	
func set_judgement(j):
	judgement = j

# ---

func be_hit():
	# fade out
	
	
	# delete note
	queue_free()
	
func be_missed():
	# disappear abruptly
	
	
	# delete note
	queue_free()
