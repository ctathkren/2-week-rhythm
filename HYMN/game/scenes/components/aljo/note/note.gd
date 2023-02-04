extends Area2D

var note_type = "note"
var COLUMN_NUMBER

# not sure if we'll use these variables if our timing is Area2D-based
var correct_hit_time
var actual_hit_time

var SCROLL_SPEED = 300

# ---

func _ready():
	pass

func _physics_process(delta):
	position.y += SCROLL_SPEED * delta
	# move down by SCROLL_SPEED * delta * whatever mess is caused by the highway parallax
	# also move to the left/right based on the parallax
	pass

# ---
