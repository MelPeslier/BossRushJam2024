shader_type canvas_item;

group_uniforms screen;
uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform vec2 scale;
uniform float y_zoom;

group_uniforms display;
uniform float reflect_scale_y = 1.13;
uniform vec4 water_color : source_color;

group_uniforms distortion;
uniform sampler2D distortion_noise: repeat_enable;
uniform vec2 distortion_scale = vec2(0.03, 0.06);
uniform float distortion_intensity = 0.04;
uniform float distortion_speed = 0.015 ;

group_uniforms waves;
uniform sampler2D wave_1_noise: repeat_enable;
uniform float wave_1_speed;
uniform float waves_min_intensity = 1.22;
uniform float waves_hdr_value = 5.6;
uniform float waves_smoothness = 0.12;

group_uniforms top_wave;
uniform float top_wave_amplitude = 0.02;
uniform float top_wave_speed = 0.09;
uniform float top_wave_period = 0.185;


//float remap(float val, float in1, float in2, float out1, float out2)
	//{
		//return out1 + (val - in1) * (out2 - out1) / (in2 - in1);
	//}

void fragment() {
	vec2 uv = vec2( UV.x, UV.y * reflect_scale_y);

	float waves = uv.y * scale.y +sin(uv.x * scale.x / top_wave_period + TIME * top_wave_speed)
	 * cos( 0.2 * uv.x * scale.x/top_wave_period - TIME - top_wave_speed)
	 * top_wave_amplitude - top_wave_amplitude;

	float distortion_1 = texture(distortion_noise, uv * scale * distortion_scale + TIME * distortion_speed).x;
	float distortion_2 = texture(wave_1_noise, uv * scale * distortion_scale + TIME * wave_1_speed).x;
	float distortion = distortion_1 + 1.0 - distortion_2;
	distortion -= 0.5;
	float waves_intensity = smoothstep(waves_min_intensity - waves_smoothness, waves_min_intensity, distortion) * waves_hdr_value;

	float uv_height = SCREEN_PIXEL_SIZE.y / TEXTURE_PIXEL_SIZE.y;
	vec2 reflected_screen_uv = vec2(SCREEN_UV.x - distortion * distortion_intensity * y_zoom, SCREEN_UV.y - uv_height * uv.y * y_zoom * scale.y * 2.0);

	vec4 reflection = texture(screen_texture, reflected_screen_uv);
	vec3 reflected_water = mix(reflection.rgb, water_color.rgb, water_color.a);


	COLOR.rgb = reflected_water + vec3(waves_intensity);
	COLOR.a = smoothstep( 0.1, 0.35, clamp(waves, 0, 1) );
}
