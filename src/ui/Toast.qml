import QtQuick
Rectangle {
    id:toast
    property string message:""
    property string inputRole:"toast"
    function show(value) {message=value;life.restart()}
    width:Math.min(parent.width-24,label.implicitWidth+28);height:Math.min(68,label.implicitHeight+20);radius:Math.min(18,height/2);color:UiPalette.surface;border.color:UiPalette.border
    visible:life.running
    Text {id:label;anchors.centerIn:parent;width:Math.min(implicitWidth,parent.width-24);text:toast.message;wrapMode:Text.Wrap;color:UiPalette.text;font.pixelSize:13;horizontalAlignment:Text.AlignHCenter}
    Timer {id:life;interval:1500}
}
