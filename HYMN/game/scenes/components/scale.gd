extends Node2D

# Called when the node enters the scene tree for the first time.

signal scale_overtipped

var TIP1_ACCURACY_THRESHOLD = 5.0
var TIP2_ACCURACY_THRESHOLD = 10.0
var OVERTIP_ACCRACY_THRESHOLD = 15.0

onready var bunny_growth_sprite = $BunnyGrowth
onready var bunny_decay_sprite = $BunnyDecay

func set_accuracies(rampup_accuracy_growth, rampup_accuracy_decay):
	var accuracy_difference = rampup_accuracy_growth - rampup_accuracy_decay
	
	# growth-favored
	if accuracy_difference >= OVERTIP_ACCRACY_THRESHOLD:
		bunny_growth_sprite.frame = 2
		emit_signal("scale_overtipped")
	elif accuracy_difference >= TIP2_ACCURACY_THRESHOLD:
		bunny_growth_sprite.frame = 2
	elif accuracy_difference >= TIP1_ACCURACY_THRESHOLD:
		bunny_growth_sprite.frame = 1
	else:
		bunny_growth_sprite.frame = 0
	
	# decay-favored
	if accuracy_difference <= -OVERTIP_ACCRACY_THRESHOLD:
		bunny_decay_sprite.frame = 2
		emit_signal("scale_overtipped")
	elif accuracy_difference <= -TIP2_ACCURACY_THRESHOLD:
		bunny_decay_sprite.frame = 2
	elif accuracy_difference <= -TIP1_ACCURACY_THRESHOLD:
		bunny_decay_sprite.frame = 1
	else:
		bunny_decay_sprite.frame = 0
