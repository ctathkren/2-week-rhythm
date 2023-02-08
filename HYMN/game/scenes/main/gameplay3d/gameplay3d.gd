extends Spatial

onready var gameplay_node = $GameplayViewportSprite3D/GameplayViewport/GameplayOrthogonal

signal score_incremented(input_type, score_to_add)
signal level_ended

func fetch_level_info():
	gameplay_node.fetch_level_info()

func _on_GameplayOrthogonal_score_incremented(input_type, score_to_add):
	emit_signal("score_incremented", input_type, score_to_add)

func _on_GameplayOrthogonal_level_ended():
	emit_signal("level_ended")
