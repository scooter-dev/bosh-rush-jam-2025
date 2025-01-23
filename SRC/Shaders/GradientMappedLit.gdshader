shader_type spatial;

uniform sampler2D gradient : repeat_disable;

uniform vec4 topColor : source_color = vec4(1);
uniform vec4 bottomColor : source_color = vec4(1);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 tex = texture(gradient, UV.yx);
	ALBEDO = mix(topColor, bottomColor, UV.y).rgb;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
