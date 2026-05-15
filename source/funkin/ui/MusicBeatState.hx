package funkin.ui;

import openfl.display.BitmapData;
import flixel.FlxState;
import flixel.addons.transition.FlxTransitionableState;
import funkin.ui.transition.MusicBeatTransition;

@:bitmap("assets/images/ui/cursor.png")
class FunkinCursor extends BitmapData {}

class MusicBeatState extends FlxState {
    private var curBeat:Int = 0;
    private var curStep:Int = 0;

    private var _lastBeat:Int = -1;
    private var _lastStep:Int = -1;

    public var controls(get, never):Controls;

    private function get_controls():Controls
        return Controls.instance;

    public var variables:Map<String, Dynamic> = new Map<String, Dynamic>();
    public static function getVariables()
        return getState().variables;

    override function create() {
        var skip:Bool = FlxTransitionableState.skipNextTransOut;

        if (!(FlxG.mouse.cursor?.bitmapData is FunkinCursor)
            FlxG.mouse.load(new FunkinCursor(0, 0));

        super.create();

        if (!skip) {
            openSubState(new MusicBeatTransition(0.5, true));
        }
        FlxTransitionableState.skipNextTransOut = false;
    }

    public static function switchState(newState:FlxState = null):Void {
        if (newState == null) newState = FlxG.state;
        if (newState == FlxG.state) {
            resetState();
            return; // avoid the function to do something else
        }

        if (FlxTransitionableState.skipNextTransIn) FlxG.switchState(newState);
        else startTransition(newState);
        FlxTransitionableState.skipTransIn = false;
    }

    public static function resetState():Void {
        if (FlxTransitionableState.skipNextTransIn) FlxG.resetState();
        else startTransition();
        FlxTransitionableState.skipTransIn = false;
    }

    public static function startTransition(?newState:FlxState = null):Void {
        if (newState == null) newState = FlxG.state;

        FlxG.state.openSubState(new MusicBeatTransition(0.5, false));

        if (newState == FlxG.state)
            MusicBeatTransition.finishCallback = () -> FlxG.resetState();
        else
            MusicBeatTransition.finishCallback = () -> FlxG.switchState(newState);
    }

    public static function getState():MusicBeatState {
       return cast(FlxG.state, MusicBeatState);
    }

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

    public function beatHit():Void {}
    public function stepHit():Void {}
}