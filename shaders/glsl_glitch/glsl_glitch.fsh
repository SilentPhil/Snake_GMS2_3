varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float u_fTime;
uniform float u_fIntensity;

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void main()
{
    vec2 uv = v_vTexcoord;
    
    float noise_block = floor(uv.y * 20.0); 
    float noise = rand(vec2(u_fTime, noise_block));
    
    float displacement = 0.0;
    if (noise > 0.5) {
        displacement = (noise - 0.5) * 0.2 * u_fIntensity;
    }
    
    float rgb_split = 0.02 * u_fIntensity;
    
    float r = texture2D(gm_BaseTexture, vec2(uv.x + displacement + rgb_split, uv.y)).r;
    float g = texture2D(gm_BaseTexture, vec2(uv.x + displacement, uv.y)).g;
    float b = texture2D(gm_BaseTexture, vec2(uv.x + displacement - rgb_split, uv.y)).b;
    float a = texture2D(gm_BaseTexture, vec2(uv.x + displacement, uv.y)).a;

    gl_FragColor = v_vColour * vec4(r, g, b, a);
}
