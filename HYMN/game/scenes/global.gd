extends Node2D

# VARIABLES
var enable_hidden_mod = false

# Level Unlocks
var growth_passed := false
var decay_passed := false

# Judgement Values
enum Judgements {
	SCORE_MISS,
	SCORE_GOOD,
	SCORE_PERFECT
}

var level_info = {
	"title": "",
	"bpm": 180, #  placeholder default BPM
	"audio_file_path": "",
	"background_file_path": "",
	"notes": [
		
	]
}

# In-Game Scoring
var score_stats = {
	"growth": {	
		# Note Hit Feedback
		score_feedback_to_button_hit_feedback = {
			Judgements.SCORE_PERFECT : 0,
			Judgements.SCORE_GOOD : 0,
			Judgements.SCORE_MISS : 0
		}
	},
	"decay": {		
		# Note Hit Feedback
		score_feedback_to_button_hit_feedback = {
			Judgements.SCORE_PERFECT : 0,
			Judgements.SCORE_GOOD : 0,
			Judgements.SCORE_MISS : 0
		}
	},
	"combined": {
		# Scoring
		"score": 0,
		
		# Combos
		"combo": 0,
		"max_combo": 0,
		
		# Note Hit Feedback
		score_feedback_to_button_hit_feedback = {
			Judgements.SCORE_PERFECT : 0,
			Judgements.SCORE_GOOD : 0,
			Judgements.SCORE_MISS : 0
		}
	}
}

# Post-Game Scoring
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
var grade = "NA"


# FUNCTIONS

func set_score_stats(stats):
	score_stats = stats
	
	for highest_score in highest_score_to_grade:
		if score_stats.combined.score >= highest_score:
			grade = highest_score_to_grade[highest_score]
			break
