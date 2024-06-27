shader_type canvas_item;


uniform vec4 transition_color : source_color;
uniform sampler2D transition_texture : filter_nearest;
uniform float percent : hint_range(0.0, 1.0);


void fragment() {
	vec4 transition_texture_color = texture(transition_texture, UV);
	float alpha = step(percent, transition_texture_color.r);
	COLOR = mix(transition_color, vec4(0.0), alpha);
}

