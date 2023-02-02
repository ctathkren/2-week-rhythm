extends Node2D

var COLUMN_NUMBER = -1


var is_button_pressed = false
var is_there_a_hittable_note = false
var current_judgement

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	
	# ---
	
	if Input.is_action_just_pressed(getInputKey()):
		# change sprite to <pressed key> version
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

func _on_JudgementPerfect_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	# if button is pressed, then emit signal to score a perfect on this column
	
	pass # Replace with function body.

func _on_JudgementGood_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	# if button is pressed, then emit signal to score a good on this column
	
	pass # Replace with function body.

func _on_JudgementMissEarly_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	# if button is pressed, then emit signal to score a miss on this column (too early)

	pass # Replace with function body.

func _on_JudgementMissLate_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	# if a note reaches this part without being pressed, then emit signal to score a miss on this column

	pass # Replace with function body.
