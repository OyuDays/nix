pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Services.SystemTray
import org.kde.kirigami as Kirigami
import "root:."
import ".."

Module {
    id: root

    required property var bar

    x: parent.x

    spacing: Globals.vars.systraySpacing

        
    Repeater {
        model: SystemTray.items
        
        ClickableIcon {
            id: icon
            required property SystemTrayItem modelData
            icon: modelData.icon
            Layout.fillHeight: true
            implicitWidth: height

            iconColor: "#FFFFFF"

            mousearea.hoverEnabled: true

            property bool menuOpen: false

            QsMenuAnchor {
                id: menu
                anchor.window: root.bar
                anchor.rect.x: mapToItem(root.bar.root, icon.mousearea.mouseX, 0).x

                menu: icon.modelData.menu
            }
            mousearea.acceptedButtons: Qt.AllButtons

            onClicked: event => {
                if(event.button == Qt.LeftButton) {
                    if(!this.modelData.onlyMenu) {
                        this.modelData.activate()
                    }
                } else if(event.button == Qt.RightButton) {
                    if(this.modelData.hasMenu) {
                        //icon.menuOpen = !icon.menuOpen
                        //menu.pRelativex = mapToItem(root.bar.root, icon.mousearea.x, 0).x
                        menu.open()
                    }
                } else if(event.button == Qt.MiddleButton) {
                    if(!this.modelData.onlyMenu) {
                        this.modelData.secondaryActivate()
                    }
                }
            }
            onWheel: event => {
                this.modelData.scroll(event.angleDelta,false)
            }

            /*Loader {
                id: menuLoader
                active: icon.menuOpen

                TrayMenu {
                    id: menu
                    visible: icon.menuOpen
                    menu: icon.modelData.menu
                    pBar: root.bar
                    pRelativex: 0
                    pRelativey: 0
                    onClose: icon.menuOpen = false
                }
            }*/
        }
    }
}
