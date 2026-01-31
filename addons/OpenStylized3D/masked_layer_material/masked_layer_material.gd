@tool
extends ShaderMaterial

class_name MaskedLayerMaterial3D_OPEN_STYLIZED

var texture_filter_string : String = "filter_linear_mipmap"
var mask_filter_string : String = "filter_linear_mipmap"

## Texture Sampling Filter
@export_enum("LINEAR", "NEAREST")
var texture_filter : int = 0:
	set(val):
		texture_filter = val
		match val:
			0:
				texture_filter_string = "filter_linear_mipmap"
			1:
				texture_filter_string = "filter_nearest_mipmap"
		initialize()
		
## Texture Mask Sampling Filter
@export_enum("LINEAR", "NEAREST")
var mask_filter : int = 0:
	set(val):
		mask_filter = val
		match val:
			0:
				mask_filter_string = "filter_linear_mipmap"
			1:
				mask_filter_string = "filter_nearest_mipmap"
		initialize()

## Base Texture of the mesh
@export
var base_texture : Texture2D = null:
	set(val):
		base_texture = val
		initialize()

## Texture repeat count for both x and y axis
@export
var base_repeat_times : Vector2i = Vector2i(1, 1):
	set(val):
		base_repeat_times = val
		initialize()

## Pair of texture for both Top Layer and Mask Layer
@export
var layered_texture : Array[MaskedLayerTexture2D_OPEN_STYLIZED] = []:
	set(val):
		layered_texture = val
		initialize()


func initialize() -> void:
	if self.shader == null:
		self.shader = Shader.new()
	var str_code : String = "
	shader_type spatial;
	uniform sampler2D m_texture : " + texture_filter_string + ";
	varying vec2 uv;
	"
	for i in range(0, layered_texture.size()):
		if layered_texture[i] != null:
			layered_texture[i].owner = self
		str_code += "uniform sampler2D layer" + str(i) + ": " + texture_filter_string + ";\n"
		str_code += "uniform sampler2D mask" + str(i) + ": " + mask_filter_string + ";\n"
		str_code += "varying vec2 uv" + str(i) + ";\n"
	str_code += "
	void vertex() {
	"
	for i in range(0, layered_texture.size()):
		str_code += "uv" + str(i) + " = UV * vec2(" + str(layered_texture[i].texture_repeat_times.x) + ".0, " + str(layered_texture[i].texture_repeat_times.y) + ".0);\n"
	str_code += "
	uv = UV * vec2(" + str(base_repeat_times.x) + ".0, " + str(base_repeat_times.y) + ".0);\n" + "
	
	}
	
	void fragment() {
		vec4 base = texture(m_texture, uv);
	"
	for i in range(0, layered_texture.size()):
		str_code += "base = mix(base, texture(layer" + str(i) + ", uv" + str(i) + "), texture(mask" + str(i) + ", UV).a);\n"
	
	str_code += "
	ALBEDO = base.rgb;
	// srgb to linear
	ALBEDO = ALBEDO * (ALBEDO * (ALBEDO * 0.305306 + 0.682171) +0.0125228);
	}
	"
	
	self.shader.code = str_code
	set_shader_parameter("m_texture", base_texture)
	for i in range(0, layered_texture.size()):
		set_shader_parameter("layer" + str(i), layered_texture[i].texture)
		set_shader_parameter("mask" + str(i), layered_texture[i].mask)
	#self.property_list_changed.emit()
	self.changed.emit()
	self.emit_changed()
	
func _init() -> void:
	initialize()
