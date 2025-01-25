shader_type spatial;
render_mode unshaded;

uniform sampler2D tex;
uniform vec4 red_color : source_color = vec4(1);
uniform vec4 green_color : source_color = vec4(1);
uniform vec4 blue_color : source_color = vec4(1);
uniform vec2 texScale = vec2(1);
uniform vec2 texOffset = vec2(0);

void vertex() {
	UV += texOffset;
	UV *= texScale;
}

void fragment() {
	vec4 cMap = texture(tex, UV);
	ALBEDO = mix(mix(blue_color.rgb, green_color.rgb, cMap.g), red_color.rgb, cMap.r).rgb;
	ALPHA = cMap.a;
	ALPHA_SCISSOR_THRESHOLD = 0.05;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
