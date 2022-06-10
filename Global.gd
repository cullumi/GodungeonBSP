extends Node

func _init():
	OS.window_maximized = true

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
