import QtQuick
Rectangle {
    id: button
    property string inputRole: "button"
    property string label: ""
    property string icon: ""
    property int iconSize:22
    property string hint: ""
    property bool checked: false
    property bool orb: false
    property bool pill: false
    property color tint: orb ? UiPalette.ink : UiPalette.text
    property bool showHint: true
    property int textSize: 19
    readonly property bool hovered: hit.containsMouse
    signal activated()
    width: 40; height: 40; radius: Math.min(width,height)/2
    color: hit.containsMouse||checked ? UiPalette.hover : pill ? UiPalette.field : "transparent"
    border.color: orb||pill ? UiPalette.border : "transparent"
    Accessible.role: Accessible.Button
    Accessible.name: hint || label
    Accessible.onPressAction: button.activated()
    Rectangle {
        anchors.fill: parent; visible: button.orb; radius: button.radius
        border.color: "#b3ffffff"
        gradient: Gradient {
            GradientStop {position:0;color:button.hovered?"#ffffff":"#f5ffffff"}
            GradientStop {position:1;color:"#cde0f5"}
        }
    }
    PlayerIcon {anchors.centerIn:parent;width:button.iconSize;height:button.iconSize;name:button.icon;visible:button.icon.length>0;tint:button.enabled?button.tint:UiPalette.muted}
    Text { anchors.centerIn: parent;visible:button.icon.length===0; text: button.label; color: button.enabled?button.tint:UiPalette.muted; font.pixelSize: button.textSize; font.weight:Font.DemiBold }
    MouseArea { id: hit; anchors.fill: parent; hoverEnabled: true; onClicked: button.activated(); onDoubleClicked: event => {event.accepted=true} }
    Rectangle {
        visible: button.showHint && hit.containsMouse && button.hint.length>0
        anchors { horizontalCenter: parent.horizontalCenter; bottom: parent.top; bottomMargin: 6 }
        width: hintText.width+16; height: 24; radius: 12; color: UiPalette.surface; border.color:UiPalette.border; z: 100
        Text { id: hintText; anchors.centerIn: parent; text: button.hint; color: UiPalette.text; font.pixelSize: 11 }
    }
}
