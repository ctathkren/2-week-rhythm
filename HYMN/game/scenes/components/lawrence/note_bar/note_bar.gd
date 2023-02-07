extends Node2D

var left_note
var right_note

# ---

func _ready():
	pass

func _physics_process(delta):
	if get_note_bar_length() == "adjacent":
		position.x = left_note.position.x + 100
	elif get_note_bar_length() == "far":
		position.x = left_note.position.x + 200
	
	position.y = left_note.position.y

# ---

func update_note_bar_sprite():
	var animation_name = get_note_bar_highway() + "_" + get_note_bar_length()
	$NoteBarSprite.play(animation_name)
	$NoteBarGlowSprite.play(animation_name)
	
func get_note_bar_highway():
	if left_note.get_column_number() > 0 && right_note.get_column_number() > 0:
		return "growth"
	elif left_note.get_column_number() < 0 && right_note.get_column_number() < 0:
		return "decay"
		
func get_note_bar_length():
	if right_note.get_column_number() - left_note.get_column_number() == 1:
		return "adjacent"
	elif right_note.get_column_number() - left_note.get_column_number() == 2:
		return "far"

# ---

func beHit():
	# fade out
	
	
	# delete note
	queue_free()
