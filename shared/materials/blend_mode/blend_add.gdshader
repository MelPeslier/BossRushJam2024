shader_type canvas_item;
render_mode blend_add;

uniform vec4 color: source_color;
uniform float margin = 0.1;

void fragment() {
	if (COLOR.r >= color.r - margin && COLOR.g >= color.g - margin && COLOR.b >= color.b - margin){
		COLOR.rgb = color.rgb;
	}
}