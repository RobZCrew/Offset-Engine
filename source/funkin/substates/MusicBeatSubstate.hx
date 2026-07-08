package funkin.ui;

class MusicBeatSubstate extends FlxSubState {
    private var curBeat:Int = 0;
    private var curStep:Int = 0;

    private var _lastBeat:Int = -1;
    private var _lastStep:Int = -1;

    public var controls(get, never):Controls;

    private function get_controls():Controls
        return Controls.instance;

    override function update(elapsed:Float):Void {
        super.update(elapsed);

        // Calculate current beat and step
        curBeat = Math.floor(Conductor.songPosition / Conductor.crochet);
        curStep = Math.floor(Conductor.songPosition / Conductor.stepCrochet);

        // Step hit
        if (curStep != _lastStep) {
            _lastStep = curStep;
            stepHit();

            // Beat hit
            if (curStep % 4 == 0 && curBeat != _lastBeat) {
                _lastBeat = curBeat;
                beatHit();
            }
        }
    }

    public static function beatHit():Void {}
    public static function stepHit():Void {}
}