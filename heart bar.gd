extends HBoxContainer


func _on_character_health_changed(value):
	for i in get_child_count():
		get_child(i).visible = value > i
