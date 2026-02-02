@tool
extends EditorPlugin

func _enter_tree() -> void:
	add_custom_type(
		"WaveScatteredMultiInstance3D_OPEN_STYLIZED",
		"Node3D",
		preload("res://addons/OpenStylized3D/wave_multi_instance/wave.gd"),
		preload("res://addons/OpenStylized3D/icon.png")
	)
	add_custom_type(
		"GroupScatteredMultiInstance3D_OPEN_STYLIZED",
		"Node3D",
		preload("res://addons/OpenStylized3D/grouped_object/grouped.gd"),
		preload("res://addons/OpenStylized3D/icon.png")
	)
	add_custom_type(
		"MaskedLayerMaterial3D_OPEN_STYLIZED",
		"ShaderMaterial",
		preload("res://addons/OpenStylized3D/masked_layer_material/masked_layer_material.gd"),
		preload("res://addons/OpenStylized3D/icon.png")
	)
	add_custom_type(
		"MaskedLayerTexture2D_OPEN_STYLIZED",
		"Resource",
		preload("res://addons/OpenStylized3D/masked_layer_material/masked_layer_texture.gd"),
		preload("res://addons/OpenStylized3D/icon.png")
	)
func _exit_tree() -> void:
	remove_custom_type("MaskedLayerTexture2D_OPEN_STYLIZED")
	remove_custom_type("MaskedLayerMaterial3D_OPEN_STYLIZED")
	remove_custom_type("GroupMultiInstance3D_OPEN_STYLIZED")
	remove_custom_type("WaveMultiInstance3D_OPEN_STYLIZED")
