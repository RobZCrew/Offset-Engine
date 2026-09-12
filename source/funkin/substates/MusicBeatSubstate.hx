package funkin.substates;

import flixel.FlxSubState;
import funkin.states.transition.MusicBeatTransition;
import funkin.system.debug.DebugPopup;

class MusicBeatSubstate extends FlxSubState {
    private var _lastBeat:Int = -1;
    private var _lastStep:Int = -1;

    private var curBeat:Int = 0;
    private var curStep:Int = 0;

    private var controls(get, never):Controls;
    private var debug:DebugPopup;

    function get_controls():Controls {
        return Controls.instance;
    }

    public function new() {
        super();
    }

    override public function create():Void {
        debug = new DebugPopup();
        insert(999, debug);

        super.create();
    }

    override public function update(elapsed:Float):Void {
        curStep = Math.floor(Conductor.songPosition / Conductor.stepCrochet);
        curBeat = Math.floor(Conductor.songPosition / Conductor.crochet);

        if (curStep != _lastStep) {
            _lastStep = curStep;
            stepHit();
            if (curStep % 4 == 0 && curBeat != _lastBeat) {
                _lastBeat = curBeat;
                beatHit();
            }
        }

        super.update(elapsed);
    }

    public function beatHit():Void {}
    public function stepHit():Void {}
}