package funkin.graphics.video;

import hxvlc.flixel.FlxVideoSprite;
import hxvlc.util.Location;

// Custom FlxVideoSprite that adds a better performance for new modders and some improvements maybe
// TIP 1: You can finish the video with just setting finished to true (may cause some bugs i think)
// TIP 2: You can still add signals to onFormatSetup and onEndReached, onFormat and onEnd just exists for new modders
class FunkinVideo extends FlxVideoSprite {
    public var loop(default, set):Bool = false;
    public var finished(get, set):Bool;

    public var addBackground:Bool = false;
    public var videoBackground(default, null):FlxSprite;

    public var onFormat:Void->Void;
    public var onEnd:Void->Void;

    private var _ended:Bool = false;
    private var _loaded:Bool = false;
    private var _destroyed:Bool = false;
    private var _path:Location; // you can use Paths.video(...) (string), int or bytes

    function set_loop(value:Bool):Bool {
        var old = loop;

        if (!_loaded)
            return loop = value;

        return loop = old;
    }

    inline function get_finished():Bool
        return _ended;
    function set_finished(value:Bool):Bool {
        _ended = value;

        if ((_ended && _loaded) && !_destroyed)
            unsecureFinishVideo();

        return _ended;
    }

    public function new(path:Location, ?autoPlay:Bool = false, ?loop:Bool = false, ?addBackground:Bool = false) {
        super();

        this.loop = loop;
        this._path = path;

        if (addBackground) {
            if (videoBackground == null) {
                videoBackground = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
                add(videoBackground);
            }
        }

        load(path, loop ? ['input-repeat=65545'] : null);
        if (autoPlay) play();

        if (!loop) bitmap.onEndReached.add(finishVideo);

        bitmap.onFormatSetup.add(function() {
            if (onFormat != null) onFormat();
            setGraphicSize(FlxG.width, FlxG.height);
            updateHitbox();
            screenCenter();
        });
    }

    public override function load(location:Location, ?options:Array<String>):Bool {
        _loaded = true;
        return super.load(location, options);
    }

    public override function play():Void {
        _ended = false;
        super.play();
    }

    private function finishVideo():Void {
        if (_destroyed || _ended) return;
        unsecureFinishVideo();
    }

    private function unsecureFinishVideo():Void {
        if (onEnd != null) onEnd();
        _ended = true;
        destroy();
    }

    private function clearBackground():Void {
        if (videoBackground != null) {
            remove(videoBackground);
            videoBackground = null;
        }
    }

    override function destroy():Void {
        if (_destroyed) return;

        clearBackground();

        onEnd = null;
        _ended = false;
        _loaded = false;

        super.destroy();
        _destroyed = true;
        trace('FunkinVideo: Video successfully destroyed.');
    }
}