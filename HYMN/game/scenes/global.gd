extends Node2D

# VARIABLES

# Settings
var enable_hidden_mod = false
var time_to_hit_target = 1.5

# Level Unlocks
var growth_passed := false
var decay_passed := false

# End Game Scene
#var level_name := ""
#var score_end = 0
var laurels_earned := 0

# Level loading
var path_to_level_to_load = "" # path to Level folder

# Judgement Values
enum Judgements {
	SCORE_MISS,
	SCORE_GOOD,
	SCORE_PERFECT
}

var ACCURACY_WEIGHTS = {
	Judgements.SCORE_PERFECT: 1.0,
	Judgements.SCORE_GOOD: 0.5,
	Judgements.SCORE_MISS: 0.0
}

var level_info = {
	# preset via level file
	"title": "",
	"bpm": 0, #  placeholder default BPM
	"audio_file_path": "",
	"background_file_path": "",
	"notes": [
		
	],
	
	# set upon loading a level
	"level_folder_path": "",
	
	# computed from preset level info
	"number_of_notes": {
		"growth": 0,
		"decay": 0,
		"combined": 0
	}
}

# In-Game Scoring
var score_stats = {
	"growth": {	
		# Note Hit Feedback
		"score_feedback_to_button_hit_feedback": {
			Judgements.SCORE_PERFECT : 0,
			Judgements.SCORE_GOOD : 0,
			Judgements.SCORE_MISS : 0
		},
		
		# Computed Accuracies
		"active_accuracy": 100.0,
		"rampup_accuracy": 0.0
	},
	"decay": {		
		# Note Hit Feedback
		"score_feedback_to_button_hit_feedback": {
			Judgements.SCORE_PERFECT : 0,
			Judgements.SCORE_GOOD : 0,
			Judgements.SCORE_MISS : 0
		},
		
		# Computed Accuracies
		"active_accuracy": 100.0,
		"rampup_accuracy": 0.0
	},
	"combined": {
		# Scoring
		"score": 0,
		
		# Combos
		"combo": 0,
		"max_combo": 0,
		
		# Note Hit Feedback
		"score_feedback_to_button_hit_feedback": {
			Judgements.SCORE_PERFECT : 0,
			Judgements.SCORE_GOOD : 0,
			Judgements.SCORE_MISS : 0
		},
		
		# Computed Accuracies
		"active_accuracy": 100.0,
		"rampup_accuracy": 0.0
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
	
	if score_stats.combined.active_accuracy >= 80:
		laurels_earned = 3
	elif score_stats.combined.active_accuracy >= 50:
		laurels_earned = 2
	elif score_stats.combined.active_accuracy >= 20:
		laurels_earned = 1
	else:
		laurels_earned = 0
	
	"""
	for highest_score in highest_score_to_grade:
		if score_stats.combined.score >= highest_score:
			grade = highest_score_to_grade[highest_score]
			break
	"""

func reset_level_info():
	level_info = {
		# preset via level file
		"title": "",
		"bpm": 0, #  placeholder default BPM
		"audio_file_path": "",
		"background_file_path": "",
		"notes": [
			
		],
		
		# set upon loading a level
		"level_folder_path": "",
		
		# computed from preset level info
		"number_of_notes": {
			"growth": 0,
			"decay": 0,
			"combined": 0
		}
	}
