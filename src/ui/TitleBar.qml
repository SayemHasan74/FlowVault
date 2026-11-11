import QtQuick

Item {
    id:bar
    property Item glassVideo
    property bool hasVideo: false
    height:38
    GlassSurface {anchors.fill:parent;video:bar.glassVideo;origin:Qt.point(bar.x,bar.y);radius:0}
    Text {
        id:title
        anchors.left:parent.left;anchors.leftMargin:14
        anchors.verticalCenter:parent.verticalCenter
        width:Math.max(0,Math.min(implicitWidth,buttons.x-x-14-(pauseLabel.visible?pauseLabel.implicitWidth+12:0)))
        text:mpv.title;color:UiPalette.text;font.pixelSize:14;font.weight:Font.Medium;elide:Text.ElideRight
    }
    Text {
        id:pauseLabel;visible:bar.hasVideo&&mpv.pause&&bar.width>=520
        anchors.left:title.right;anchors.leftMargin:12;anchors.verticalCenter:parent.verticalCenter
        text:"Paused";color:UiPalette.muted;font.pixelSize:13
    }
    Row {
        id:buttons
        anchors.right:parent.right;anchors.rightMargin:6;anchors.verticalCenter:parent.verticalCenter;spacing:2
        Repeater {
            model:[0,1,2,3,4,5]
            delegate:ActionButton {
                required property int modelData
                objectName:modelData===4?"maximizeButton":""
                width:playerWindow.mini?34:38;height:36;iconSize:modelData<3?18:16;showHint:false
                checked:(modelData===0&&(playerWindow.pinned||playerWindow.mini))||(modelData===1&&playerWindow.mini)||(modelData===4&&playerWindow.maxHovered)
                tint:checked&&modelData<2?UiPalette.accent:UiPalette.text
                icon:["pin",playerWindow.mini?"restore":"mini",playerWindow.fullscreen?"exitFullscreen":"fullscreen","minimize",(playerWindow.maximized||playerWindow.fullscreen||playerWindow.mini)?"restore":"maximize","close"][modelData]
                hint:["Always on top","Mini player · `","Fullscreen · F","Minimize","Maximize / Restore","Close"][modelData]
                onActivated:{
                    switch(modelData) {
                    case 0: playerWindow.togglePinned();break
                    case 1: playerWindow.toggleMini();break
                    case 2: playerWindow.toggleFullscreen();break
                    case 3: playerWindow.requestMinimize();break
                    case 4: playerWindow.toggleMaximized();break
                    case 5: playerWindow.close();break
                    }
                }
            }
        }
    }
}
