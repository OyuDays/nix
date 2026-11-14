import QtQuick
import org.kde.kirigami as Kirigami
import "root:."

Kirigami.Icon {
    id:root

    required property string icon

    property alias mousearea: mouseArea
    property color iconColor: Globals.colors.text 

    source:icon
    fallback: "error-symbolic"
    roundToIconSize: false

    color: iconColor

    signal clicked(event: MouseEvent)
    signal wheel(event: WheelEvent)

    MouseArea {
        id: mouseArea
        anchors.fill: parent

        onClicked: event => root.clicked(event)
        onWheel: event => root.wheel(event)
    }
}
