import QtQuick
import qs
import qs.services

EdgePanel {
    id: root

    layerNamespace: "quickshell-sliders"
    onRight: Config.sliders.onRight
    collapsedWidth: Config.sliders.collapsedWidth
    expandedWidth: Config.sliders.expandedWidth * root.tracks.length  // the option is the width of one bar
    bandHeight: Config.sliders.bandHeight
    showHandle: Config.sliders.handle
    handleColor: Audio.outputMuted || Audio.micMuted ? Theme.lightRed : Theme.teal
    // index 0 is the output, 1 the mic, 2 the brightness; the brightness bar
    // only exists on machines with a backlight (see services/Brightness.qml)
    tracks: Brightness.available ? [output.track, mic.track, brightness.track] : [output.track, mic.track]

    onScrolled: (index, steps) => {
        const delta = steps * Config.sliders.step;
        if (index === 0)
            Audio.addOutputVolume(delta);
        else if (index === 1)
            Audio.addMicVolume(delta);
        else
            Brightness.addBrightness(delta);
    }
    onSlid: (index, fraction) => {
        if (index === 0) {
            Audio.setOutputMuted(false);
            Audio.setOutputVolume(fraction);
        } else if (index === 1) {
            Audio.setMicMuted(false);
            Audio.setMicVolume(fraction);
        } else {
            Brightness.setBrightness(fraction);
        }
    }
    // brightness has nothing to mute
    onAltClicked: index => {
        if (index === 0)
            Audio.toggleOutputMute();
        else if (index === 1)
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

            LevelBar {
                id: output

                width: parent.width / root.tracks.length
                height: parent.height
                value: Audio.outputVolume
                muted: Audio.outputMuted
                icon: {
                    if (Audio.outputMuted)
                        return "󰝟";
                    if (output.level < 0.33)
                        return "󰕿";
                    if (output.level < 0.66)
                        return "󰖀";
                    return "󰕾";
                }
            }

            LevelBar {
                id: mic

                width: parent.width / root.tracks.length
                height: parent.height
                value: Audio.micVolume
                muted: Audio.micMuted
                icon: Audio.micMuted ? "󰍭" : "󰍬"
            }

            LevelBar {
                id: brightness

                visible: Brightness.available
                width: parent.width / root.tracks.length
                height: parent.height
                value: Brightness.brightness
                icon: {
                    if (brightness.level < 0.33)
                        return "󰃞";
                    if (brightness.level < 0.66)
                        return "󰃟";
                    return "󰃠";
                }
            }
        }
    }
}
