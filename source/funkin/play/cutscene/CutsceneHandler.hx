package funkin.game;

class CutsceneHandler extends FlxSpriteGroup {
    public var state:PlayState;
    public var initialized(default, null):Bool = false;

    public var timedEvents:Array<CutsceneEvent> = [];
    public var video:FunkinVideo;
    public var canPause(get, set):Bool;

    private var _cutsceneTime:Float = 0;

    inline function get_canPause():Bool
        return state.canPause;
    inline function set_canPause(value:Bool):Bool
        return state.canPause = value;

    public function new(instance:PlayState, video:FunkinVideo) {
        super();

        this.state = instance;

        if (video == null) return;

        initialized = true

        this.video = video;

        video.onFinish = () -> {
            state.seenCutscene = true;

            destroy();
            state.remove(this);
        };
    }

    override function update(elapsed:Float) {
        if (!initialized) {
            super.update(elapsed);
            return;
        }

        _cutsceneTime += elapsed;

        while (timedEvents.length > 0 && timedEvents[0].time <= _cutsceneTime) {
            timedEvents[0].func();
            timedEvents.shift();
        }

        if (FlxG.keys.justPressed.ESCAPE && canPause) {
            state.persistentDraw = false;
            state.persistentUpdate = false;
            PauseSubState._onCutscene = true;
            state.openSubState(new PauseSubState());
        }

        super.update(elapsed);
    }
}

typedef CutsceneEvent = {
    var time:Float;
    var func:Void->Void;
}