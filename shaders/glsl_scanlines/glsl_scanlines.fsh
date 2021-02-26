varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float u_fScanlinePhase;
uniform float u_fScanlineFreq;
uniform float u_fDistortionEnabled;

precision highp float;

vec2 distortion(vec2 coord, float bend) {
	if (u_fDistortionEnabled >= 0.5) {
		// put in symmetrical coords
		coord = (coord - 0.5) * 2.0;

		vec2 coord_2 = vec2(coord.x / 1.1, coord.y);
		coord *= 0.9 + dot(coord_2, coord_2) / bend;

		// transform back to 0.0 - 1.0 space
		coord  = (coord / 2.0) + 0.5;
	}
	return coord;
}

void main() {
	#define PI 3.14
	#define distortion_strength 15.0
	vec2 texcoord_distortion = distortion(v_vTexcoord, distortion_strength);

	vec4 color = v_vColour * texture2D(gm_BaseTexture, texcoord_distortion);
	color.a = 1.0;
	
	// Short scanlines
	#define scanlines_strength			0.082
	#define scanlines_duty_factor		0.5
	#define scanlines_duty_smoothstep	0.34
	float scanlines_value = (1.0 + sin(texcoord_distortion.y * 2.0 * PI * u_fScanlineFreq + u_fScanlinePhase * 10.0)) / 2.0;
	color.rgb -= scanlines_strength * mix(0.17, 3.0, (color.r + color.g + color.b) / 3.0 - 0.1) * smoothstep(scanlines_duty_factor - scanlines_duty_smoothstep, scanlines_duty_factor + scanlines_duty_smoothstep, scanlines_value);
	
	// // Wide scanlines
	#define scanlines_wide_freq				4.0
	#define scanlines_wide_duty_factor		0.6
	#define scanlines_wide_duty_smoothstep	0.1
	#define scanlines_wide_strength			0.07
	#define scanlines_wide_speed_factor		1.0
	float wave_value = (1.0 + sin(texcoord_distortion.y * 2.0 * PI * scanlines_wide_freq + u_fScanlinePhase * scanlines_wide_speed_factor) + sin(texcoord_distortion.y * 2.0 * PI * scanlines_wide_freq * 0.5 + u_fScanlinePhase * 1.44 * scanlines_wide_speed_factor)) / 2.0;
	color.rgb *= 1.0 + scanlines_wide_strength * smoothstep(scanlines_wide_duty_factor - scanlines_wide_duty_smoothstep, scanlines_wide_duty_factor + scanlines_wide_duty_smoothstep, wave_value);
	
	gl_FragColor = color;
}