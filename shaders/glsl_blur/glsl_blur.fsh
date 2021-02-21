varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec2 u_vOffsetFactor;

precision highp float;


void main()
{
	vec4 color = vec4(0.0);

	const float arr[3] = float[3](0.038735, 0.113085, 0.215007);

	for (int i = 0; i < 3; i += 1) {
		color += texture2D(gm_BaseTexture, v_vTexcoord - u_vOffsetFactor.xy) * arr[i];
	}
	color += texture2D(gm_BaseTexture, v_vTexcoord) * 0.266346;
	for (int i = 0; i < 3; i += 1) {
		color += texture2D(gm_BaseTexture, v_vTexcoord + u_vOffsetFactor.xy) * arr[i];
	}

	vec4 final_color = v_vColour * color;
	
	//final_color.r
	
	gl_FragColor = final_color;
	
}
