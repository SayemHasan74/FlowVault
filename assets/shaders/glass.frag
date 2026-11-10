#version 440
layout(location=0) in vec2 qt_TexCoord0;
layout(location=0) out vec4 fragColor;
layout(std140,binding=0) uniform Block {
    mat4 qt_Matrix;
    float qt_Opacity;
    vec2 panelSize;
    vec2 sceneSize;
    vec2 sceneOrigin;
    float rounding;
    float margin;
    float tintAlpha;
    float gloss;
} ubuf;
layout(binding=1) uniform sampler2D backdropTexture;

float distanceToGlass(vec2 p) {
    vec2 q=abs(p-ubuf.panelSize*0.5)-ubuf.panelSize*0.5+ubuf.rounding;
    return length(max(q,vec2(0.0)))+min(max(q.x,q.y),0.0)-ubuf.rounding;
}

void main() {
    vec2 p=qt_TexCoord0*(ubuf.panelSize+2.0*ubuf.margin)-ubuf.margin;
    float d=distanceToGlass(p);
    float cover=1.0-smoothstep(-0.5,0.5,d);
    float shadow=0.0;
    if (ubuf.margin>0.0) {
        float s=max(0.0,distanceToGlass(p-vec2(0.0,ubuf.margin*0.30)));
        shadow=0.40*exp(-s*s/(ubuf.margin*ubuf.margin*0.32))*(1.0-smoothstep(ubuf.margin*0.60,ubuf.margin,s));
    }
    vec2 sampleUv=clamp((ubuf.sceneOrigin+p)/ubuf.sceneSize,vec2(0.0),vec2(1.0));
    vec3 blurred=texture(backdropTexture,sampleUv).rgb;
    vec3 tint=vec3(18.0,26.0,44.0)/255.0;
    vec3 color=mix(blurred,tint,ubuf.tintAlpha);
    float highlight=ubuf.gloss*max(0.0,1.0-p.y/max(1.0,ubuf.panelSize.y*0.44));
    float edge=smoothstep(-1.7,-0.25,d)*(0.18+0.27*(1.0-clamp(p.y/ubuf.panelSize.y,0.0,1.0)));
    color=mix(color,vec3(1.0),clamp(highlight+edge,0.0,0.75));
    fragColor=(vec4(color,1.0)*cover+vec4(0.025,0.045,0.11,1.0)*shadow*(1.0-cover))*ubuf.qt_Opacity;
}
