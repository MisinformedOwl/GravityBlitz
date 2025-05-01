shader_type canvas_item;

const vec2 center = vec2(0.5, 0.5);
const float radius = 0.5;
const float pi2 = 6.28318; // 2 * π
uniform float dir = 0.0;
uniform float speed = 0.0;

void fragment() {
    float dist = distance(UV, center);
    if (dist < radius) {
        vec2 diff = UV - center;
        float normalized_dir = mod(dir, pi2) - 3.14159; // Normalize to [-π, π)
        vec2 dir_vector = vec2(cos(normalized_dir), sin(normalized_dir));
        float dist_along_dir = dot(diff, dir_vector);
        
        float diffspeed = max(speed - 13.0, 0.0);
        float intensity = clamp(diffspeed * 0.1, 0.0, 1.0);
        float grad_width = clamp(diffspeed * 0.5, 0.1, 1);
        
        vec4 color = vec4(1.0, 1.0, 0.0, 1.0);
        if (intensity > 0.0) {
            float grad_start = radius * (1.0 - grad_width);
            float grad_factor = clamp((dist_along_dir - grad_start) / (radius - grad_start), 0.0, 1.0);
            color = mix(color, vec4(1.0, 0.0, 0.0, 1.0), intensity * grad_factor * step(grad_start, dist_along_dir));
        }
        
        COLOR = color;
    } else {
        COLOR = vec4(0.0);
    }
}