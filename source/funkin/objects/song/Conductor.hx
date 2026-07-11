package funkin.objects.song;

class Conductor {
    public static var bpm:Float = 100;
    public static var crochet:Float = ((60 / bpm) * 1000);
    public static var stepCrochet:Float = crochet / 4;
    public static var songPosition:Float;
    public static var lastSongPos:Float;
    public static var offset:Float = 0;

    public static var safeFrames:Int = 10;
    public static var safeZoneOffset:Float = (safeFrames / 60) * 1000;

    public function new() {
    }

    public static function changeBPM(newBPM:Float):Void {
        bpm = newBPM;
        crochet = ((60 / bpm) * 1000);
        stepCrochet = crochet / 4;
    }
}