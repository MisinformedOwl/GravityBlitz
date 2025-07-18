shader_type canvas_item;

uniform float time_scale : hint_range(0.1, 2.0) = 0.4; // Controls animation speed

void fragment() {
    vec2 uv = UV - 0.5; // Center UV coordinates
    float d = max(abs(uv.x), abs(uv.y)); // Max distance for square shape
    
    vec3 color = vec3(0.0);
    float line_width = 0.01;
    float time = TIME * time_scale;
    
    // Create animated RGB lines
    // Red line
    float red_pos = fract(time)+0.3;
    float red_fade = 1.0 - red_pos; // Fade from 1 to 0
    if (abs(d - (red_pos * 0.25)*2.0) < line_width) {
        color = vec3(1.0, 0.0, 0.0) * red_fade;
    }
    
    // Green line
    float green_pos = fract(time + 0.33)+0.3; // Offset for sequence
    float green_fade = 1.0 - green_pos;
    if (abs(d - (green_pos * 0.25)*2.0) < line_width) {
        color += vec3(0.0, 1.0, 0.0) * green_fade;
    }
    
    // Blue line
    float blue_pos = fract(time + 0.66)+0.3; // Offset for sequence
    float blue_fade = 1.0 - blue_pos;
    if (abs(d - (blue_pos * 0.25)*2.0) < line_width) {
        color += vec3(0.0, 0.0, 1.0) * blue_fade;
    }
	
	if (abs(d - 0.177) < line_width) {
        color += vec3(0.0, 0.0, 0.7);
    }
    
    COLOR = vec4(color, 1);
}