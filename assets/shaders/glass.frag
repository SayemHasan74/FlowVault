#version 440
layout(location=0) in vec2 qt_TexCoord0;
layout(location=0) out vec4 fragColor;
layout(std140,binding=0) uniform Block {
    mat4 qt_Matrix;
    float qt_Opacity;
    vec2 panelSize;
    vec2 videoSize;
    vec2 sceneOrigin;
    float rounding;
    float deviceScale;
} ubuf;
layout(binding=1) uniform sampler2D videoTexture;

void main() {
    vec2 p=qt_TexCoord0*ubuf.panelSize;
    vec2 local=p-ubuf.panelSize*0.5;
    vec2 q=abs(local)-ubuf.panelSize*0.5+ubuf.rounding;
    float d=length(max(q,vec2(0.0)))+min(max(q.x,q.y),0.0)-ubuf.rounding;
    float coverage=1.0-smoothstep(-1.0,0.0,d);
    float rim=smoothstep(-11.0,-0.5,d);
    // Refract only near the edge. Read the existing mpv texture in this draw.
    vec2 lens=normalize(local+vec2(0.001))*rim*5.0;
    vec2 uv=(ubuf.sceneOrigin+p-lens)/ubuf.videoSize;
    // Contiguous 11-pixel kernel. Each bilinear tap combines two adjacent
    // texels; split the center weight across the two innermost taps.
    const float offsets[6]=float[6](-4.44187624, -2.46760781, -0.66087526, 0.66087526, 2.46760781, 4.44187624);
    const float weights[6]=float[6](0.13595321, 0.19459340, 0.16945338, 0.16945338, 0.19459340, 0.13595321);
    vec2 texel=1.0/(ubuf.videoSize*ubuf.deviceScale);
    vec3 video=vec3(0.0);
    for (int y=0;y<6;++y)
        for (int x=0;x<6;++x)
            video+=texture(videoTexture,uv+vec2(offsets[x],offsets[y])*texel).rgb*weights[x]*weights[y];
    float light=dot(video,vec3(0.2126,0.7152,0.0722));
    vec3 vivid=clamp(mix(vec3(light),video,1.65),0.0,1.0);
    vec3 color=mix(vivid,vec3(12,26,48)/255.0,0.22);
    float v=qt_TexCoord0.y;
    vec4 sheen=v<0.22?mix(vec4(240,250,255,58.65),vec4(179,220,255,20.4),v/0.22):
               v<0.55?mix(vec4(179,220,255,20.4),vec4(179,220,255,0), (v-0.22)/0.33):
                      mix(vec4(104,172,242,0),vec4(104,172,242,17.85),(v-0.55)/0.45);
    color=mix(color,sheen.rgb/255.0,sheen.a/255.0);
    float edge=smoothstep(-1.5,-0.45,d)*mix(0.70,0.32,v);
    color=mix(color,vec3(222,243,255)/255.0,edge);
    fragColor=vec4(color,1.0)*coverage*ubuf.qt_Opacity;
}
