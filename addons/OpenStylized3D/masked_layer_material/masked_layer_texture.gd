@tool
extends Resource
class_name MaskedLayerTexture2D_OPEN_STYLIZED

var owner : MaskedLayerMaterial3D_OPEN_STYLIZED = null

## Layer Texture on top of base texture
@export
var texture : Texture2D = null:
	set(val):
		texture = val
		if owner != null:
			owner.initialize()

## Layer Texture Mask
@export
var mask : Texture2D = null:
	set(val):
		mask = val
		if owner != null:
			owner.initialize()

## Layer Texture repeat count 
@export
var texture_repeat_times : Vector2i = Vector2i(1, 1):
	set(val):
		texture_repeat_times = val
		if owner != null:
			owner.initialize()
