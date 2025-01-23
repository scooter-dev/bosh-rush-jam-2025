shader_type spatial;

uniform sampler2D tex;
uniform vec4 red_color : source_color = vec4(1);
uniform vec4 green_color : source_color = vec4(1);
uniform vec4 blue_color : source_color = vec4(1);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 cMap = texture(tex, UV);
	ALBEDO = mix(mix(blue_color.rgb, green_color.rgb, cMap.g), red_color.rgb, cMap.r).rgb;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
