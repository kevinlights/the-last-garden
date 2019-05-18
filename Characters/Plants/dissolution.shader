shader_type canvas_item;

uniform float dissolution : hint_range(0,1);
uniform vec4 color : hint_color;

vec2 hash(vec2 p) {
  p = vec2( dot(p,vec2(127.1,311.7)),
        dot(p,vec2(269.5,183.3)) );
 
  return -1.0 + 2.0*fract(sin(p)*43758.5453123);
}

float gnoise(vec2 p) {
  vec2 i = floor( p );
  vec2 f = fract( p );
   
  vec2 u = f*f*(3.0-2.0*f);
 
  return mix( mix( dot( hash( i + vec2(0.0,0.0) ), f - vec2(0.0,0.0) ),
           dot( hash( i + vec2(1.0,0.0) ), f - vec2(1.0,0.0) ), u.x),
          mix( dot( hash( i + vec2(0.0,1.0) ), f - vec2(0.0,1.0) ),
           dot( hash( i + vec2(1.0,1.0) ), f - vec2(1.0,1.0) ), u.x), u.y);
}

float pnoise(vec2 p,float amplitude,float frequency,float persistence, int nboctaves) {
  float a = amplitude;
  float f = frequency;
  float n = 0.0;
 
  for(int i=0;i<nboctaves;++i) {
    n = n+a*gnoise(p*f);
    f = f*2.;
    a = a*persistence;
  }

  return n;
}

void fragment(){
	vec3 n = clamp(vec3(pnoise(UV*vec2(4,1),2,4,0.2,4)*0.5+0.5),0,1);
	vec4 c = texture(TEXTURE,UV);
	
	float d=0.005;
	float dissolution_d = dissolution * (1.0);
	if(n.r < dissolution_d*1.1-d){
		c.a = 0.0;
	}

	if(dissolution > 0.0){
		c.xyz = vec3(1.0,1.0,1.0);
	}
	COLOR = vec4(c);
}