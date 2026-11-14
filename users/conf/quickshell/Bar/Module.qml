import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import "root:."

Item {
    id: root

    default property alias data: content.data
    property string icon: ""
    property int spacing: 0
    property int pWidth: content.implicitWidth
    implicitWidth: pWidth

    Layout.fillHeight: true

    signal clicked(event: MouseEvent)
    signal wheel(event: WheelEvent)
    property alias mousearea: mouseArea

    MouseArea {
        id: mouseArea
        anchors.fill: parent
    RowLayout {
        id: content

        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
        }
        spacing: root.spacing

        Kirigami.Icon {
            id:icon
            visible: !!root.icon // visible only if icon is provided
            source:root.icon
            fallback: "error-symbolic"

            color: Globals.colors.text

            property int size: Globals.vars.panelSize

            roundToIconSize: false

            implicitWidth: size
            implicitHeight: size
        }
    }

    acceptedButtons: Qt.AllButtons
    
    onClicked: event => root.clicked(event)
    onWheel: event => root.wheel(event)
    }
    
}