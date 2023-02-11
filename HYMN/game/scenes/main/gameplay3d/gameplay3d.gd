extends Spatial

onready var gameplay_node = $GameplayViewportSprite3D/GameplayViewport/GameplayOrthogonal

signal score_incremented(input_type, score_to_add)
signal level_ended

func load_level_info(full_audio_file_path, bpm, notes):
	gameplay_node.load_level_info(full_audio_file_path, bpm, notes)

func _on_GameplayOrthogonal_score_incremented(input_type, score_to_add):
	emit_signal("score_incremented", input_type, score_to_add)

func _on_GameplayOrthogonal_level_ended():
	emit_signal("level_ended")
