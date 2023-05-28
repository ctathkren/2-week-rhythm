extends Node2D

# Called when the node enters the scene tree for the first time.

signal scale_overtipped

var TIP1_ACCURACY_THRESHOLD = 5.0
var TIP2_ACCURACY_THRESHOLD = 10.0
var OVERTIP_ACCURACY_THRESHOLD = 15.0

# pixel locations wrt Sprites
var SPRITE_SIZE = Vector2(800,573)
var SCALE_BAR_SPRITE_CENTER = Vector2(400, 128)
var SCALE_LEFT_SPRITE_ANCHOR = Vector2(200, 149)
var SCALE_RIGHT_SPRITE_ANCHOR = Vector2(600, 149)

# pixel locations wrt Scale node
var SCALE_BAR_CENTER = SCALE_BAR_SPRITE_CENTER - SPRITE_SIZE/2
var SCALE_LEFT_ANCHOR = SCALE_LEFT_SPRITE_ANCHOR - SPRITE_SIZE/2
var SCALE_RIGHT_ANCHOR = SCALE_RIGHT_SPRITE_ANCHOR - SPRITE_SIZE/2

var current_scale_angle = 0

onready var bunny_growth_sprite = $BunnyGrowth
onready var bunny_decay_sprite = $BunnyDecay



func tilt_scale(angle_degrees):
	var angle = angle_degrees * PI/180
	
	$ScaleBar.position = SCALE_BAR_CENTER + ($ScaleBar.position - SCALE_BAR_CENTER).rotated(angle)
	$ScaleBar.rotate(angle)
	
	# To rotate position (x,y) around point (x,y)
		# position = point + (position - point).rotated(angle)
	# position = $ScaleLeft.position - SCALE_LEFT_ANCHOR
	# point = SCALE_BAR_CENTER
		# ($ScaleLeft.position - SCALE_LEFT_ANCHOR) = SCALE_BAR_CENTER + (($ScaleLeft.position - SCALE_LEFT_ANCHOR) - SCALE_BAR_CENTER).rotated(angle)
		# then simplify
	
	$ScaleLeft.position = SCALE_BAR_CENTER + ($ScaleLeft.position + SCALE_LEFT_ANCHOR - SCALE_BAR_CENTER).rotated(angle) - SCALE_LEFT_ANCHOR
	$ScaleRight.position = SCALE_BAR_CENTER + ($ScaleRight.position + SCALE_RIGHT_ANCHOR - SCALE_BAR_CENTER).rotated(angle) - SCALE_RIGHT_ANCHOR
	$BunnyGrowth.position = SCALE_BAR_CENTER + ($BunnyGrowth.position + SCALE_LEFT_ANCHOR - SCALE_BAR_CENTER).rotated(angle) - SCALE_LEFT_ANCHOR
	$BunnyDecay.position = SCALE_BAR_CENTER + ($BunnyDecay.position + SCALE_RIGHT_ANCHOR- SCALE_BAR_CENTER).rotated(angle) - SCALE_RIGHT_ANCHOR

func set_scale_angle(angle_degrees):
	# tilt_scale() only rotates by a relative angle; it does not store the current absolute angle
	tilt_scale(angle_degrees - current_scale_angle)
	current_scale_angle = angle_degrees

func set_accuracies(rampup_accuracy_growth, rampup_accuracy_decay):
	var accuracy_difference = rampup_accuracy_growth - rampup_accuracy_decay
	
	# dynamic scale angle based on accuracy difference
	var scale_angle = accuracy_difference * -50/OVERTIP_ACCURACY_THRESHOLD
	if scale_angle > 50:
		scale_angle = 50
	elif scale_angle < -50:
		scale_angle = -50
		
	set_scale_angle(scale_angle)
	
	# growth-favored
	if accuracy_difference >= TIP1_ACCURACY_THRESHOLD:
		bunny_decay_sprite.frame = 0
		
		if accuracy_difference >= OVERTIP_ACCURACY_THRESHOLD:
			bunny_growth_sprite.frame = 2
			emit_signal("scale_overtipped")
		elif accuracy_difference >= TIP2_ACCURACY_THRESHOLD:
			bunny_growth_sprite.frame = 2
		else:
			bunny_growth_sprite.frame = 1
	elif accuracy_difference <= -TIP1_ACCURACY_THRESHOLD:
		bunny_growth_sprite.frame = 0
		
		if accuracy_difference <= -OVERTIP_ACCURACY_THRESHOLD:
			bunny_decay_sprite.frame = 2
			emit_signal("scale_overtipped")
		elif accuracy_difference <= -TIP2_ACCURACY_THRESHOLD:
			bunny_decay_sprite.frame = 2
		else:
			bunny_decay_sprite.frame = 1
	else:
		bunny_growth_sprite.frame = 0
		bunny_decay_sprite.frame = 0
