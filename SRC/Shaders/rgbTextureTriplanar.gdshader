shader_type spatial;

uniform sampler2D tex;
uniform vec4 red_color : source_color = vec4(1);
uniform vec4 green_color : source_color = vec4(1);
uniform vec4 blue_color : source_color = vec4(1);
uniform vec3 uvScale = vec3(1);
uniform vec3 uvOffset = vec3(0);

varying vec3 uv1_power_normal;
varying vec3 uv1_triplanar_pos;
uniform float uv1_blend_sharpness = 0.5;


void vertex() {
	vec3 normal = NORMAL;

	TANGENT = vec3(0.0, 0.0, -1.0) * abs(normal.x);
	TANGENT += vec3(1.0, 0.0, 0.0) * abs(normal.y);
	TANGENT += vec3(1.0, 0.0, 0.0) * abs(normal.z);
	TANGENT = normalize(TANGENT);

	BINORMAL = vec3(0.0, 1.0, 0.0) * abs(normal.x);
	BINORMAL += vec3(0.0, 0.0, -1.0) * abs(normal.y);
	BINORMAL += vec3(0.0, 1.0, 0.0) * abs(normal.z);
	BINORMAL = normalize(BINORMAL);
	
	uv1_power_normal = pow(abs(NORMAL), vec3(uv1_blend_sharpness));
	uv1_triplanar_pos = VERTEX * uvScale + uvOffset;
	uv1_power_normal /= dot(uv1_power_normal, vec3(1.0));
	uv1_triplanar_pos *= vec3(1.0, -1.0, 1.0);
}

vec4 triplanar_texture(sampler2D p_sampler, vec3 p_weights, vec3 p_triplanar_pos) {
	vec4 samp = vec4(0.0);
	samp += texture(p_sampler, p_triplanar_pos.xy) * p_weights.z;
	samp += texture(p_sampler, p_triplanar_pos.xz) * p_weights.y;
	samp += texture(p_sampler, p_triplanar_pos.zy * vec2(-1.0, 1.0)) * p_weights.x;
	return samp;
}

void fragment() {
	vec4 cMap = triplanar_texture(tex, uv1_power_normal, uv1_triplanar_pos);
	ALBEDO = mix(mix(blue_color.rgb, green_color.rgb, cMap.g), red_color.rgb, cMap.r).rgb;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
