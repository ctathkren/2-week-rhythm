extends Area2D

var NOTE_TYPE = "hold_body"
var column_number = 1

var hold_duration_in_beats

# ---

func _ready():
	pass

func _physics_process(delta):
	update_note_sprite()

# ---

func update_note_sprite():
	var animation_name = ""
	
	if column_number > 0:
		animation_name += "growth"
	elif column_number < 0:
		animation_name += "decay"
	
	animation_name += String(abs(column_number))
	
	#$HoldBodySprite.play(animation_name)
	#$HoldBodyGlowSprite.play(animation_name)
	
	#$HoldBodySprite

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
	queue_free()
	
func be_missed():
	# disappear abruptly
	
	
	# delete note
	queue_free()
