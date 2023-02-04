extends Node2D

var left_note
var right_note

# ---

func _ready():
	pass

func _physics_process(delta):
	if getNoteBarLength() == "adjacent":
		position.x = left_note.position.x + 100
	elif getNoteBarLength() == "far":
		position.x = left_note.position.x + 200
	
	position.y = left_note.position.y

# ---

func updateNoteBarSprite():
	var animation_name = getNoteBarHighway() + "_" + getNoteBarLength()
	$NoteBarSprite.play(animation_name)
	
func getNoteBarHighway():
	if left_note.getColumnNumber() > 0 && right_note.getColumnNumber() > 0:
		return "growth"
	elif left_note.getColumnNumber() < 0 && right_note.getColumnNumber() < 0:
		return "decay"
		
func getNoteBarLength():
	if right_note.getColumnNumber() - left_note.getColumnNumber() == 1:
		return "adjacent"
	elif right_note.getColumnNumber() - left_note.getColumnNumber() == 2:
		return "far"

func beHit():
	# fade out
	
	
	# delete note
	queue_free()
