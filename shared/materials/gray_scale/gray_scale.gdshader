shader_type canvas_item;

uniform vec4 color: source_color = vec4(1.0);

group_uniforms one_at_a_time;
uniform float activate_lightness : hint_range(0.0, 1.0);
uniform float activate_average : hint_range(0.0, 1.0);
uniform float activate_luminosity : hint_range(0.0, 1.0);

vec4 gray_scale(vec4 _tex){
	float lightness = (max(max(_tex.r, _tex.g), _tex.b) + min(min(_tex.r, _tex.g), _tex.b) ) / 2.0;
	float average = (_tex.r + _tex.g + _tex.b) / 3.0;
	float luminosity = (0.21 * _tex.r + 0.72 * _tex.g + 0.07 * _tex.b) / 3.0;
	float final = mix(0.0, lightness, activate_lightness)
			+ mix(0.0, average, activate_average)
			+ mix(0.0, luminosity, activate_luminosity);
	return vec4(vec3(final), _tex.a);
}

void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	vec4 gray_tex = gray_scale(tex);
	COLOR = gray_tex * color;
}
