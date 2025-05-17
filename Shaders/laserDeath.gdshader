shader_type canvas_item;

uniform float time;
uniform float speed = 1.0; // Controls wipe speed
uniform float transition_width = 0.1; // Controls transition zone width

void fragment() {
    vec4 texture_color = texture(TEXTURE, UV); // Sample the sprite's texture
    if (texture_color.a == 0.0) {
        COLOR = texture_color; // Preserve transparent pixels
    } else {
        float val = TIME * speed - time; // Wipe line position
        if (UV.y < val) {
            COLOR = vec4(0.0, 0.0, 0.0, 0.0); // Transparent above the wipe line
        } else {
            float closeness = UV.y - val; // Distance from the wipe line
            if (closeness < transition_width) {
                // Blend towards black based on closeness
                float blend = closeness / transition_width;
                COLOR = mix(vec4(0.0, 0.0, 0.0, texture_color.a), texture_color, blend);
            } else {
                COLOR = texture_color; // Normal texture below the transition zone
            }
        }
    }
}