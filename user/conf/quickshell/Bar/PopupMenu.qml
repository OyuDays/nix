import Quickshell
import Quickshell.Hyprland
import QtQuick
import "root:."



PanelWindow {
    id: root
    required property bool isVisible
    visible: isVisible

    onIsVisibleChanged: {
        if(isVisible) focusGrab.active = true
    }

    default property alias data: content.data
    
    color: Globals.colors.transparent // transparent, let rectangle do its thing

    signal clicked(event: MouseEvent)
    signal wheel(event: WheelEvent)
    signal exited()

    HyprlandFocusGrab {
        id: focusGrab 
        windows: [ root ]
        onCleared: root.exited()
    }
    MouseArea {
        id: mouseArea

        anchors.fill: parent

        onClicked: event => root.clicked(event)
        onWheel: event => root.wheel(event)
        //onExited: root.exited()
        Rectangle {
            id: content

            focus: true

            color: focus ? Globals.colors.panelbg
                : Globals.colors.transparent

            anchors.fill: parent
        }
    }
}