pragma Singleton
import Quickshell
import Quickshell.Services.Pipewire

// The default audio sink as live-bound properties. Reads and writes go
// straight to pipewire, so the widget follows volume keys and other apps
// instead of polling pactl.
Singleton {
    id: root

    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property bool ready: root.sink?.ready ?? false
    readonly property real volume: root.sink?.audio?.volume ?? 0
    readonly property bool muted: root.sink?.audio?.muted ?? false

    // without this the sink's audio properties are never bound
    PwObjectTracker {
        objects: [root.sink]
    }

    function setVolume(value: real) {
        if (root.sink?.audio)
            root.sink.audio.volume = Math.max(0, Math.min(1, value));
    }

    function addVolume(delta: real) {
        root.setVolume(root.volume + delta);
    }

    function setMuted(value: bool) {
        if (root.sink?.audio)
            root.sink.audio.muted = value;
    }

    function toggleMute() {
        root.setMuted(!root.muted);
    }
}
