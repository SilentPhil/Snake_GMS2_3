varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float u_fScanlinePhase;
uniform float u_fScanlineFreq;
uniform float u_fDistortionStrength;

precision highp float;

vec2 crt(vec2 coord, float bend)
{
	// put in symmetrical coords
	coord = (coord - 0.5) * 2.0;
	coord *= bend / 3;	

	// deform coords
	coord.x *= 1.0 + pow((abs(coord.y) / bend), 2.0);
	coord.y *= 1.0 + pow((abs(coord.x) / bend), 2.0);

	// transform back to 0.0 - 1.0 space
	coord  = (coord / 2.0) + 0.5;

	return coord;
}

void main() {
	#define PI 3.14
	#define scanlines_strength	0.2
	#define scanlines_wide_freq	4
	
	vec2 uv = v_vTexcoord;
	vec2 texcoord_distortion = crt(uv, u_fDistortionStrength);
	
	vec4 color = v_vColour * texture2D(gm_BaseTexture, texcoord_distortion);
	
	// Short scanlines
	color.rgb -= scanlines_strength * (color.r + color.g + color.b) / 3.0 * (2.0 + sin(texcoord_distortion.y * 2.0 * PI * u_fScanlineFreq + u_fScanlinePhase)) / 2.0;
	
	// Wide scanlines
	color.rgb *= 1.0 + 0.11 * (2.0 + sin(texcoord_distortion.y * 2.0 * PI * scanlines_wide_freq + u_fScanlinePhase)) / 2.0;
	
	gl_FragColor = color;
}