package funkin.system.debug;

import openfl.Lib;
import openfl.display.Sprite;
import openfl.display.Shape;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.system.System;

/**
 * Displays performance information such as FPS and memory usage.
 * Intended for debug and development builds.
 *
 * @author RobZ
 */
class PerformanceOverlay extends Sprite
{
    // CONFIG
    public static inline var PADDING:Int = 6;
    public static inline var BG_ALPHA:Float = 0.6;

    // INTERNAL
    private var _text:TextField;
    private var _background:Shape;

    private var _frames:Int = 0;
    private var _lastTime:Float = 0;
    private var _fps:Int = 0;

    public function new()
    {
        super();

        mouseEnabled = false;
        mouseChildren = false;

        createBackground();
        createText();

        _lastTime = Lib.getTimer();

        addEventListener(Event.ENTER_FRAME, onEnterFrame);
    }

    // SETUP
    private function createText():Void
    {
        _text = new TextField();
        _text.defaultTextFormat = new TextFormat('_sans', 12, 0xFFFFFF);

        _text.selectable = false;
        _text.multiline = false;
        _text.text = 'FPS: 0 • Memory: 0 MB';

        _text.x = PADDING;
        _text.y = PADDING;

        addChild(_text);
    }

    private function createBackground():Void
    {
        _background = new Shape();
        addChildAt(_background, 0);
    }

    // UPDATE
    private function onEnterFrame(_:Event):Void
    {
        _frames++;

        var now = Lib.getTimer();
        var delta = now - _lastTime;

        if (delta >= 1000)
        {
            _fps = _frames;
            _frames = 0;
            _lastTime = now;

            updateText();
        }
    }

    private function updateText():Void
    {
        var memoryMB:Float = System.totalMemory / 1024 / 1024;

        _text.text = 'FPS: ${_fps} • Memory: ${Std.int(memoryMB)} MB';

        redrawBackground();
    }

    // RENDER
    private function redrawBackground():Void
    {
        _background.graphics.clear();
        _background.graphics.beginFill(0x000000, BG_ALPHA);

        _background.graphics.drawRect(0, 0, _text.textWidth + PADDING * 2, _text.textHeight + PADDING * 2);

        _background.graphics.endFill();
    }

    // CLEANUP
    public function destroy():Void
    {
        removeEventListener(Event.ENTER_FRAME, onEnterFrame);

        if (parent != null)
            parent.removeChild(this);
    }
}