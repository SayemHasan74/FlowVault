#version 440
layout(location=0) in vec2 qt_TexCoord0;
layout(location=0) out vec4 fragColor;
layout(std140,binding=0) uniform Block {
    mat4 qt_Matrix;
    float qt_Opacity;
    vec2 spread;
} ubuf;
layout(binding=1) uniform sampler2D videoTexture;

void main() {
    vec2 p=qt_TexCoord0, d=ubuf.spread;
    vec3 c=texture(videoTexture,p).rgb*0.20;
    c+=0.10*(texture(videoTexture,p+vec2(d.x,0)).rgb+texture(videoTexture,p-vec2(d.x,0)).rgb
             +texture(videoTexture,p+vec2(0,d.y)).rgb+texture(videoTexture,p-vec2(0,d.y)).rgb);
    c+=0.075*(texture(videoTexture,p+d*0.85).rgb+texture(videoTexture,p-d*0.85).rgb
             +texture(videoTexture,p+vec2(d.x,-d.y)*0.85).rgb+texture(videoTexture,p+vec2(-d.x,d.y)*0.85).rgb);
    c+=0.025*(texture(videoTexture,p+vec2(d.x*2.0,0)).rgb+texture(videoTexture,p-vec2(d.x*2.0,0)).rgb
             +texture(videoTexture,p+vec2(0,d.y*2.0)).rgb+texture(videoTexture,p-vec2(0,d.y*2.0)).rgb);
    float luma=dot(c,vec3(0.213,0.715,0.072));
    fragColor=vec4(clamp(mix(vec3(luma),c,1.8),0.0,1.0),1.0)*ubuf.qt_Opacity;
}
