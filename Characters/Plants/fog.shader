shader_type canvas_item;

uniform vec3 color = vec3(0.8,0.8,0.82);
uniform int OCTAVES = 4;
float rand(vec2 coord){
	return fract(sin( dot(coord,vec2(50,70))*1000.0)*1000.0 );
}

float noise(vec2 coord){
	vec2 i = floor(coord);
	vec2 f = fract(coord);
	
	float a = rand(i);
	float b = rand(i + vec2(1.0,0.0));
	float c = rand(i + vec2(0.0,1.0));
	float d = rand(i + vec2(1.0,1.0));
	
	vec2 cubic = f*f*(3.0-2.0*f);
	return mix(a,b,cubic.x) + (c-a) * cubic.y * (1.0-cubic.x) + (d-b)*cubic.x*cubic.y;
}

float fbm(vec2 coord){
	float value = 0.0;
	float scale = 0.5;
	
	for (int i=0;i<OCTAVES;i++){
		value += noise(coord)*scale;
		coord *= 2.0;
		scale *= 0.5;
	}
	return value;
}


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
	vec2 coord = UV ;
	
	vec2 motion = vec2(fbm(coord+TIME*0.1));
	
	float final = pnoise(coord+motion,1.5,6,0.3,8);
	final *= 1.5;
	final = clamp(final,0,1);
	
	float min = 0.1;
	float max = 0.5;
	float d = distance(vec2(0.5,0.5),UV);
	float d2 = (max-d)/(max-min);
	if(d>max)
		final = 0.0;
	final = mix(0,final,d2);
	
	COLOR = vec4(color,final);
}