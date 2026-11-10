import QtQuick

Item {
    id:root
    property string inputRole:"playlist"
    property Item backdrop
    property real sceneTop:38
    property bool opened:false
    property bool animateDrawer:true
    signal closed()
    function close(){opened=false;exitTimer.restart()}
    function durationText(seconds){
        const s=Math.floor(Number(seconds||0))
        if(s<=0)return ""
        return Math.floor(s/60)+":"+String(s%60).padStart(2,"0")
    }
    Component.onCompleted:{opened=true;list.forceActiveFocus()}
    Timer {id:exitTimer;interval:140;onTriggered:root.closed()}
    MouseArea {anchors.fill:parent;onClicked:root.close()}
    Item {
        id:panel;objectName:"playlistPanel"
        readonly property real edge:Math.min(24,root.width*.04)
        readonly property bool shortPanel:root.height<260
        width:Math.min(340,Math.max(260,root.width*.32),root.width-2*edge)
        y:shortPanel?4:Math.min(54,Math.round(root.height*.075))
        height:Math.max(1,root.height-y-(shortPanel?4:Math.min(30,Math.round(root.height*.05))))
        x:root.opened?root.width-width-edge:root.width
        Behavior on x {enabled:root.animateDrawer;NumberAnimation {duration:140}}
        GlassSurface {anchors.fill:parent;backdrop:root.backdrop;sceneOrigin:Qt.point(panel.x,panel.y+root.sceneTop);radius:panel.shortPanel?16:32;tintAlpha:0.42;gloss:0.22;shadowMargin:40}
        MouseArea {anchors.fill:parent;onClicked:event=>{event.accepted=true}}
        Text {x:24;y:panel.shortPanel?10:20;text:"Up next";color:UiPalette.text;font.pixelSize:17;font.weight:Font.DemiBold}
        Text {anchors.right:closeButton.left;anchors.rightMargin:8;y:panel.shortPanel?14:24;text:history.playlist.length+" files";color:UiPalette.muted;font.pixelSize:12}
        ActionButton {id:closeButton;anchors.right:parent.right;anchors.rightMargin:12;y:panel.shortPanel?4:14;width:32;height:32;icon:"close";iconSize:16;hint:"Close playlist · L";showHint:false;onActivated:root.close()}
        ListView {
            id:list;x:16;y:panel.shortPanel?40:56;width:panel.width-32;height:Math.max(0,footer.y-y-9);clip:true
            model:history.playlistModel;currentIndex:history.currentIndex;spacing:8
            boundsBehavior:Flickable.StopAtBounds
            Keys.onEscapePressed:root.close()
            Keys.onReturnPressed:history.playIndex(currentIndex)
            delegate:Rectangle {
                id:row;required property var record;required property int index
                property bool current:index===history.currentIndex
                property bool reordering:false
                property bool suppressClick:false
                width:list.width;height:Math.max(58,name.implicitHeight+status.implicitHeight+21);radius:20
                color:reordering||hover.hovered?UiPalette.hover:current?UiPalette.selection:"transparent"
                border.color:current?UiPalette.border:"transparent"
                HoverHandler {id:hover}
                Rectangle {
                    id:cover;x:12;anchors.verticalCenter:parent.verticalCenter;width:56;height:38;radius:10
                    gradient:Gradient {
                        orientation:Gradient.Horizontal
                        GradientStop {position:0;color:row.current?"#7fb6e8":row.index%3===0?"#6687ba":"#527fb6"}
                        GradientStop {position:1;color:row.current?"#f0b27a":row.index%3===0?"#e9b58d":"#9ccbec"}
                    }
                    PlayerIcon {anchors.centerIn:parent;width:17;height:17;name:row.current?"play":"file";visible:row.current||!row.record.finished}
                    Text {anchors.centerIn:parent;visible:!row.current&&Boolean(row.record.finished);text:"✓";color:UiPalette.text;font.pixelSize:16}
                }
                Text {
                    id:name;x:80;y:8;width:row.width-x-12;text:row.record.title||row.record.path
                    wrapMode:Text.WrapAnywhere;color:UiPalette.text;font.pixelSize:13;font.weight:row.current?Font.DemiBold:Font.Medium
                }
                Text {
                    id:status;x:name.x;y:name.y+name.implicitHeight;width:name.width
                    readonly property string time:root.durationText(row.record.duration)
                    text:(row.current?"Now playing":row.record.finished?"Watched":"")+(time?(row.current||row.record.finished?" · ":"")+time:"")
                    color:UiPalette.muted;font.pixelSize:11
                }
                Rectangle {
                    x:name.x;anchors.bottom:parent.bottom;anchors.bottomMargin:5
                    width:name.width*Math.min(1,Number(row.record.position||0)/Math.max(1,Number(row.record.duration||0)))
                    height:2;radius:1;color:row.record.finished?UiPalette.muted:UiPalette.accent
                }
                MouseArea {
                    anchors.fill:parent;preventStealing:row.reordering
                    onPressed:row.suppressClick=false
                    onClicked:if(!row.suppressClick)history.playIndex(row.index)
                    onPressAndHold:{row.reordering=true;row.suppressClick=true}
                    onReleased:event=>{if(row.reordering){let from=row.index;let point=mapToItem(list.contentItem,event.x,event.y);let target=list.indexAt(point.x,point.y);row.reordering=false;if(target>=0)history.reorder(from,target)}}
                    onCanceled:row.reordering=false
                }
            }
            Text {anchors.centerIn:parent;visible:list.count===0;text:"Open a file to build a playlist";color:UiPalette.muted;font.pixelSize:12}
        }
        Row {
            id:footer;x:16;anchors.bottom:parent.bottom;anchors.bottomMargin:panel.shortPanel?5:16;spacing:8
            width:panel.width-32;height:panel.shortPanel?30:42
            ActionButton {pill:true;width:(footer.width-footer.spacing)/2;height:footer.height;label:"Shuffle";textSize:13;enabled:history.currentIndex>=0&&history.playlist.length-history.currentIndex>2;hint:"Shuffle upcoming files";onActivated:history.shuffleUpcoming()}
            ActionButton {pill:true;width:(footer.width-footer.spacing)/2;height:footer.height;label:preferences.values.autoplayNext?"Autoplay on":"Autoplay off";textSize:13;hint:"Toggle autoplay next";onActivated:preferences.setValue("autoplayNext",!preferences.values.autoplayNext)}
        }
    }
}
