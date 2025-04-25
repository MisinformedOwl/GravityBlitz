shader_type canvas_item;

uniform float speed : hint_range(0.1, 5.0) = 0.1; // Controls animation speed
uniform float line_thickness : hint_range(0.001, 0.05) = 0.01; // Thickness of lines
uniform float diamond_size : hint_range(0.1, 1.0) = 0.5; // Size of the diamond

void fragment() {
    vec2 uv = UV - 0.5; // Center UV coordinates
    float time = TIME * speed;
    
    // Three separate diamonds with time offsets
    float progress_red = fract(time); // Red diamond cycle
    float progress_blue = fract(time + 0.333); // Blue, delayed 1/3 cycle
    float progress_green = fract(time + 0.666); // Green, delayed 2/3 cycle
    
    // Scale for each diamond (edge to center)
    float scale_red = mix(diamond_size, 0.0, progress_red);
    float scale_blue = mix(diamond_size, 0.0, progress_blue);
    float scale_green = mix(diamond_size, 0.0, progress_green);
    
    // Manhattan distance for diamond shape
    float diamond = (abs(uv.x) + abs(uv.y))/2.0;
    
    // Line masks for each diamond
    float line_red = abs(diamond - scale_red);
    float line_blue = abs(diamond - scale_blue);
    float line_green = abs(diamond - scale_green);
    
    float mask_red = smoothstep(line_thickness * 0.5, 0.0, line_red);
    float mask_blue = smoothstep(line_thickness * 0.5, 0.0, line_blue);
    float mask_green = smoothstep(line_thickness * 0.5, 0.0, line_green);
    
    // Combine colors, prioritizing the closest line
    vec3 color = vec3(0,0,(sin(time*2.0)+1.0)*0.1); // Black background
    float max_mask = max(max(mask_red, mask_blue), mask_green);
    
    // Only draw the most prominent line to avoid overlap
    if (max_mask > 0.0) {
        if (mask_red == max_mask) {
            color = vec3(1.0, 0.0, 0.0); // Red
        } else if (mask_blue == max_mask) {
            color = vec3(0.0, 0.0, 1.0); // Blue
        } else if (mask_green == max_mask) {
            color = vec3(0.0, 0.7, 0.0); // Green
        }
    }
    
    COLOR = vec4(color, 1.0);
}

//uniform vec2 dist;
//uniform vec2 camera;
//uniform vec2 cameraZoom;

//void fragment(){
	//COLOR = vec4(dist.x-VERTEX.x, dist.y-VERTEX.y,1,1);
//}

//CAMERA CAUSING PROBLEMS

//void fragment(){
	////Get the segment of the UV the vertex exists in.
	//vec2 segment = vec2(0.25 + (round(UV.x)*0.5), (0.25 + round(UV.y)*0.5));
	//
	////Get the difference in distance from the vertex to the segment center.
	//vec2 diff = vec2(segment.x-UV.x, segment.y-UV.y);
	//vec2 d = vec2(((VERTEX.x + (diff.x)*128.0) - dist.x), ((VERTEX.y + (diff.y)*128.0) - dist.y));
	//
	////Get the distance from the segment center
	//float ballDist = sqrt((d.x*d.x) + (d.y*d.y));
	//
	////Color the vertex
	//if((1.0-(min(ballDist,300.0)/400.0)) > sqrt(diff.x*diff.x + diff.y*diff.y)/0.25){
		//COLOR = vec4(UV.x, UV.y, min(ballDist,400)/400.0, 1);
	//} else {
		//COLOR = vec4(0,0,0,1);
	//}
//}