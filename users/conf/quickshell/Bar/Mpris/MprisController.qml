pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris
import "root:."

// alot of stuff taken from https://git.outfoxxed.me/outfoxxed/nixnew/src/branch/master/modules/user/modules/quickshell/shell/bar/mpris/MprisController.qml, thanks!

Singleton {
    id: root
    property MprisPlayer trackedPlayer: null
    property MprisPlayer activePlayer: trackedPlayer ?? Mpris.players.values[0] ?? null
    signal trackChanged()

    property var activeTrack

    Instantiator {
        model: Mpris.players

        Connections {
            required property MprisPlayer modelData;
			target: modelData;

            Component.onCompleted: {
                // if tracked player doesn't exist or this player is playing..
                if(root.trackedPlayer == null || modelData.isPlaying) {
                    root.trackedPlayer = modelData
                }
            }
            Component.onDestruction: {
                // if tracked player doesn't exist or isn't playing..
                if(root.trackedPlayer == null || !root.trackedPlayer.isPlaying) {
                    // find player that is playing..
                    for(const player of Mpris.players.values) {
                        if(player.playbackState.isPlaying) {
                            root.trackedPlayer = player
                            break;
                        }
                    }

                    // if couldn't find player that is playing and there is a player..
                    // just set the player to that one that exists man
                    if(root.trackedPlayer == null && Mpris.players.values.length != 0) {
                        root.trackedPlayer = Mpris.players.values[0]
                    }
                }
            }
            function onPlaybackStateChanged() {
                // if this started playing and it isn't the tracked player..
                // set this to the tracked player
                if(root.trackedPlayer !== modelData) root.trackedPlayer = modelData
            }
        }
    }

    Connections {
        target: root.activePlayer

        function onPostTrackChanged() {
            root.updateTrack
        }

        function onTrackArtUrlChanged() {
            // if this player is the player holds the track and the art url doesnt match the art url we're using..
            if(root.activePlayer.uniqueId == root.activeTrack.uniqueId && root.activePlayer.trackArtUrl != root.activeTrack.artUrl) {
                root.updateTrack()
            }
        }
    }

    onActivePlayerChanged: this.updateTrack()

    function updateTrack() {
        this.activeTrack = {
            uniqueId: this.activePlayer?.uniqueId ?? 0,
            artUrl: this.activePlayer?.trackArtUrl ?? "",
            title: this.activePlayer?.trackTitle || "?",
            artist: this.activePlayer?.trackArtist || "?",
            album: this.activePlayer?.trackAlbum || "?"
        }

        this.trackChanged()

    }

    property bool isPlaying: this.activePlayer && this.activePlayer.isPlaying
	property bool canTogglePlaying: this.activePlayer.canTogglePlaying ?? false
    property bool canGoNext: this.activePlayer.canGoNext ?? false
    property bool canGoPrevious: this.activePlayer.canGoPrevious ?? false
    property bool canChangeVolume: this.activePlayer && this.activePlayer.volumeSupported && this.activePlayer.canControl
    property bool canSeekPosition: this.activePlayer && this.activePlayer.canSeek && this.activePlayer.positionSupported && this.activePlayer.canControl
    property bool loopSupported: this.activePlayer && this.activePlayer.loopSupported && this.activePlayer.canControl
    property bool shuffleSupported: this.activePlayer && this.activePlayer.shuffleSupported && this.activePlayer.canControl

    function togglePlaying() {
        if (this.canTogglePlaying) this.activePlayer.togglePlaying();
    }

    function next() {
        if(this.canGoNext) {
            this.activePlayer.next()
        }
    }

    function previous() {
        if(this.canGoPrevious) {
            this.activePlayer.previous()
        }
    }

    function setLoopState(loopState: var) {
        if(this.loopSupported) {
            this.activePlayer.loopState = loopState
        }
    }

    function setShuffle(shuffleState: bool) {
        if(this.shuffleSupported) {
            this.activePlayer.shuffle = shuffleState
        }
    }

    function setActivePlayer(player: MprisPlayer) {
        const targetPlayer = player ?? Mpris.players[0]

        this.trackedPlayer = targetPlayer
    }
}
