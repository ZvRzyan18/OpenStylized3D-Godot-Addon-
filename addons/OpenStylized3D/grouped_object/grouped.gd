@tool
extends Node3D
class_name GroupScatteredMultiInstance3D_OPEN_STYLIZED

var rng_x : RandomNumberGenerator = null
var rng_y : RandomNumberGenerator = null
var rng_z : RandomNumberGenerator = null

## Node3D that is going to be grouped (Scattered)
@export
var object : Node3D = null:
	set(val):
		object = val
		initialize()

## Max drawn object
@export
var object_size : int = 5:
	set(val):
		object_size = val
		initialize()

## Randomized position seed
@export
var position_seed : Vector3i = Vector3(1342, 2324, 8882):
	set(val):
		position_seed = val
		initialize()

## Range of randomized object positions
@export
var group_area_size : Vector3 = Vector3(1.0, 1.0, 1.0):
	set(val):
		group_area_size = val
		initialize()

func initialize() -> void:
	rng_x = RandomNumberGenerator.new()
	rng_y = RandomNumberGenerator.new()
	rng_z = RandomNumberGenerator.new()
	rng_x.seed = position_seed.x
	rng_y.seed = position_seed.y
	rng_z.seed = position_seed.z
	for child in get_children():
		remove_child(child)
		child.queue_free()
	if object == null:
		return
	for i in range(0, object_size):
		var dup : Node3D = object.duplicate()
		dup.visible = true
		dup.transform = Transform3D(Basis.IDENTITY, Vector3(rng_x.randf_range(0, group_area_size.x), rng_y.randf_range(0, group_area_size.y), rng_z.randf_range(0, group_area_size.z)))
		add_child(dup as WaveScatteredMultiInstance3D_OPEN_STYLIZED)
func _ready() -> void:
	initialize()
