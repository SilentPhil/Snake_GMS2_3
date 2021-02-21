varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float u_fScanlinePhase;
uniform float u_fScanlineFreq;
uniform float u_fDistortionStrength;

precision highp float;

vec2 distortion(vec2 coord, float bend)
{
	// put in symmetrical coords
	coord = (coord - 0.5) * 2.0;
	coord *= 1;	

	vec2 coord_2 = vec2(coord.x / 1.1, coord.y);
	coord *= 10 / bend + dot(coord_2, coord_2) / bend;

	// transform back to 0.0 - 1.0 space
	coord  = (coord / 2.0) + 0.5;

	return coord;
}

void main() {
	#define PI 3.14
	#define scanlines_strength	0.12
	#define scanlines_wide_freq	4
	
	vec2 uv = v_vTexcoord;
	vec2 texcoord_distortion = distortion(uv, u_fDistortionStrength);
	if (texcoord_distortion.x < 0.0 || texcoord_distortion.x > 1.0 || texcoord_distortion.y < 0.0 || texcoord_distortion.y > 1.0) {
		discard;
	}
		
	vec4 color = v_vColour * texture2D(gm_BaseTexture, texcoord_distortion);
	
	// Short scanlines
	color.rgb -= scanlines_strength * (color.r + color.g + color.b) / 3.0 * (2.0 + sin(texcoord_distortion.y * 2.0 * PI * u_fScanlineFreq + u_fScanlinePhase)) / 2.0;
	
	// Wide scanlines
	color.rgb *= 1.0 + 0.15 * (2.0 + sin(texcoord_distortion.y * 2.0 * PI * scanlines_wide_freq + u_fScanlinePhase)) / 2.0;
	
	gl_FragColor = color;
}