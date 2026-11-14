import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Services.Pipewire
import "root:."

Module {
    id: root

    property var audioOutput: Pipewire.defaultAudioSink

    PwObjectTracker{objects: [root.audioOutput]}

    icon: audioOutput.audio.muted ? "audio-volume-muted-symbolic"
        : audioOutput.audio.volume >= 0.50 ? "audio-volume-high-danger-symbolic"
        : audioOutput.audio.volume >= 0.30 && audioOutput.audio.volume < 0.50 ? "audio-volume-high-symbolic"
        : audioOutput.audio.volume >= 0.15 && audioOutput.audio.volume < 0.30 ? "audio-volume-medium-symbolic"
        : audioOutput.audio.volume > 0 && audioOutput.audio.volume < 0.15? "audio-volume-low-symbolic"
        : audioOutput.audio.volume == 0 ? "audio-volume-muted-symbolic"
        : ""

    Label {
        color: Globals.colors.text
        font.pointSize: Globals.vars.panelSize/2
        font.family: Globals.vars.fontFamily
        text: `${Math.round(root.audioOutput.audio.volume*100)}%`
    }

    onWheel: event => {
        this.audioOutput.audio.volume += Math.min(Math.max(event.angleDelta.y,-1),1)*0.01
        if(this.audioOutput.audio.volume > 0.60) {
            this.audioOutput.audio.volume = 0.60
        }
    }

    onClicked: event => {
        this.audioOutput.audio.muted = !this.audioOutput.audio.muted
    }
}