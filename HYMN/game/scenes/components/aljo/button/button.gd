extends Sprite

# VARIABLES
# Button Identifier
export var input = ""
	# set in editor which key each button is assigned to
	# MUST be exact key name in Project Settings>Input Map

# Notes
# Tracking
var hittable_notes = []

# Feedback
var hit_feedbacks = {
	"hit_perfect": false,
	"hit_good": false,
	"hit_miss": false
}

var hit_feedback_areas = {
	"hit_perfect": $PerfectArea,
	"hit_good": $GoodArea,
	"hit_miss": $EarlyMissArea
}

# FUNCTIONS
func _unhandled_input(event):
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

# ON KEY PRESS
func hit_score_and_destroy(score):
	get_parent().increment_score(score)

	current_note.destroy(score)
	hittable_notes[0].destroy(score)
func reset_note():
	# remove the bottommost note
	hittable_notes.pop_front()

	for key in hit_feedbacks.keys():
		hit_feedbacks[key] = false
		
	if hittable_notes.size() > 0:
		for key in hit_feedbacks.keys():
			# check every hit_feedback's judgement area if it overlaps with the new current note
			if hittable_notes[0].overlaps_area(hit_feedback_areas[key]):
				hit_feedbacks[key] = true

func hit_feedback():
	if hittable_notes.size() > 0:
		# .increment_score(score) called in level.gd
		# .destroy(score) called in Note.gd
		
		if hit_feedbacks.hit_perfect:
			hit_score_and_destroy(Global.Judgements.SCORE_PERFECT)
		elif hit_feedbacks.hit_good:
			hit_score_and_destroy(Global.Judgements.SCORE_GOOD)
		elif hit_feedbacks.hit_miss:
			hit_score_and_destroy(Global.Judgements.SCORE_MISS)
			
		reset_note()
	else:
		# THIS LINE USED TO CAUSE A LOT OF BUGS
		# because was set as "hit_score_and_destroy()"
		# when should only be "increment_score"
		get_parent().increment_score(Global.Judgements.SCORE_MISS)		

		# why do we hate ghost-tapping -lawrence


# SIGNALS
# NOTE CHECKING

# Perfect Areas
func _on_PerfectArea_area_entered(area):
	if area.is_in_group("note"):
		hit_feedbacks.hit_perfect = true
	elif area.is_in_group("hold_head"):
		hit_feedbacks.hit_perfect = true
	elif area.is_in_group("hold_tail"):
		hit_feedbacks.hit_perfect = true

func _on_PerfectArea_area_exited(area):
	if area.is_in_group("note"):
		hit_feedbacks.hit_perfect = false
	elif area.is_in_group("hold_head"):
		hit_feedbacks.hit_perfect = false
	elif area.is_in_group("hold_tail"):
		hit_feedbacks.hit_perfect = false

# Good Areas
func _on_GoodArea_area_entered(area):
	if area.is_in_group("note"):
		hit_feedbacks.hit_good = true
	elif area.is_in_group("hold_head"):
		hit_feedbacks.hit_good = true
	elif area.is_in_group("hold_tail"):
		hit_feedbacks.hit_good = true

func _on_GoodArea_area_exited(area):
	if area.is_in_group("note"):
		hit_feedbacks.hit_good = false
		hittable_notes.erase(area)
	elif area.is_in_group("hold_head"):
		hit_feedbacks.hit_good = false
		hittable_notes.erase(area)
	elif area.is_in_group("hold_tail"):
		hit_feedbacks.hit_good = false
		hittable_notes.erase(area)

# Early Miss Areas
# doubles as checker for considering if input should have an effect
# ex. if in early miss area, can hit; else not
func _on_EarlyMissArea_area_entered(area):
	if area.is_in_group("note"):
		hit_feedbacks.hit_miss = true
		hittable_notes.append(area)
	elif area.is_in_group("hold_head"):
		hit_feedbacks.hit_miss = true
		hittable_notes.append(area)
	elif area.is_in_group("hold_tail"):
		hit_feedbacks.hit_miss = true
		hittable_notes.append(area)

func _on_EarlyMissArea_area_exited(area):
	if area.is_in_group("note"):
		hit_feedbacks.hit_miss = false
	elif area.is_in_group("hold_head"):
		hit_feedbacks.hit_miss = false
	elif area.is_in_group("hold_tail"):
		hit_feedbacks.hit_miss = false
