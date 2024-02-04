shader_type canvas_item;
uniform float percentage: hint_range(0.0, 1.0);

void fragment() {
	vec2 uv = UV;
	vec4 tex = texture(TEXTURE, uv);
	float coef = step(uv.y, percentage);
	COLOR.a = tex.a * coef;

}
