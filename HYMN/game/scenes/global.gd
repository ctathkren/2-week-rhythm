extends Node2D

# VARIABLES

### Settings
var enable_nofail = false
var time_to_target = 1.5

var settings = {
	"volume": {
		# 100/100
		"master": 60,
		"music": 60,
		"sfx": 60
	},
	'controls': {
		"button_growth1": 'S',
		"button_growth2": 'D',
		"button_growth3": 'F',
		"button_decay1": 'J',
		"button_decay2": 'K',
		"button_decay3": 'L'
	}
}

func get_music_volume_muliplier() -> float:
	return (settings["volume"]["master"]/100.0) * (settings["volume"]["music"]/100.0)
	
func get_sfx_volume_muliplier() -> float:
	return (settings["volume"]["master"]/100.0) * (settings["volume"]["sfx"]/100.0)

### Global Constants
# Judgement Values
enum Judgements {
	SCORE_MISS,
	SCORE_GOOD,
	SCORE_PERFECT
}

var ACCURACY_WEIGHTS = {
	Judgements.SCORE_PERFECT : 1.0,
	Judgements.SCORE_GOOD : 0.5,
	Judgements.SCORE_MISS : 0.0
}

# Level Unlocks
var is_level_unlocked = {
	"growth_easy": true,
	"decay_easy": true,
	"growth_hard": true,
	"decay_hard": true
}

### Level Start
# Level loading
var path_to_level_to_load = "" # path to Level folder

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

### Level End
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

# End Game Scene
var laurels_earned := 0

# Post-Game Scoring
var laurel_accuracy_thresholds = {
	90 : 3,
	50 : 2,
	20 : 1,
	0 : 0
}


# FUNCTIONS
func reset_level_info():
	level_info = {
		# preset via level file
		"title": "",
		"bpm": 0,
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


func set_score_stats(stats):
	score_stats = stats
	
	# change accuracy to score once we decide on score thresholds
		# note that we might need to add a way to score multiple score thresholds per map
		# that, or we calculate it manually from the number of notes
		# however, with our scoring system, getting laurels would be very combo-oriented
	for minimum_accuracy in laurel_accuracy_thresholds:
		if score_stats.combined.active_accuracy >= minimum_accuracy:
			laurels_earned = laurel_accuracy_thresholds[minimum_accuracy]
			break
