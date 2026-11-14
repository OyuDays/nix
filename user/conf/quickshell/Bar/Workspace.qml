pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Hyprland
import "root:."

// alot of stuff taken from https://github.com/SirEthanator/Quickshell-WIP/blob/main/bar/Workspaces.qml, thanks!
Module {
    id: root

    required property var screen;
    readonly property HyprlandMonitor monitor: Hyprland.monitorFor(screen);

    signal workspaceAdded(workspace: HyprlandWorkspace)

    Repeater {
        model: Globals.vars.workspaceCount
        MouseArea {
            id: wsButton
            
            implicitWidth: wsRect.implicitWidth
            Layout.fillHeight: true

            required property int index

            property HyprlandWorkspace workspace: null
            property bool occupied: workspace != null
            property bool focused: root.monitor.activeWorkspace == workspace

            readonly property int workspaceIndex: index+1

            onPressed: Hyprland.dispatch(`hl.dsp.focus({workspace=${workspaceIndex}})`)

            Connections {
                target: root

                function onWorkspaceAdded(workspace: HyprlandWorkspace) {
                    if(workspace.id == wsButton.workspaceIndex) {
                        wsButton.workspace = workspace;
                    }
                }
            }

            Rectangle {
                id: wsRect

                implicitHeight: parent.height
                implicitWidth: wsButton.focused ? Globals.vars.workspaceSize * 1.5
                            : Globals.vars.workspaceSize

                color: wsButton.focused ? Globals.colors.active
                    : wsButton.occupied ? Globals.colors.inactive
                    : Globals.colors.transparent;

                Label {
                    anchors.centerIn: parent
                    color: wsButton.occupied ? Globals.colors.text
                        : Globals.colors.inactivetext
                    font.pointSize: Globals.vars.panelSize/2
                    font.family: Globals.vars.fontFamily
                    text: wsButton.workspaceIndex
                }

                Behavior on implicitWidth {
                    NumberAnimation {
                        duration: Globals.vars.transitionLength
                        easing.type: Easing.OutQuad
                    }
                }
            }
        }
    }

    Connections {
        target: Hyprland.workspaces;

        function onObjectInsertedPost(workspace) {
            root.workspaceAdded(workspace);
        }
    }

    Component.onCompleted: {
        Hyprland.workspaces.values.forEach(workspace => {
            root.workspaceAdded(workspace);
        })
    }
}
