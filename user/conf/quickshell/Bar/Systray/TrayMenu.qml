pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Services.SystemTray
import "root:."
import ".."

PopupMenu {
    id: root

    required property var pBar
    required property int pRelativex
    required property int pRelativey
    window: pBar
    relativex: pRelativex
    relativey: pRelativey

    width: layout.implicitWidth
    height: layout.implicitHeight

    property alias menu: trayMenu.menu

    signal close()
    QsMenuOpener {
        id: trayMenu
    }

    ColumnLayout {
        id: layout
        spacing: 0

        Repeater {
            model: trayMenu.children
            
            Rectangle {
                id: container
                required property var modelData
                width: containerlayout.implicitWidth+4
                height: modelData.isSeparator ? 5
                    : 20

                Layout.fillWidth: true

                color: mousearea.containsMouse && !modelData.isSeparator ? Globals.colors.inactive
                    : Globals.colors.transparent

                RowLayout {
                    id: containerlayout
                    Image {
                        id: icon
                        source: container.modelData.icon
                        sourceSize: Qt.size(20,20)
                        Layout.preferredHeight: 20
                        Layout.preferredWidth: 20
                    }
                    Label {
                        id: label
                        color: Globals.colors.text
                        font.pointSize: container.height/2
                        font.family: Globals.vars.fontFamily

                        width: 250

                        elide: Text.ElideRight

                        text: container.modelData.text
                    }
                }

                MouseArea {
                    id: mousearea
                    hoverEnabled: true
                    anchors.fill: parent

                    onClicked: event => {
                        container.modelData.triggered()
                    }
                }
            }
        }
    }
}