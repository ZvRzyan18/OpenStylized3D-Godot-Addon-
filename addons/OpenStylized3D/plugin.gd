@tool
extends EditorPlugin

func _enter_tree() -> void:
	add_custom_type(
		"WaveScatteredMultiInstance3D_OPEN_STYLIZED",
		"Node3D",
		preload("res://addons/OpenStylized3D/wave_multi_instance/wave.gd"),
		null
	)
	add_custom_type(
		"GroupScatteredMultiInstance3D_OPEN_STYLIZED",
		"Node3D",
		preload("res://addons/OpenStylized3D/grouped_object/grouped.gd"),
		null
	)
func _exit_tree() -> void:
	remove_custom_type("GroupMultiInstance3D_OPEN_STYLIZED")
	remove_custom_type("WaveMultiInstance3D_OPEN_STYLIZED")
