import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "root:."
import ".."
import "Notifications"

Module {
    id: root
    required property var bar
    property bool menuOpen: false
    icon: menuOpen ? "usermenu-up"
        : "usermenu-down"
    
    mousearea.acceptedButtons: Qt.AllButtons
    onClicked: event => menuOpen = !menuOpen

    PopupMenu {
        implicitWidth: layout.implicitWidth + 40
        implicitHeight: layout.implicitHeight + 40

        anchors {
            right: true
            top: true
        }

        isVisible: root.menuOpen

        onExited: root.menuOpen = false

        ColumnLayout {
            id: layout
            anchors {
                top: parent.top
                horizontalCenter: parent.horizontalCenter
                topMargin: 20
            }
            
            GridLayout {
                rows: 2
                columns: 3
                rowSpacing: 20
                columnSpacing: 20

                Command {
                    pIcon: "system-reboot"
                    pCommand: "reboot"
                    size: 50
                }
                Command {
                    pIcon: "system-shutdown"
                    pCommand: "shutdown now"
                    size: 50
                }
                Command {
                    pIcon: "system-suspend"
                    pCommand: "systemctl suspend"
                    size: 50
                }
                Command {
                    pIcon: "lock"
                    pCommand: "pidof hyprlock || hyprlock"
                    size: 50
                }
                Command {
                    pIcon: "list-remove-user"
                    pCommand: 'hyprctl dispatch "hl.dsp.exit()"'
                    size: 50
                }
            }
            Weather {}
            NotifOverview {}
        }
    }
}
