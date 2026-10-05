import QtQuick
import qs
import qs.services

EdgePanel {
    id: root

    layerNamespace: "quickshell-audio"
    onRight: Config.volume.onRight
    collapsedWidth: Config.volume.collapsedWidth
    expandedWidth: Config.volume.expandedWidth * 2  // the option is the width of one bar
    bandHeight: Config.volume.bandHeight
    showHandle: Config.volume.handle
    handleColor: Audio.muted || Audio.micMuted ? Theme.lightRed : Theme.teal
    tracks: [speaker.track, mic.track]  // index 0 is the speaker, 1 the mic

    onScrolled: (index, steps) => {
        if (index === 0)
            Audio.addVolume(steps * Config.volume.step);
        else
            Audio.addMicVolume(steps * Config.volume.step);
    }
    onSlid: (index, fraction) => {
        if (index === 0) {
            Audio.setMuted(false);
            Audio.setVolume(fraction);
        } else {
            Audio.setMicMuted(false);
            Audio.setMicVolume(fraction);
        }
    }
    onAltClicked: index => {
        if (index === 0)
            Audio.toggleMute();
        else
            Audio.toggleMicMute();
    }

    Rectangle {
        anchors.fill: parent
        anchors.margins: 4
        radius: 14
        color: Qt.rgba(Theme.ink1.r, Theme.ink1.g, Theme.ink1.b, 0.78)
        border.width: 1
        border.color: Theme.ink3

        Row {
            anchors.fill: parent
            layoutDirection: root.onRight ? Qt.RightToLeft : Qt.LeftToRight

            LevelBar {
                id: speaker

                width: parent.width / 2
                height: parent.height
                volume: Audio.volume
                muted: Audio.muted
                icon: {
                    if (Audio.muted)
                        return "󰝟";
                    if (speaker.level < 0.33)
                        return "󰕿";
                    if (speaker.level < 0.66)
                        return "󰖀";
                    return "󰕾";
                }
            }

            LevelBar {
                id: mic

                width: parent.width / 2
                height: parent.height
                volume: Audio.micVolume
                muted: Audio.micMuted
                icon: Audio.micMuted ? "󰍭" : "󰍬"
            }
        }
    }
}
