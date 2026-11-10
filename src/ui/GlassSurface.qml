import QtQuick

Item {
    id: glass
    property Item backdrop
    property point sceneOrigin: Qt.point(x,y)
    property real radius: 24
    property real tintAlpha: 0.36
    property real gloss: 0.24
    property real shadowMargin: 24

    Rectangle {
        anchors.fill: parent
        visible: !glass.backdrop
        radius: glass.radius
        border.color: UiPalette.border
        gradient: Gradient {
            GradientStop {position: 0; color: UiPalette.surfaceTop}
            GradientStop {position: 0.48; color: UiPalette.surfaceBottom}
        }
    }
    ShaderEffect {
        visible: glass.backdrop !== null
        anchors.fill: parent
        anchors.margins: -glass.shadowMargin
        property var backdropTexture: glass.backdrop
        property size panelSize: Qt.size(Math.max(1,glass.width),Math.max(1,glass.height))
        property size sceneSize: glass.backdrop ? Qt.size(glass.backdrop.width,glass.backdrop.height) : Qt.size(1,1)
        property point sceneOrigin: glass.sceneOrigin
        property real rounding: Math.min(glass.radius,panelSize.width/2,panelSize.height/2)
        property real margin: glass.shadowMargin
        property real tintAlpha: glass.tintAlpha
        property real gloss: glass.gloss
        fragmentShader: "qrc:/glass/glass.frag.qsb"
    }
}
