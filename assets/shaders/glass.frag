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
    // A single sample avoids repeated outlines from text behind the panel.
    vec3 video=texture(videoTexture,uv).rgb;
    float light=dot(video,vec3(0.2126,0.7152,0.0722));
    // Match the reference's 190% saturation and 36% blue-black tint.
    vec3 vivid=clamp(mix(vec3(light),video,1.90),0.0,1.0);
    float tint=0.36+0.27*smoothstep(0.62,0.95,light);
    vec3 color=mix(vivid,vec3(18.0,26.0,44.0)/255.0,tint);
    float gloss=0.26*max(0.0,1.0-qt_TexCoord0.y/0.48);
    float edge=smoothstep(-1.6,-0.5,d)*(0.31+0.20*(1.0-qt_TexCoord0.y));
    color=mix(color,vec3(1.0),gloss+edge);
    fragColor=vec4(color,1.0)*coverage*ubuf.qt_Opacity;
}
