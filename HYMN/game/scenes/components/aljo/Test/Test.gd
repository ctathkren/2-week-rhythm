extends Node2D

var feedback_score_to_texts_to_colors = [
	[3, "GREAT", "f6d6bd"],
	[2, "GOOD" , "c3a38a"],
	[1, "OKAY" , "997577"],
]

var nested_array_size = feedback_score_to_texts_to_colors.size()

func _ready():
	print("Nested Array Size: " + str(nested_array_size))
