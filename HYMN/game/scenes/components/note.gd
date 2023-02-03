extends Area2D

var note_type = "note"
var COLUMN_NUMBER

# not sure if we'll use these variables if our timing is Area2D-based
var correct_hit_time
var actual_hit_time
var judgement = "do_nothing"

var SCROLL_SPEED = 25 # just to make "scroll speed" itself a smaller number
var SCROLL_SPEED_MULTIPLIER = 20

# ---

func _ready():
	pass

func _physics_process(delta):
	# move down by SCROLL_SPEED * delta * whatever mess is caused by the highway parallax
	# also move to the left/right based on the parallax
	position.y += SCROLL_SPEED * SCROLL_SPEED_MULTIPLIER * delta	
	pass

# ---

func getNoteType():
	return note_type

func getJudgement():
	return judgement
	
func setJudgement(j):
	judgement = j

func beHit():
	# fade out
	
	
	# delete note
	queue_free()
