extends Spatial

onready var gameplay_node = $GameplayViewport/GameplayOrthogonal

signal button_pressed(lane)
signal button_released(lane)
signal score_incremented(input_type, score_to_add)
signal level_ended

func load_level_info(full_audio_file_path, bpm, notes):
	gameplay_node.load_level_info(full_audio_file_path, bpm, notes)

func _on_GameplayOrthogonal_button_pressed(lane):
	emit_signal("button_pressed", lane)

func _on_GameplayOrthogonal_button_released(lane):
	emit_signal("button_released", lane)

func _on_GameplayOrthogonal_score_incremented(input_type, score_to_add):
	emit_signal("score_incremented", input_type, score_to_add)

func _on_GameplayOrthogonal_level_ended():
	emit_signal("level_ended")



