shader_type canvas_item;

uniform vec2 center = vec2(0.5, 0.5);
uniform vec2 rect_size = vec2(512.0, 288.0);
uniform float radius = 0;

void fragment() {
	float distance = distance(UV * rect_size, center * rect_size);
	COLOR = distance < radius ? vec4(0.0, 0.0, 0.0, 0.0) : vec4(radius/distance, radius/distance, radius/distance, 1.0);
}