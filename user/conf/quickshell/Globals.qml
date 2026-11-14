pragma Singleton

import Quickshell
import QtQuick

Singleton {

    readonly property alias colors: colorBreezeLight;

    readonly property QtObject vars: QtObject {
        id: vars

        property int panelSize: 24
        property int spacing: 10
        property int barMargin: 5
        property int workspaceCount: 9
        property int workspaceSize: 30
        property int systraySpacing: 5
        property string fontFamily: "Noto Sans"

        property int transitionLength: 100
    }

    // colors

    readonly property QtObject colorCustomDark: QtObject {
        id: colorCustomDark

        property color panelbg: "#dd19191f" // transparency
        property color bg: "#19191f"
        property color active: "#484864"
        property color inactive: "#323238"
        property color text: "#ffffff"
        property color inactivetext: "#999999"
        property color transparent: "#00000000"
    }

    readonly property QtObject colorRosePineDawn: QtObject {
        id: colorRosePineDawn

        property color panelbg: "#faf4ed" // transparency (not)
        property color bg: "#faf4ed"
        property color active: "#56949f"
        property color inactive: "#cecacd"
        property color text: "#575279"
        property color inactivetext: "#9893a5"
        property color transparent: "#00000000"
    }

    readonly property QtObject colorRosePineMoon: QtObject {
        id: colorRosePineMoon

        property color panelbg: "#232136" // transparency (not)
        property color bg: "#232136"
        property color active: "#c4a7e7"
        property color inactive: "#56526e"
        property color text: "#e0def4"
        property color inactivetext: "#6e6a86"
        property color transparent: "#00000000"
    }

    readonly property QtObject colorBreezeLight: QtObject {
        id: colorBreezeLight

        property color panelbg: "#eff0f1"
        property color bg: "#eff0f1"
        property color active: "#3daee9"
        property color inactive: "#8ecbe9"
        property color text: "#31363b"
        property color inactivetext: "#afb0b3"
        property color transparent: "#00000000"
    }

    readonly property QtObject colorAss: QtObject {
        id: colorAss

        property color panelbg: "#414078" // transparency (not)
        property color bg: "#414078"
        property color active: "#d4e07d"
        property color inactive: "#9ea334"
        property color text: "#70c91c"
        property color inactivetext: "#7a1943"
        property color transparent: "#00000000"
    }


}
