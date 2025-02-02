shader_type spatial;
render_mode unshaded, cull_front;

uniform float offset = 0.01;

void vertex() {
	VERTEX -= NORMAL * offset;
}

void fragment() {
	ALBEDO = vec3(0);
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
