shader_type spatial;
render_mode cull_disabled, unshaded;

uniform vec3 mask_center = vec3(0.0);
uniform float mask_radius = 5.0;
uniform float mask_border_radius = 0.1;

uniform float emission_energy = 3.0;

uniform sampler2D ghost_noise;
uniform vec4 object_color: hint_color = vec4(1.0);
uniform vec4 mask_color: hint_color = vec4(1.0);

uniform float wind_speed = 0.2;
uniform float wind_strength = 2.0;
// How big, in world space, is the noise texture
// wind will tile every wind_texture_tile_size
uniform float wind_texture_tile_size = 20.0;
uniform float wind_vertical_strength = 0.3;
uniform vec2 wind_horizontal_direction = vec2(1.0,0.5);

uniform sampler2D color_ramp : hint_black_albedo;
// we need a tiling noise here!
uniform sampler2D wind_noise : hint_black;

varying float debug_wind;

float mix_overlay(float a, float b){
	return mix(
		a * b * 2.0,
		1.0 - 2.0 * (1.0 - a) * (1.0 - b),
		step(0.5, a));
}

void vertex() {
	
	vec3 world_vert = (WORLD_MATRIX * vec4(VERTEX, 1.0)).xyz;

	vec2 normalized_wind_direction = normalize(wind_horizontal_direction);
	vec2 world_uv = world_vert.xz / wind_texture_tile_size + normalized_wind_direction * TIME * wind_speed;
	// we displace only the top part of the mesh
	// note that this means that the mesh needs to have UV in a way that the bottom of UV space
	// is at the top of the mesh
	float displacement_affect = (1.0 - UV.y);
	float wind_noise_intensity = (textureLod(wind_noise, world_uv , 0.0).r - 0.5);

	// We convert the direction of the wind into vertex space from world space
	// if we used it directly in vertex space, rotated blades of grass wouldn't behave properly
	vec2 vert_space_horizontal_dir = (inverse(WORLD_MATRIX) * vec4(wind_horizontal_direction, 0.0,0.0)).xy;
	vert_space_horizontal_dir = normalize(vert_space_horizontal_dir);
	
	vec3 bump_wind = vec3(
		wind_noise_intensity * vert_space_horizontal_dir.x,
		1.0 - wind_noise_intensity,
		wind_noise_intensity * vert_space_horizontal_dir.y 
	);
	normalize(bump_wind);
	bump_wind *= vec3(
		wind_strength,
		wind_vertical_strength,
		wind_strength
	);
	VERTEX += bump_wind * displacement_affect;
	
}

void fragment() {
		// calculate the camera center in view space for the discard
	vec3 camera_mask_center = (inverse(CAMERA_MATRIX) * vec4(mask_center, 1.0)).xyz;
	// calculate the world space coordinates to be used as UVs of the noise
	vec3 world_space_vert = (CAMERA_MATRIX * vec4(VERTEX, 1.0)).xyz;
	
	// Here's the magic! We don't want to draw things outside of the
	// sphere of influence of our mask.
	if (length(VERTEX - camera_mask_center) >= mask_radius){
		discard;
	}
	
	// We want to add a magical effect at the border of the spherical mask, so we combine
	// noise with a fading ring (border_value) and then step it to decide where to place the
	// magical glow
	float noise_value = texture(ghost_noise, world_space_vert.xz + vec2(TIME, 0.0)).g;
	float border_value = smoothstep(0.0, mask_border_radius,length(camera_mask_center - VERTEX) - mask_radius + mask_border_radius);
	noise_value = mix_overlay(border_value, noise_value);
	noise_value = step(0.7, noise_value);
	
	// Magic part two! In order to make things look "solid" we color the backfaces with the same emissive
	// material that we use for the border
	float front_facing = float(FRONT_FACING);
	float is_mask = front_facing * noise_value + (1.0 -front_facing);
	
	// because Godot adds emission on top of albedo, it looks strange if the
	// albedo is not the same color as emission.
	ALBEDO = mix(texture(color_ramp, vec2(1.0 - UV.y, 0)).rgb, mask_color.rgb, is_mask);
	EMISSION = mix(
		vec3(0.0),
		emission_energy * mask_color.rgb,
		is_mask
	);
}