pragma Singleton
import Quickshell
import Quickshell.Services.Pipewire

Singleton {
    id: root

    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property bool ready: root.sink?.ready ?? false
    readonly property real outputVolume: root.sink?.audio?.volume ?? 0
    readonly property bool outputMuted: root.sink?.audio?.muted ?? false

    readonly property PwNode source: Pipewire.defaultAudioSource
    readonly property real micVolume: root.source?.audio?.volume ?? 0
    readonly property bool micMuted: root.source?.audio?.muted ?? false

    // without this the sink's audio properties are never bound
    PwObjectTracker {
        objects: [root.sink, root.source]
    }

    function setOutputVolume(value: real) {
        if (root.sink?.audio)
            root.sink.audio.volume = Math.max(0, Math.min(1, value));
    }

    function addOutputVolume(delta: real) {
        root.setOutputVolume(root.outputVolume + delta);
    }

    function setOutputMuted(value: bool) {
        if (root.sink?.audio)
            root.sink.audio.muted = value;
    }

    function toggleOutputMute() {
        root.setOutputMuted(!root.outputMuted);
    }

    function setMicVolume(value: real) {
        if (root.source?.audio)
            root.source.audio.volume = Math.max(0, Math.min(1, value));
    }

    function addMicVolume(delta: real) {
        root.setMicVolume(root.micVolume + delta);
    }

    function setMicMuted(value: bool) {
        if (root.source?.audio)
            root.source.audio.muted = value;
    }

    function toggleMicMute() {
        root.setMicMuted(!root.micMuted);
    }
}
