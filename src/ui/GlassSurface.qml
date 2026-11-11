import QtQuick

Item {
    id:glass
    property Item video
    property point origin:Qt.point(0,0)
    property real radius:0

    Rectangle {
        anchors.fill:parent
        visible:!glass.video
        radius:glass.radius
        border.color:UiPalette.border
        gradient:Gradient {
            GradientStop {position:0;color:UiPalette.frostTop}
            GradientStop {position:0.45;color:UiPalette.frostMid}
            GradientStop {position:1;color:UiPalette.frostBottom}
        }
    }
    ShaderEffect {
        anchors.fill:parent
        visible:glass.video!==null
        property var videoTexture:glass.video
        property point sceneOrigin:glass.origin
        property size videoSize:glass.video?Qt.size(Math.max(1,glass.video.width),Math.max(1,glass.video.height)):Qt.size(1,1)
        property size panelSize:Qt.size(width,height)
        property real rounding:Math.min(glass.radius,width/2,height/2)
        fragmentShader:"qrc:/glass/glass.frag.qsb"
    }
}
