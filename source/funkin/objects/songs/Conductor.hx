package funkin.objects.songs;

import funkin.objects.songs.Song; // imports the typedefs and enums

typedef BPMChangeEvent = {
    var stepTime:Int;
    var songTime:Float;
    var bpm:Float;
};

class Conductor {
    public static var bpm:Float = 100;
    public static var crochet:Float = (60 / bpm) * 1000;
    public static var stepCrochet:Float = crochet / 4;
    public static var songPosition:Float = 0;
    public static var lastSongPos:Float = 0;

    public static var safeFrames:Int = 10;
    public static var safeZoneOffset:Float = (safeFrames / 60) * 1000;

    public static var bpmChangeMap:Array<BPMChangeEvent> = [];

    public static function changeBPM(newBPM:Float):Void {
        bpm = newBPM;
        crochet = (60 / bpm) * 1000;
        stepCrochet = crochet / 4;
    }

    public static function mapBPMChanges(song:ChartData) {
        bpmChangeMap = [];

        var curBPM:Float = song.meta.bpm;
        var lastTime:Float = 0;
        var totalSteps:Float = 0;

        bpmChangeMap.push({
            stepTime: 0,
            songTime: 0,
            bpm: curBPM
        });

        var events:Array<ChartEvent> = cast song.events;
        events.sort((a, b) -> Std.int(a.t - b.t));

        for (event in events) {
            if (event.type != 'Change BPM')
                continue;

            var eventTime:Float = event.t;
            var newBPM:Float = event.v[0];

            var deltaTime:Float = eventTime - lastTime;
            var stepLength:Float = (60 / curBPM) * 1000 / 4;
            var deltaSteps:Float = deltaTime / stepLength;

            totalSteps += deltaSteps;

            bpmChangeMap.push({
                stepTime: totalSteps,
                songTime: eventTime,
                bpm: newBPM
            });

            curBPM = newBPM;
            lastTime = eventTime;
        }

        trace('Conductor: New BPM Map: $bpmChangeMap');
    }
}