package funkin.states;

import flixel.FlxState;
import funkin.system.interfaces.IBeatReceiver;

class MusicBeatState extends FlxState implements IBeatReceiver {
    private var _lastBeat:Int = -1;
    private var _lastStep:Int = -1;

    private var curBeat:Int = 0;
    private var curStep:Int = 0;

    public static var skipTransOut:Bool = false;
    public static var skipTransIn:Bool = false;

    override public function create():Void {
        super.create();
    }

    override public function update(elapsed:Float):Void {
        curStep = Math.floor(Conductor.songPosition / Conductor.stepCrochet);
        curBeat = Math.floor(Conductor.songPosition / Conductor.crochet);

        if (curStep != _lastStep) {
            _lastStep = curStep;
            stepHit(curStep);
            if (curStep % 4 == 0 && curBeat != _lastBeat) {
                _lastBeat = curBeat;
                beatHit(curBeat);
            }
        }

        super.update(elapsed);
    }

    public function beatHit(curBeat:Int):Void {}
    public function stepHit(curStep:Int):Void {}
}