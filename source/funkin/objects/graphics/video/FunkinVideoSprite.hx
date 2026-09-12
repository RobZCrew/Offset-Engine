package funkin.objects.graphics.video;

#if cpp
import hxvlc.flixel.FlxVideoSprite;
import hxvlc.util.Location;

class FunkinVideoSprite extends FlxVideoSprite {
    public var loop(default, set):Bool = false;
    public var finished(get, set):Bool;

    public var fitScreen:Bool = true;

    public var onFormat:Void->Void;
    public var onFinish:Void->Void;

    private var _loaded:Bool = false;
    private var _finished:Bool = false;
    private var _destroyed:Bool = false;
    private var _path:Location;

    @:noCompletion function set_loop(value:Bool):Bool {
        var old = loop;
        if (_loaded)
            return loop = value;
        return loop = old;
    }

    @:noCompletion inline function get_finished():Bool
        return _finished;
    @:noCompletion function set_finished(value:Bool):Bool {
        _finished = value;
        if ((_finished && _loaded) && !_destroyed)
            unsecureFinishVideo();
        return _finished;
    }

    public function new(path:Location, loop:Bool = false, autoPlay:Bool = false, fitScreen:Bool = true) {
        super();

        this.loop = loop;
        this._path = path;

        this.fitScreen = fitScreen;

        load(path, loop ? ['input-repeat=65545'] : null);
        if (autoPlay && _loaded) play();

        bitmap.onFormatSetup.add(function() {
            if (onFormat != null) onFormat();
            if (fitScreen) {
                setGraphicSize(FlxG.width, FlxG.height);
                updateHitbox();
            }
        });

        if (!loop) bitmap.onEndReached.add(finishVideo);
    }

    public override function load(location:Location, ?options:Array<String>):Bool {
        _loaded = true;
        return super.load(location, options);
    }

    public override function play():Bool {
        _finished = false;
        return super.play();
    }

    public override function destroy() {
        if (_destroyed) return;
        onFinish = null;
        _loaded = false;
        _finished = false;
        _destroyed = true;
        super.destroy();
        trace('FunkinVideoSprite: Successfully destroyed video');
    }

    private function finishVideo() {
        if (_finished || _destroyed) return;
        unsecureFinishVideo();
    }

    private function unsecureFinishVideo() {
        if (onFinish != null) onFinish();
        _finished = true;
        destroy();
    }
}
#else
class FunkinVideoSprite {
    public function new() {
        showError();
    }

    private function showError() {
        trace('FunkinVideoSprite: Video is not supported on this platform');
    }
}
#end