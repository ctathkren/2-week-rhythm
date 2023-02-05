extends Area2D


# VARIABLES
# Vertical Positions (y)
const SPAWN_Y = -80
const TARGET_Y = 910 # ~button Y

const DIST_TO_TARGET = TARGET_Y - SPAWN_Y

const HIGHWAY_BOTTOM_Y = 1050

# Lane Positions (x, y)
const LEFT_LANE_SPAWN   = Vector2(697, SPAWN_Y)
const CENTER_LANE_SPAWN = Vector2(950, SPAWN_Y)
const RIGHT_LANE_SPAWN  = Vector2(1199, SPAWN_Y)

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

# Hit Feedback
var feedback_score_to_texts_to_colors = [
		[3, "GREAT", "f6d6bd"],
		[2, "GOOD" , "c3a38a"],
		[1, "OKAY" , "997577"],
	]


# FUNCTIONS
# LOCAL
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


"""PASSED"""
func miss_delete(): 
	# since destroy -> timer only called if note hit
		# need to delete note here if miss
	queue_free()

	# .reset_combo() defined in level.gd
	get_parent().reset_combo()


# GLOBAL
# Initialize
func set_frame_and_position(lane):
	# reference used an AnimatedSprite
		# for arrow image directions, not animations
	# position: self.position

	if lane == 0:
		$AnimatedSprite.frame = 0
		position = LEFT_LANE_SPAWN
	elif lane == 1:
		$AnimatedSprite.frame = 1
		position = CENTER_LANE_SPAWN
	elif lane == 2:
		$AnimatedSprite.frame = 2
		position = RIGHT_LANE_SPAWN
	else:
		printerr('Invalid lane set for note: ' + str(lane))
		return

	"""
	# proposed optimization for above if statement:
	# on first test:
		# FAILED, but passed when reverted to old version
		# only lane 1 worked

	for frame in sprite_frames_to_lane_positions:
		# frame #0,1,2...
		# don't need to use range(len(dict.keys())) because keys == range
			# recall: keys = [0,1,2]; range(3) = [0,1,2]

		if lane == frame:
			# recall: lane is the function parameter

			$AnimatedSprite.frame = frame
			position = sprite_frames_to_lane_positions[frame]
			
		else:
			printerr('Invalid lane set for note: ' + str(lane))
			return
	"""


func set_speed():
	return DIST_TO_TARGET / time_to_target


"""PASSED"""
func initialize(lane): 
	# called by level.gd under _spawn_notes(to_spawn)
	# separate function because called outside

	set_frame_and_position(lane)

	speed = set_speed()


"""FAIL"""
#Destroy
func visual_effects():
	$CPUParticles2D.emitting = true
	$AnimatedSprite.visible = false


func feedback_label(score):

	if score == 3:
		$Node2D/Label.text = 'GREAT'
		$Node2D/Label.modulate = Color('f6d6bd')
	elif score == 2:
		$Node2D/Label.text = 'GOOD'
		$Node2D/Label.modulate = Color('c3a38a')
	elif score == 1:
		$Node2D/Label.text = 'OKAY'
		$Node2D/Label.modulate = Color('997577')
	else:
		pass
		# empty for now to accommodate const SCORE_MISS
			# defined in hit_score_and_destroy(score)
			# under button.gd
	

	"""
	# proposed optimization for above if-statement

	for row in feedback_score_to_texts_to_colors:
		if score == row[0]:
			$Node2D/Label.text = row[1]
			$Node2D/Label.modulate = Color(row[2])
		else:
			pass
		
	"""

func destroy(score):
	# called from button.gd
	# an "on-every-valid-button-press" function

	visual_effects()
	
	# "_on_Timer_timeout()" handles "queue_free()"
	$Timer.start()
	
	# Movement Tracking (_physics_process())
	button_hit_ok = true

	feedback_label(score)


# SIGNALS
# Note Deleting
func _on_Timer_timeout():
	# gives time for particle effects and feedback label before deleting note

	queue_free()
