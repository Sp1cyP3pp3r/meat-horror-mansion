//By Kyra July 2023. Updated December 2023
//Tested in Godot 4.2
//Made with help from Blackle Mori at suricrasia.online and MrTriPie's commnets on GDshaders

shader_type spatial;

uniform sampler2D albedo;

uniform sampler2D normalmap;

uniform int directions = 8;

uniform int frame_count = 5;

uniform int frame = 0;

uniform float scale = 1.0;

uniform bool y_billboard;

uniform bool use_alpha;

void vertex() {
	if(y_billboard){
		MODELVIEW_MATRIX = VIEW_MATRIX * mat4(
        vec4(normalize(cross(vec3(0.0, 1.0, 0.0), INV_VIEW_MATRIX[2].xyz)), 0.0),
        vec4(0.0, 1.0, 0.0, 0.0),
        vec4(normalize(cross(INV_VIEW_MATRIX[0].xyz, vec3(0.0, 1.0, 0.0))), 0.0),
        MODEL_MATRIX[3]);
	}else{
		MODELVIEW_MATRIX = VIEW_MATRIX * mat4(INV_VIEW_MATRIX[0], INV_VIEW_MATRIX[1], INV_VIEW_MATRIX[2], MODEL_MATRIX[3]);
		MODELVIEW_NORMAL_MATRIX = mat3(MODELVIEW_MATRIX);
	}
	VERTEX *= scale;
	vec3 direction_to_camera = normalize(CAMERA_POSITION_WORLD-NODE_POSITION_WORLD);
	float angle_to_camera = atan(direction_to_camera.x,direction_to_camera.z);
	vec4 model_direction = MODEL_MATRIX*vec4(1.0,0.0,0.0,0.0);
	float y_angle = atan(model_direction.x,model_direction.z)-PI;
	float final_angle = angle_to_camera-y_angle;
	float int_y_angle = round((final_angle / TAU) * float(directions)) / float(directions);
	UV.y += float(frame);
	UV /= vec2(float(directions), float(frame_count));
	UV.x += int_y_angle;
}

void fragment() {
	vec4 albedo_tex = texture(albedo,UV);
	if(use_alpha){
		ALPHA_SCISSOR_THRESHOLD = 0.5;
		ALPHA = albedo_tex.a;
	}
    ALBEDO = albedo_tex.rgb;
	NORMAL_MAP = texture(normalmap, UV).xyz;
}