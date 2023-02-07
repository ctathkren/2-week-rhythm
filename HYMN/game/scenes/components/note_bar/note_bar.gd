extends Node2D

var left_note
var right_note

var note_type

# ---

# Vertical Positions (y)
const SPAWN_Y = -1000
const TARGET_Y = 800 # ~button Y
const DIST_TO_TARGET = TARGET_Y - SPAWN_Y

const HIGHWAY_BOTTOM_Y = 900

# Lane Positions (x, y)
const LEFT_CENTER_LANES_SPAWN   = Vector2(-100, SPAWN_Y)
const CENTER_RIGHT_LANES_SPAWN = Vector2(100, SPAWN_Y)
const LEFT_RIGHT_LANES_SPAWN  = Vector2(0, SPAWN_Y)

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

# Partner Note, for making a note bar spawn
var partner_note
var partner_note_bar


# FUNCTIONS
# LOCAL
func _ready():
	#set_note_type(get_parent().highway_type)
	pass

func _physics_process(delta):
	if position.y <= HIGHWAY_BOTTOM_Y:
		move_down(delta)
	# if button press missed and beyond highway bottom
	else:
		miss_delete()	
	
func move_down(delta):
	position.y += speed * delta
				
func label_move_up(delta):
	"""
	Node2D here is a parent that has the feedback label!
	Label is inside a Node2D for the Transform tab in editor
		reference wanted the label to move up for a while before timer deletes it and note
	"""

	$Node2D.position.y -= speed * delta

func miss_delete(): 
	# since destroy -> timer only called if note hit
		# need to delete note here if miss
	queue_free()


# GLOBAL
# Initialize
func _set_note_type(lane_left):
	if lane_left > 0:
		note_type = "growth"
		$NoteSprite.animation = "growth"
		$NoteGlowSprite.animation = "growth"
	elif lane_left < 0:
		note_type = "decay"
		$NoteSprite.animation = "decay"
		$NoteGlowSprite.animation = "decay"

func _set_frame_and_position(lane_left, lane_right):
	if abs(lane_left) == 1 and abs(lane_right) == 2:
		$NoteSprite.frame = "adjacent"
		$NoteGlowSprite.animation = "adjacent"
		position = LEFT_CENTER_LANES_SPAWN
	elif abs(lane_left) == 2 and abs(lane_right) == 3:
		$NoteSprite.frame = "adjacent"
		$NoteGlowSprite.animation = "adjacent"
		position = CENTER_RIGHT_LANES_SPAWN
	elif abs(lane_left) == 1 and abs(lane_right) == 3:
		$NoteSprite.frame = "adjacent"
		$NoteGlowSprite.animation = "adjacent"
		position = LEFT_RIGHT_LANES_SPAWN
	else:
		printerr('Invalid lanes set for note bar: ' + str(lane_left) + ' and ' + str(lane_right))
		return

func _get_speed():
	return DIST_TO_TARGET / time_to_target

func initialize(lane_left, lane_right): 
	# called by level.gd under _spawn_notes(to_spawn)
	# separate function because called outside
	_set_note_type(lane_left)
	_set_frame_and_position(lane_left, lane_right)

	speed = _get_speed()

# ---
		
func destroy():
	# "_on_NoteDeleteTimer_timeout()" handles "queue_free()"
	$NoteDeleteTimer.start()


# SIGNALS
# Note Deleting
func _on_NoteDeleteTimer_timeout():
	# gives time for particle effects and feedback label before deleting note
	queue_free()

