@tool
extends Node3D
class_name WaveScatteredMultiInstance3D_OPEN_STYLIZED

var rng_position_x : RandomNumberGenerator = null
var rng_position_y : RandomNumberGenerator = null
var rng_position_z : RandomNumberGenerator = null

var rng_rotation_x : RandomNumberGenerator = null
var rng_rotation_y : RandomNumberGenerator = null
var rng_rotation_z : RandomNumberGenerator = null

var rng_scale_x : RandomNumberGenerator = null
var rng_scale_y : RandomNumberGenerator = null
var rng_scale_z : RandomNumberGenerator = null

var multi_mesh_instance : MultiMeshInstance3D = null

## Rotate mode of each instance (RANDOM, STEADY, BILBOARD)
@export_enum("RANDOM:0", "STEADY:1", "BILBOARD:2")
var rotate_mode : int = 2:
	set(val):
		rotate_mode = val
		initialize()

## Base scale of all instanced objects
@export
var obj_scale : Vector3 = Vector3(1.0, 1.0, 1.0):
	set(val):
		obj_scale = val
		initialize()

## Base Position of all instanced objects
@export
var obj_position : Vector3 = Vector3.ZERO:
	set(val):
		obj_position = val
		initialize()

## If true, the bilboard will only rotate at the x, z axis
@export
var bilboard_rotate_XZ : bool = true:
	set(val):
		bilboard_rotate_XZ = val
		initialize()

## If true, the bilboard will only rotate at the x, y, z axis
@export
var bilboard_rotate_XYZ : bool = false:
	set(val):
		bilboard_rotate_XYZ = val
		initialize()

## Amount of object that is being drawn.
@export
var instance_count : int = 10:
	set(val):
		instance_count = val
		initialize()

## Seed for randomized position
@export
var seed_position : Vector3i = Vector3i(4545, 1232, 9444):
	set(val):
		seed_position = val
		initialize()

## Seed for randomized rotation
@export
var seed_rotation : Vector3i = Vector3i(4545, 1232, 9444):
	set(val):
		seed_rotation = val
		initialize()

## Seed for randomized scale
@export
var seed_scale : Vector3i = Vector3i(0, 0, 0):
	set(val):
		seed_scale = val
		initialize()

## Max range of the randomized scale
@export
var random_scale_max_range : Vector3 = Vector3(0.0, 0.0, 0.0):
	set(val):
		random_scale_max_range = val
		initialize()

## Max range of the randomized position
@export
var randomized_position_area : Vector3 = Vector3(5.0, 5.0, 5.0):
	set(val):
		randomized_position_area = val
		initialize()

## Mesh object 
@export
var mesh_type : Mesh = QuadMesh.new():
	set(val):
		mesh_type = val
		initialize()

## Base texture
@export
var texture : Texture2D = null:
	set(val):
		texture = val
		initialize()

## Wave Speed (Shader Animation)
@export
var wave_speed : float = 2.5:
	set(val):
		wave_speed = val
		initialize()

## Wave Strength (Shader Animation)
@export
var wave_strength : float = 0.0722:
	set(val):
		wave_strength = val
		initialize()

## If true, The objects will wave at the direction at the same time.
@export
var wave_synchronize : bool = false:
	set(val):
		wave_synchronize = val
		initialize()

## cast shadow settings
@export_enum("CAST_SHADOW_ON", "CAST_SHADOW_OFF", "CAST_SHADOW_DOUBLE_SIDED", "CAST_SHADOW_SHADOWS_ONLY")
var cast_shadow : int = 0:
	set(val):
		cast_shadow = val
		initialize()

var shader : ShaderMaterial =  ShaderMaterial.new()

func create_objects() -> void:
	rng_position_x = RandomNumberGenerator.new()
	rng_position_x.seed = seed_position.x
	rng_position_y = RandomNumberGenerator.new()
	rng_position_y.seed = seed_position.y
	rng_position_z = RandomNumberGenerator.new()
	rng_position_z.seed = seed_position.z	
	rng_rotation_x = RandomNumberGenerator.new()
	rng_rotation_x.seed = seed_rotation.x
	rng_rotation_y = RandomNumberGenerator.new()
	rng_rotation_y.seed = seed_rotation.y
	rng_rotation_z = RandomNumberGenerator.new()
	rng_rotation_z.seed = seed_rotation.z
	
	rng_scale_x = RandomNumberGenerator.new()
	rng_scale_x.seed = seed_scale.x
	rng_scale_y = RandomNumberGenerator.new()
	rng_scale_y.seed = seed_scale.y
	rng_scale_z = RandomNumberGenerator.new()
	rng_scale_z.seed = seed_scale.z
func initialize() -> void:
	create_objects()
	for child in get_children():
		remove_child(child)
		child.queue_free()
	shader.shader = load("res://addons/OpenStylized3D/wave_multi_instance/wave.gdshader")
	shader.set_shader_parameter("m_texture", texture)
	shader.set_shader_parameter("rotate_type", rotate_mode)
	if bilboard_rotate_XZ :
		shader.set_shader_parameter("bilboard_rotate", 0)
	elif bilboard_rotate_XYZ :
		shader.set_shader_parameter("bilboard_rotate", 1)
	shader.set_shader_parameter("wave_strength", wave_strength)
	shader.set_shader_parameter("wave_speed", wave_speed)
	shader.set_shader_parameter("wave_synchronize", wave_synchronize)
	if multi_mesh_instance != null:
		multi_mesh_instance.queue_free()
		multi_mesh_instance = null
		
	multi_mesh_instance = MultiMeshInstance3D.new()
	multi_mesh_instance.multimesh = MultiMesh.new()
	multi_mesh_instance.multimesh.mesh = mesh_type
	multi_mesh_instance.material_override = shader
	match cast_shadow:
		0:
			multi_mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
		1:
			multi_mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		2:
			multi_mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_DOUBLE_SIDED
		3:
			multi_mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_SHADOWS_ONLY


	if multi_mesh_instance.multimesh != null:
		multi_mesh_instance.multimesh.instance_count = 0
		multi_mesh_instance.multimesh.transform_format = MultiMesh.TransformFormat.TRANSFORM_3D
		multi_mesh_instance.multimesh.instance_count = instance_count
	for i : int in range(0, multi_mesh_instance.multimesh.instance_count):
		var random_scale : Vector3 = Vector3(rng_scale_x.randf_range(0.0, random_scale_max_range.x), rng_scale_y.randf_range(0.0, random_scale_max_range.y), rng_scale_z.randf_range(0.0, random_scale_max_range.z))
		if rotate_mode == 0:
			multi_mesh_instance.multimesh.set_instance_transform(i, Transform3D(Basis.from_scale(obj_scale + random_scale) * Basis.from_euler(Vector3(rng_rotation_x.randf_range(0, TAU), rng_rotation_y.randf_range(0, TAU), rng_rotation_z.randf_range(0, TAU))), obj_position + Vector3(rng_position_x.randf(), rng_position_y.randf(), rng_position_z.randf()) * randomized_position_area))
		else :
			multi_mesh_instance.multimesh.set_instance_transform(i, Transform3D(Basis.from_scale(obj_scale + random_scale), obj_position + Vector3(rng_position_x.randf(), rng_position_y.randf(), rng_position_z.randf()) * randomized_position_area))

		
	add_child(multi_mesh_instance)
func _ready() -> void:
	initialize()
