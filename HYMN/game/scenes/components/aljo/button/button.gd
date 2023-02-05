extends AnimatedSprite

# VARIABLES
# Button Identifier
export var input = ""
	# set in editor which key each button is assigned to
	# MUST be exact key name in Project Settings>Input Map

# Notes
# Tracking
var current_note = null

# Feedback
var hit_perfect = false
var hit_good = false
var hit_okay = false

# Scoring
const SCORE_PERFECT = 3
const SCORE_GOOD = 2
const SCORE_OKAY = 1
const SCORE_MISS = 0


# FUNCTIONS
func _unhandled_input(event):
	if event.is_action(input):

		if event.is_action_pressed(input, false):
			# registers all hits at the moment!
			# consider: .is_action_just_pressed

			"""
			notes on 2nd argument of:
			.is_action_pressed(action: String, exact: bool)

			- if exact == false
				- ignores additional input modifiers 
				- for InputEventKey and InputEventMouseButton events
				- and the direction for InputEventJoypadMotion events.
			"""

			hit_feedback()

			frame = 1
				# note: was under another if-statement with same condition
				# except 2nd argument was not given

		elif event.is_action_released(input):
			# consider: .is_action_just_released

			$AnimationTimer.start()
			# recall: timer is for reseting animation frame


# ON KEY PRESS
func hit_score_and_destroy(score):
	get_parent().increment_score(score)

	current_note.destroy(score)


func reset_note():
	current_note = null

	hit_perfect = false
	hit_good = false
	hit_okay = false


func hit_feedback():
	if not current_note == null:
		# recall: current_note is controlled by if note is in/out of Okay Area

		# .increment_score(score) called in level.gd
		# .destroy(score) called in Note.gd
		
		if hit_perfect:
			hit_score_and_destroy(SCORE_PERFECT)
		elif hit_good:
			hit_score_and_destroy(SCORE_GOOD)
		elif hit_okay:
			hit_score_and_destroy(SCORE_OKAY)
		reset_note()
	else:
		# THIS LINE USED TO CAUSE A LOT OF BUGS
		# because was set as "hit_score_and_destroy()"
		# when should only be "increment_score"
		get_parent().increment_score(SCORE_MISS)		


# SIGNALS

# ANIMATION FRAME TIMER
func _on_AnimationTimer_timeout():
	# reverts animation to default
	# reference uses 2-frame anim
	# highly customizable for us
	
	frame = 0


# NOTE CHECKING

# Okay Areas
# doubles as checker for considering if input should have an effect
# ex. if in okay area, can hit; else not
func _on_OkayArea_area_entered(area):
	if area.is_in_group("note"):
		hit_okay = true
		current_note = area


func _on_OkayArea_area_exited(area):
	if area.is_in_group("note"):
		hit_okay = false
		current_note = null


# Perfect Areas
func _on_PerfectArea_area_entered(area):
	if area.is_in_group("note"):
		hit_perfect = true


func _on_PerfectArea_area_exited(area):
	if area.is_in_group("note"):
		hit_perfect = false


# Good Areas
func _on_GoodArea_area_entered(area):
	if area.is_in_group("note"):
		hit_good = true


func _on_GoodArea_area_exited(area):
	if area.is_in_group("note"):
		hit_good = false

