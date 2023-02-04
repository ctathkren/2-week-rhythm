extends Node2D

# VARIABLES

# In-Game Scoring
var combo = 0

var score = 0
var highest_score_to_grade = {
		250_000 : 'A+',
		200_000 : 'A' ,
		150_000 : 'A-',
		130_000 : 'B+',
		115_000 : 'B' ,
		100_000 : 'B-',
		85_000  : 'C+',
		70_000  : 'C' ,
		55_000  : 'C-',
		40_000  : 'D+',
		30_000  : 'D' ,
		20_000  : 'D-',
		10_000  : 'F' ,
	}

# Post-Game Scoring
var grade = "NA"

# Note Hit Feedback
var great = 0
var good = 0
var okay = 0
var missed = 0


# FUNCTIONS

func set_score(new_score):
	score = new_score

	# proposed optimization for BOTTOM if statement:
	
	for highest_score in highest_score_to_grade:
		if score > highest_score:
			grade = highest_score_to_grade[highest_score]
			break

	"""
	if score > 250000:
		grade = 'A+'
	elif score > 200000:
		grade = 'A'
	elif score > 150000:
		grade = 'A-'
	elif score > 130000:
		grade = 'B-'
	elif score > 115000:
		grade = 'B'
	elif score > 100000:
		grade = 'B-'
	elif score > 85000:
		grade = 'C+'
	elif score > 70000:
		grade = 'C'
	elif score > 55000:
		grade = 'C-'
	elif score > 40000:
		grade = 'D+'
	elif score > 30000:
		grade = 'D'
	elif score > 20000:
		grade = 'D-'
	else:
		grade = 'F'
	"""
