extends Area2D

# VARIABLES
var note_type
var NOTE_OBJECT_TYPE = "note"

signal note_missed

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

# Partner Note, for making a note bar spawn
var partner_note
var partner_note_bar


# FUNCTIONS
# LOCAL
func _ready():
	#set_note_type(get_parent().highway_type)
	pass


func _physics_process(delta):
	# recall: button_hit_ok means the correct button was pressed while note is in Okay Area
	
	if not button_hit_ok:
		# while note hasn't reached highway bottom
		if position.y <= HIGHWAY_BOTTOM_Y:
			move_down(delta)

		# if button press missed and beyond highway bottom
		else:
			miss_delete()		
	else: 
		# if button_hit_ok
		label_move_up(delta)
		
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
	# .reset_combo() defined in level.gd
	emit_signal("note_missed", note_type)
	
	# since destroy -> timer only called if note hit
		# need to delete note here if miss
	queue_free()

# GLOBAL
# Initialize
func _set_note_type(lane):
	if lane > 0:
		note_type = "growth"
		$NoteSprite.animation = "growth"
		$NoteGlowSprite.animation = "growth"
	elif lane < 0:
		note_type = "decay"
		$NoteSprite.animation = "decay"
		$NoteGlowSprite.animation = "decay"

func _set_frame_and_position(lane):
	if abs(lane) == 1:
		$NoteSprite.frame = 0
		$NoteGlowSprite.frame = 0
		position = LEFT_LANE_SPAWN
	elif abs(lane) == 2:
		$NoteSprite.frame = 1
		$NoteGlowSprite.frame = 1
		position = CENTER_LANE_SPAWN
	elif abs(lane) == 3:
		$NoteSprite.frame = 2
		$NoteGlowSprite.frame = 2
		position = RIGHT_LANE_SPAWN
	else:
		printerr('Invalid lane set for note: ' + str(lane))
		return

func _get_speed():
	return DIST_TO_TARGET / time_to_target

func initialize(lane): 
	# called by level.gd under _spawn_notes(to_spawn)
	# separate function because called outside
	_set_note_type(lane)
	_set_frame_and_position(lane)

	speed = _get_speed()

# ---

# Destroy
func visual_effects():
	$CPUParticles2D.emitting = true

	$NoteSprite.visible = false
	$NoteGlowSprite.visible = false

func update_feedback_label(score):	
	if score != Global.Judgements.SCORE_MISS:
		$Node2D/FeedbackLabel.text = feedback_score_to_text_and_color[score][0]
		$Node2D/FeedbackLabel.modulate = feedback_score_to_text_and_color[score][1]
	else:
		pass
		# empty for now to accommodate const SCORE_MISS
			# defined in hit_score_and_destroy(score)
			# under button.gd
		
func destroy(score):
	# called from button.gd
	# an "on-every-valid-button-press" function
	visual_effects()
	
	# "_on_NoteDeleteTimer_timeout()" handles "queue_free()"
	$NoteDeleteTimer.start()
	
	# Movement Tracking (_physics_process())
	button_hit_ok = true

	update_feedback_label(score)
	
	if partner_note_bar != null:
		destroy(partner_note_bar)


# SIGNALS
# Note Deleting
func _on_NoteDeleteTimer_timeout():
	# gives time for particle effects and feedback label before deleting note
	queue_free()