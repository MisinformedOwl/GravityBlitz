shader_type canvas_item;

uniform vec4 color1 : source_color = vec4(0.9, 0.2, 0.5, 1.0); // Red
uniform vec4 color2 : source_color = vec4(0.17, 0.86, 0.7, 1.0); // Blue
uniform vec4 color3 : source_color = vec4(0.6, 0.1, 0.8, 1.0); // Green
uniform vec4 color4 : source_color = vec4(1.0, 1.0, 0.0, 1.0); // Yellow
uniform float animation_speed : hint_range(0.1, 5.0) = 2.0;

void fragment() {
    float time = TIME * animation_speed;
    vec2 center = vec2(0.5, 0.5);
    float dist = distance(UV, center);
    float ring = mod(floor(dist * 10.0 + time), 4.0);
    
    vec4 color;
    if (ring < 1.0) {
        color = color1;
    } else if (ring < 2.0) {
        color = color2;
    } else if (ring < 3.0) {
        color = color3;
    } else {
        color = color4;
    }
    
    // Create circular mask
    float circle = step(dist, 0.5);
    COLOR = color * circle;
}