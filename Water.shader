shader_type canvas_item;
render_mode skip_vertex_transform;

uniform sampler2D color_ramp;

void vertex() {
	
}

void fragment() {
	float strength = texture(TEXTURE, UV).a*2.0-1.0;
	if(strength < -0.1) {
		discard;
	} else {
		COLOR = texture(color_ramp, vec2(strength, 0.0));
	}
}