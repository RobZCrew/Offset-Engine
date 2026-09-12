package funkin.states;

import flixel.FlxState;
import funkin.states.transition.MusicBeatTransition;
import funkin.system.debug.DebugPopup;

class MusicBeatState extends FlxState {
    private var _lastBeat:Int = -1;
    private var _lastStep:Int = -1;

    private var curBeat:Int = 0;
    private var curStep:Int = 0;

    private var controls(get, never):Controls;
    private var camDebug:FlxCamera;
    private var debug:DebugPopup;

    public static var skipNextTransOut:Bool = false;
    public static var skipNextTransIn:Bool = false;

    function get_controls():Controls {
        return Controls.instance;
    }

    override public function create():Void {
        if (!skipNextTransOut) {
            openSubState(new MusicBeatTransition(0.5, true));
        }

        camDebug = new FlxCamera();
        camDebug.bgColor.alpha = 0;
        FlxG.cameras.add(camDebug, false);

        debug = new DebugPopup();
        debug.camera = camDebug;
        add(debug);

        super.create();
    }

    override public function update(elapsed:Float):Void {
        if (FlxG.keys.justPressed.F)
            FlxG.fullscreen = !FlxG.fullscreen;

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

    public static function switchState(nextState:FlxState = null) {
		if(nextState == null) nextState = FlxG.state;
		if(nextState == FlxG.state) {
			resetState();
			return;
		}

		if (skipNextTransIn) FlxG.switchState(nextState);
		else startTransition(nextState);
		skipNextTransIn = false;
	}

	public static function resetState() {
		if(skipNextTransIn) FlxG.resetState();
		else startTransition();
		skipNextTransIn = false;
	}

    public static function startTransition(nextState:FlxState = null) {
		if(nextState == null)
			nextState = FlxG.state;

		FlxG.state.openSubState(new MusicBeatTransition(0.5, false));
		if(nextState == FlxG.state)
			MusicBeatTransition.finishCallback = function() FlxG.resetState();
		else
			MusicBeatTransition.finishCallback = function() FlxG.switchState(nextState);
	}

    public function beatHit():Void {}
    public function stepHit():Void {}
}