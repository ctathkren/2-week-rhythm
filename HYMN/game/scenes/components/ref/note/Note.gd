extends Area2D


# VARIABLES
# Vertical Positions (y)
const SPAWN_Y = -16
const TARGET_Y = 164 # ~button Y

const DIST_TO_TARGET = TARGET_Y - SPAWN_Y

# Lane Positions (x, y)
const LEFT_LANE_SPAWN   = Vector2(120, SPAWN_Y)
const CENTER_LANE_SPAWN = Vector2(160, SPAWN_Y)
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
	
# Tracking
var hit = false

# Sprites
var sprite_frames_to_lane_positions = {
	0 : LEFT_LANE_SPAWN,
	1 : CENTER_LANE_SPAWN,
	2 : RIGHT_LANE_SPAWN,
}


# FUNCTIONS
# LOCAL
func _physics_process(delta):
	if !hit:
		position.y += speed * delta
		if position.y > 200:
			queue_free()
			get_parent().reset_combo()
	else:
		$Node2D.position.y -= speed * delta


# GLOBAL
func set_frame_and_position(lane):
	# reference used an AnimatedSprite
		# for arrow image directions, not animations
	# position: self.position

	"""
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

	# optimization for above if-elif-else statement:

	for frame in range(len(sprite_frames_to_lane_positions.keys())):
		# frame #0,1,2...

		if lane == frame:
			# recall: lane is the function argument

			$AnimatedSprite.frame = frame
			position = sprite_frames_to_lane_positions[frame]
		else:
			printerr("Invalid lane set for note: " + str(lane))
			return


func set_speed():
	return DIST_TO_TARGET / time_to_target


func initialize(lane):
	# called by Game.gd under _spawn_notes(to_spawn)
	# separate function because called outside

	set_frame_and_position(lane)

	speed = set_speed()


func destroy(score):
	# called from ArrowButton.gd

	$CPUParticles2D.emitting = true
	$AnimatedSprite.visible = false
	
	$Timer.start()
	
	hit = true
	
	if score == 3:
		$Node2D/Label.text = "GREAT"
		$Node2D/Label.modulate = Color("f6d6bd")
	elif score == 2:
		$Node2D/Label.text = "GOOD"
		$Node2D/Label.modulate = Color("c3a38a")
	elif score == 1:
		$Node2D/Label.text = "OKAY"
		$Node2D/Label.modulate = Color("997577")
	else:
		pass
		# empty for now to make accommodate SCORE_MISS
		# in note_ ArrowButton.gd


# SIGNALS
func _on_Timer_timeout():
	queue_free()
