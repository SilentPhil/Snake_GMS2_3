varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec2 u_vOffsetFactor;

precision highp float;


void main()
{
	vec4 color = vec4(0.0);

	float arr[3];
	arr[0] = 0.038735;
	arr[1] = 0.113085;
	arr[2] = 0.215007;

	for (int i = 0; i < 3; i += 1) {
		vec4 _color = texture2D(gm_BaseTexture, v_vTexcoord - u_vOffsetFactor.xy * float(i));
		color += vec4(_color.rgb * arr[i], _color.a);
	}
	vec4 _color = texture2D(gm_BaseTexture, v_vTexcoord);
	color += vec4(_color.rgb * 0.266346, _color.a);
	for (int i = 0; i < 3; i += 1) {
		vec4 _color = texture2D(gm_BaseTexture, v_vTexcoord + u_vOffsetFactor.xy * float(i));
		color += vec4(_color.rgb * arr[i], _color.a);
	}
	
	color = clamp(color, 0.0, 1.0);

	gl_FragColor = v_vColour * color;
	
}
