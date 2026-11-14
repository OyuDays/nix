pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Services.Mpris
import "root:."
import ".."


Module {
    id: root

    required property var bar
    property var activePlayer: MprisController.activePlayer

    property bool widgetOpen: false

    visible: !!activePlayer

    icon: MprisController.isPlaying ? "media-playback-pause" : "media-playback-start"
    Layout.fillHeight: true

    onClicked: event => {
        if(event.button == Qt.LeftButton) {
            MprisController.togglePlaying()
        }
        if(event.button == Qt.RightButton) {
            root.widgetOpen = !root.widgetOpen
        }
    }
    onWheel: event => {
        event.accepted = true
        if(MprisController.canSeekPosition) {
            root.activePlayer.position += Math.min(Math.max(event.angleDelta.y,-1),1)*5 // pos
            if(root.activePlayer.position < 0) MprisController.previous()
            if(root.activePlayer.position > root.activePlayer.length) MprisController.next()
        }
        /*if(MprisController.canChangeVolume) {
            root.activePlayer.volume += Math.min(Math.max(event.angleDelta.y,-1),1)*0.05
            if(root.activePlayer.volume > 1) root.activePlayer.volume = 1
            if(root.activePlayer.volume < 0) root.activePlayer.volume = 0
        }*/
    }

    Label {
        color: Globals.colors.text
        font.pointSize: Globals.vars.panelSize/2
        font.family: Globals.vars.fontFamily
        Layout.preferredWidth: Math.min(implicitWidth,250)

        text: root.activePlayer.trackTitle ?? ""

        elide: Text.ElideRight

        verticalAlignment: Text.AlignVCenter
    }
    Label {
        visible: root.activePlayer.positionSupported
        color: Globals.colors.inactivetext
        font.pointSize: Globals.vars.panelSize/4
        font.family: Globals.vars.fontFamily
        font.italic: true

        text: {
            if(!root.activePlayer) return ""

            return "[" + positionInfo.timeStr(positionInfo.position) + "/"
            + positionInfo.timeStr(positionInfo.length) + "]"
        }
    }

    property Scope positionInfo: Scope {
        id: positionInfo
        property var player: root.activePlayer;
        property real position: player.position
        property real length: player.length

        FrameAnimation {
            id: posTracker

            running: positionInfo.player.isPlaying
            onTriggered: positionInfo.player.positionChanged()
        }
        function timeStr(time: int): string {
            const seconds = time % 60
            const minutes = Math.floor(time/60)

            return `${minutes}:${seconds.toString().padStart(2, '0')}`
        }
    }


    /************/
    /** WIDGET **/
    /************/

    PopupMenu {
        id: widget
        isVisible: root.widgetOpen
        implicitWidth: 300
        implicitHeight: layout.implicitHeight+20

        anchors {
            left: true
            top: true
        }
        
        onExited: root.widgetOpen = false


        ColumnLayout {
            id: layout
            anchors {
                top: parent.top
                horizontalCenter: parent.horizontalCenter
                topMargin: 10
            }

            spacing: 0

            RowLayout { // player selector
                Layout.alignment: Qt.AlignHCenter
                Layout.bottomMargin: 5
                spacing: 5
                Repeater {
                model: Mpris.players
                    Rectangle {
                        id: bg
                        required property MprisPlayer modelData

                        color: MprisController.trackedPlayer == modelData ? Globals.colors.active
                            : Globals.colors.transparent
                        width: icon.implicitWidth+5
                        height: icon.implicitHeight+5
                        //radius: width/4
                        ClickableIcon {
                            id: icon
                            icon: {
                                let icon
                                switch(bg.modelData.desktopEntry) {
                                    //case "spotify": icon = "com.spotify.Client"; break; // i use flatpak spotify and it doesnt report its icon properly :cry:
                                    default: icon = DesktopEntries.byId(bg.modelData.desktopEntry).icon; break;
                                }
                                return Quickshell.iconPath(icon)
                            }
                            anchors.centerIn: parent
                            onClicked: event => MprisController.trackedPlayer = bg.modelData
                        }
                    }
                }
            }

            Label {
                color: Globals.colors.inactivetext
                font.pointSize: Globals.vars.panelSize/3
                font.family: Globals.vars.fontFamily

                text: root.activePlayer.identity

                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: -5
                Layout.bottomMargin: 5
            }

            Image {
                id: img
                sourceSize.height: 140 // set width automatically
                source: root.activePlayer.trackArtUrl

                Layout.preferredHeight: sourceSize.height

                Layout.alignment: Qt.AlignHCenter
            }
            Label { // title
                color: Globals.colors.text
                font.pointSize: Globals.vars.panelSize/2
                font.family: Globals.vars.fontFamily

                Layout.preferredWidth: widget.width - 10
                elide: Text.ElideRight

                text: root.activePlayer.trackTitle ?? "Unknown Title"

                Layout.alignment: Qt.AlignHCenter
                horizontalAlignment: Text.AlignHCenter
            }

            Label { // artist
                color: Globals.colors.inactivetext
                font.pointSize: Globals.vars.panelSize/3
                font.family: Globals.vars.fontFamily

                // doubt this is necessary for artists but better safe than sorry ig
                Layout.preferredWidth: widget.width - 10
                elide: Text.ElideRight

                text: root.activePlayer.trackArtist ?? "Unknown Artist"

                Layout.alignment: Qt.AlignHCenter
                horizontalAlignment: Text.AlignHCenter
            }
            Label { // album
                color: Globals.colors.inactivetext
                font.pointSize: Globals.vars.panelSize/3
                font.family: Globals.vars.fontFamily

                Layout.preferredWidth: widget.width - 10
                elide: Text.ElideRight

                text: root.activePlayer.trackAlbum ?? "Unknown Album"

                Layout.alignment: Qt.AlignHCenter
                horizontalAlignment: Text.AlignHCenter
            }

            // controls

            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 0
                Layout.bottomMargin: 5
                ClickableIcon {
                    icon: root.activePlayer.loopState == MprisLoopState.Track ? "media-repeat-single"
                        : root.activePlayer.loopState == MprisLoopState.Playlist ? "media-repeat-all"
                        : root.activePlayer.loopState == MprisLoopState.None ? "media-repeat-none"
                        : "error-symbolic"
                    color: MprisController.loopSupported ? Globals.colors.text : Globals.colors.inactivetext
                    enabled: MprisController.loopSupported
                    onClicked: event => {
                        let targetLoopState = MprisLoopState.None
                        switch(root.activePlayer.loopState) {
                            case MprisLoopState.None: targetLoopState = MprisLoopState.Playlist; break;
                            case MprisLoopState.Playlist: targetLoopState = MprisLoopState.Track; break;
                            case MprisLoopState.Track: targetLoopState = MprisLoopState.None; break;
                        }
                        MprisController.setLoopState(targetLoopState)
                    }
                }
                ClickableIcon {
                    icon: "media-skip-backward"
                    color: MprisController.canGoNext ? Globals.colors.text : Globals.colors.inactivetext
                    enabled: MprisController.canGoNext
                    implicitWidth: 40
                    implicitHeight: 40

                    onClicked: event => MprisController.previous()
                }
                ClickableIcon {
                    icon: MprisController.isPlaying ? "media-playback-pause" : "media-playback-start"
                    color: MprisController.canTogglePlaying ? Globals.colors.text : Globals.colors.inactivetext
                    enabled: MprisController.canTogglePlaying
                    implicitWidth: 40
                    implicitHeight: 40

                    onClicked: event => MprisController.togglePlaying()
                }
                ClickableIcon {
                    icon: "media-skip-forward"
                    color: MprisController.canGoPrevious ? Globals.colors.text : Globals.colors.inactivetext
                    enabled: MprisController.canGoPrevious
                    implicitWidth: 40
                    implicitHeight: 40

                    onClicked: event => MprisController.next()
                }
                ClickableIcon {
                    icon: root.activePlayer.shuffle ? "media-playlist-shuffle"
                        : "media-playlist-no-shuffle"
                    color: MprisController.shuffleSupported ? Globals.colors.text : Globals.colors.inactivetext
                    enabled: MprisController.shuffleSupported
                    onClicked: event => MprisController.setShuffle(!root.activePlayer.shuffle)

                }
            }

            // progress slider (because ProgressBar and Slider were already taken)

            RowLayout { // position
                Layout.rightMargin: 10
                Layout.leftMargin: 10
                spacing: 10
                ProgressSlider {
                    id: progressBar
                    progressLength: positionInfo.length
                    progressPosition: positionInfo.position

                    Layout.fillWidth: true

                    Layout.alignment: Qt.AlignHCenter

                    onPositionChanged: event => {
                        if(MprisController.canSeekPosition) {
                            var newpos = (event.x/width)*progressLength
                            root.activePlayer.position = Math.min(Math.max(newpos,0),progressLength)
                        }
                    }
                }
                Label {
                    color: Globals.colors.inactivetext
                    font.pointSize: Globals.vars.panelSize/4
                    font.family: Globals.vars.fontFamily

                    text: `${positionInfo.timeStr(positionInfo.position)}/${positionInfo.timeStr(positionInfo.length)}`

                    Layout.alignment: Qt.AlignHCenter
                    Layout.topMargin: -5
                }
            }
            RowLayout { // volume
                Layout.topMargin: 5
                Layout.rightMargin: 10
                Layout.leftMargin: 10
                spacing: 10

                visible: MprisController.canChangeVolume

                ProgressSlider {
                    id: volumeBar
                    progressLength: 1
                    progressPosition: root.activePlayer.volume

                    Layout.fillWidth: true

                    Layout.alignment: Qt.AlignHCenter

                    onPositionChanged: event => {
                        if(MprisController.canChangeVolume) {
                            let newpos = (event.x/width)*progressLength
                            root.activePlayer.volume = Math.min(Math.max(newpos,0),progressLength)
                        }
                    }
                }
                Label {
                    color: Globals.colors.inactivetext
                    font.pointSize: Globals.vars.panelSize/4
                    font.family: Globals.vars.fontFamily

                    text: `${Math.round(root.activePlayer.volume*100)}%`

                    Layout.alignment: Qt.AlignHCenter
                    Layout.topMargin: -5
                }
            }
        }
    }
}
