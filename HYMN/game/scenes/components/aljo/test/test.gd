extends Node2D

var hit_perfect = true
var hit_good    = true
var hit_okay    = true

const SCORE_PERFECT = 3
const SCORE_GOOD    = 2
const SCORE_OKAY    = 1
const SCORE_MISS    = 0

var hit_feedbacks_to_score = {
	hit_perfect : SCORE_PERFECT,
	hit_good : SCORE_GOOD,
	hit_okay : SCORE_OKAY,
}


func _ready():
	print(hit_feedbacks_to_score.size())


"""
func _ready():
	hit_feedback()


func hit_feedback():
	for i in range(len(hit_feedbacks_to_score)):
		if feedback:
			hit_score_and_destroy(hit_feedbacks_to_score[feedback])

	
	if hit_perfect:
		hit_score_and_destroy(SCORE_PERFECT)
	elif hit_good:
		hit_score_and_destroy(SCORE_GOOD)
	elif hit_okay:
		hit_score_and_destroy(SCORE_OKAY)
	


func hit_score_and_destroy(score):
	print('Arguments passed: ' + str(score))

"""