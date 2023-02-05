extends Node2D

signal did_nothing
signal hit_perfect
signal hit_good
signal hit_miss

var column_number = 1

var hittable_notes = [] # Queue data structure; make sure that a button can only hit one note/hold at a time

# ---

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if Input.is_action_just_pressed(get_input_key()):
		if hittable_notes.size() > 0:		
			var current_note = hittable_notes.pop_front()
			
			if current_note.has_method("get_note_type"):
				if current_note.get_note_type() == "note":
					emit_signal(current_note.get_judgement())
					current_note.be_hit()
				elif current_note.get_note_type() == "hold":
					# TODO
					pass
					
# ---

# get Input Map name of input key from column number
func get_input_key():
	var input_key = "button_"
	
	if column_number > 0:
		input_key += "growth"
	elif column_number < 0:
		input_key += "decay"

	input_key += String(abs(column_number))
	
	return input_key

func get_column_number():
	return column_number
	
func set_column_number(col):
	column_number = col
	
# ---

func _on_JudgementMissEarly_area_entered(area):
	# if button is pressed, then emit signal to score a miss on this column (too early)

	# make sure that area is a note or a hold before adding it to hittable_notes
	if area.has_method("get_note_type"):
		if area.get_note_type() == "note":
			hittable_notes.append(area)
			area.set_judgement("hit_miss")
		elif area.get_note_type() == "hold_head":
			area.set_judgement("hit_miss")
		elif area.get_note_type() == "hold_tail":
			area.set_judgement("hit_miss")

func _on_JudgementGoodEarly_area_entered(area):
	if area.has_method("get_note_type"):
		if area.get_note_type() == "note":
			area.set_judgement("hit_good")
		elif area.get_note_type() == "hold_head":
			area.set_judgement("hit_good")
		elif area.get_note_type() == "hold_tail":
			area.set_judgement("hit_good")
			
func _on_JudgementPerfect_area_entered(area):
	if area.has_method("get_note_type"):
		if area.get_note_type() == "note":
			area.set_judgement("hit_perfect")
		elif area.get_note_type() == "hold_head":
			area.set_judgement("hit_perfect")
		elif area.get_note_type() == "hold_tail":
			area.set_judgement("hit_perfect")

func _on_JudgementGoodLate_area_entered(area):
	if area.has_method("get_note_type"):
		if area.get_note_type() == "note":
			area.set_judgement("hit_good")
		elif area.get_note_type() == "hold_head":
			area.set_judgement("hit_good")
		elif area.get_note_type() == "hold_tail":
			area.set_judgement("hit_good")

func _on_JudgementMissLate_area_entered(area):
	# if a note reaches this part without being pressed, then emit signal to score a miss on this column
	
	# make sure that area is a note or a hold before adding it to hittable_notes
	if area.has_method("get_note_type"):
		if area.get_note_type() == "note":
			emit_signal("hit_miss")
			
			# remove area from hittable_notes; area is actually hittable_notes[0]
			hittable_notes.pop_front()

			# hit area
			area.be_hit()
		elif area.get_note_type() == "hold_head":
			area.set_judgement("hit_miss")









