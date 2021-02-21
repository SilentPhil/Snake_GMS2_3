varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main() {
	vec4 Color = texture2D(gm_BaseTexture, v_vTexcoord);
	Color.a = 1.0;
	gl_FragColor = v_vColour * Color;
}