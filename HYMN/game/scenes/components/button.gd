extends Node2D

var COLUMN_NUMBER = -1

var hittable_notes = [] # Queue data structure; make sure that a button can only hit one note/hold at a time

signal do_nothing
signal hit_perfect
signal hit_good
signal hit_miss

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if Input.is_action_just_pressed(getInputKey()):
		if hittable_notes.size() > 0:		
			var current_note = hittable_notes.pop_front()
			
			if current_note.has_method("getNoteType"):
				if current_note.getNoteType() == "note":
					emit_signal(current_note.getJudgement())
					current_note.beHit()
				elif current_note.getNoteType() == "hold":
					# TODO
					pass
	
# ---

# get Input Map name of input key from column number
func getInputKey():
	var input_key = "button_"
	
	if COLUMN_NUMBER > 0:
		input_key += "growth"
	elif COLUMN_NUMBER < 0:
		input_key += "decay"

	input_key += String(abs(COLUMN_NUMBER))
	
	return input_key

# ---

func _on_JudgementMissEarly_area_entered(area):
	# if button is pressed, then emit signal to score a miss on this column (too early)

	# make sure that area is a note or a hold before adding it to hittable_notes
	if area.has_method("getNoteType"):
		if area.getNoteType() == "note":
			hittable_notes.append(area)
			area.setJudgement("hit_miss")
		elif area.getNoteType() == "hold":
			# TODO
			pass

func _on_JudgementGoodEarly_area_entered(area):
	if area.has_method("getNoteType"):
		if area.getNoteType() == "note":
			area.setJudgement("hit_good")
		elif area.getNoteType() == "hold":
			# TODO
			pass
			
func _on_JudgementPerfect_area_entered(area):
	if area.has_method("getNoteType"):
		if area.getNoteType() == "note":
			area.setJudgement("hit_perfect")
		elif area.getNoteType() == "hold":
			# TODO
			pass

func _on_JudgementGoodLate_area_entered(area):
	if area.has_method("getNoteType"):
		if area.getNoteType() == "note":
			area.setJudgement("hit_good")
		elif area.getNoteType() == "hold":
			# TODO
			pass

func _on_JudgementMissLate_area_entered(area):
	# if a note reaches this part without being pressed, then emit signal to score a miss on this column
	
	# make sure that area is a note or a hold before adding it to hittable_notes
	if area.has_method("getNoteType"):
		emit_signal("hit_miss")
		
		# remove area from hittable_notes; area is actually hittable_notes[0]
		hittable_notes.pop_front()

		# hit area
		area.beHit()









