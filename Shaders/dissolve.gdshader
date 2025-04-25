shader_type canvas_item;

uniform sampler2D noise_texture;
uniform float t;
uniform float speed = 0.5;

varying float diff;

void fragment() {
    // Sample the noise texture
    float noise = texture(noise_texture, UV).r;
    
    // If noise value is less than threshold, make pixel transparent
	float progress = clamp((TIME-t)-0.6*speed, -0.3,2.0);
	
	if (noise < progress){
		COLOR = vec4(0.0);
	} else {
		COLOR = texture(TEXTURE, UV);
	}
	
	if (progress+0.3 > noise){
		COLOR.b -= progress+0.3;
		COLOR.g -= progress+0.3;
	}
	
	if (progress+0.2 > noise){
		COLOR.r -= progress;
	}
}