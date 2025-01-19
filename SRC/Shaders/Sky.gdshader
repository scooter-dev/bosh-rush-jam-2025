shader_type sky;

uniform sampler2D skyGradient : repeat_disable, filter_nearest;
uniform sampler2D vGradient : repeat_disable, filter_nearest;
uniform vec3 direction = vec3(0,1,0);

void sky() {
	COLOR = texture(skyGradient, vec2(dot(normalize(direction),EYEDIR) * 0.5 + 0.5,0)).rgb;
	COLOR *= texture(vGradient, vec2(dot(vec3(0,1,0), EYEDIR) * 0.5 + 0.5, 0.5)).rgb;
}
