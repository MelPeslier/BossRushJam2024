shader_type canvas_item;

uniform vec4 color: source_color;
uniform float coef : hint_range(0, 1) = 0;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	COLOR = mix(tex, color, coef);
	COLOR.a *= tex.a;
}
