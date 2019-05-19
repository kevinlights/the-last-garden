shader_type canvas_item;

void fragment(){
	vec4 c = texture(TEXTURE,UV+vec2(TIME*0.05,0));
	COLOR = vec4(c);
}