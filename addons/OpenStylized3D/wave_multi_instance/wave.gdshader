shader_type spatial;
uniform sampler2D m_texture : filter_linear_mipmap;
uniform int rotate_type;
uniform int bilboard_rotate;
uniform int wave_synchronize;
uniform float wave_speed;
uniform float wave_strength;

float hash11(float p) {
    p = fract(p * 0.1031);
    p *= p + 33.33;
    p *= p + p;
    return fract(p);
}
/*
float fastSine(float x) {
  x = fract(x * 0.15915494) * 6.2831853 - 3.14159265;
  return x * (1.27323954 - 0.405284735 * abs(x));
}*/

void vertex() {
	vec3 current_vertex = VERTEX;
	vec2 factor = vec2(hash11(float(VERTEX_ID)), hash11(float(VERTEX_ID+1)));

	vec2 dir;
	if (wave_synchronize == 0)
	 dir = vec2(hash11(float(INSTANCE_ID + 3)), hash11(float(INSTANCE_ID-1)));
    else
	 dir = vec2(1.0);
    float wave;
    if (wave_synchronize == 0)
	 wave = sin((TIME * wave_speed + current_vertex.x + current_vertex.z) * hash11(float(INSTANCE_ID + 3)));
	else
	 wave = sin((TIME * wave_speed + current_vertex.x + current_vertex.z));

	vec2 wind_offset = dir * wave * wave_strength * factor;
    current_vertex.xz += wind_offset;

    mat3 billboardRot = mat3(1.0);
	mat3 camera_rot = mat3(VIEW_MATRIX);
	if(rotate_type == 2) {

		if(bilboard_rotate == 0) {
		billboardRot[0].x = camera_rot[0].x;
		billboardRot[0].z = camera_rot[0].z;
		billboardRot[2].x = camera_rot[2].x;
		billboardRot[2].z = camera_rot[2].z;
		} else if (bilboard_rotate == 1) {
			billboardRot = camera_rot;
		}
	}

    vec3 world_pos = vec3(MODEL_MATRIX[3].xyz) + mat3(MODEL_MATRIX) * transpose(billboardRot) * current_vertex;
    POSITION = PROJECTION_MATRIX * VIEW_MATRIX * vec4(world_pos, 1.0);
}

void fragment() {
   vec4 final_color = texture(m_texture, UV);
	ALBEDO = final_color.rgb;
	ALBEDO = ALBEDO * (ALBEDO * (ALBEDO * 0.305306 + 0.682171) +0.0125228);
	if (final_color.a < 0.5) {
      discard;
    }
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
