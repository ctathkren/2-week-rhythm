extends Control

signal credits_back_button_pressed

func _input(event):
	if InputMap.event_is_action(event, "ui_cancel"):
		emit_signal("credits_back_button_pressed")

func _on_CreditsBackButton_pressed():
	emit_signal("credits_back_button_pressed")
