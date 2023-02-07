extends Area2D

var NOTE_TYPE = "note"
var column_number = 1

var scroll_speed = 500		# pixels per second

# not sure if we'll use these variables if our timing is Area2D-based
var judgement = "do_nothing"

var partner_note
var partner_note_bar

# ---

func _ready():
	pass

func _physics_process(delta):
	update_note_sprite()
	
	# move down by SCROLL_SPEED * delta * whatever mess is caused by the highway parallax
	# also move to the left/right based on the parallax
	position.y += scroll_speed * delta	
	pass

# ---

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
	
