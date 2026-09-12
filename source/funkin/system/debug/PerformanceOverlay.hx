package funkin.system.debug;

import openfl.Lib;
import openfl.events.Event;
import openfl.display.Sprite;
import openfl.display.Shape;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFieldAutoSize;
import openfl.system.System;

class PerformanceOverlay extends Sprite {
    public static inline var PADDING:Int = 6;
    public static inline var CORNER:Int = 12;
    public static inline var BG_ALPHA:Float = 0.6;

    private var field:TextField;
    private var background:Shape;

    private var _frames:Int = 0;
    private var _lastTime:Float = 0;
    private var _fps:Int = 0;

    public function new() {
        super();

        mouseEnabled = false;
        mouseChildren = false;

        field = new TextField();
        field.x += PADDING  * 2 - 2.25;
        field.y += PADDING * 2 - 2.5;
        field.defaultTextFormat = new TextFormat('_sans', 12, 0xFFFFFF);
        field.autoSize = LEFT;
        field.selectable = false;
        field.multiline = false;
        field.text = 'FPS: 0 · Memory: 0 MB\nOffset Engine v' + Main.version;
        addChild(field);

        background = new Shape();
        background.x += PADDING;
        background.y += PADDING;
        addChildAt(background, 0);

        updateText();

        _lastTime = Lib.getTimer();

        addEventListener(Event.ENTER_FRAME, onEnterFrame);
    }

    private function onEnterFrame(_:Event) {
        _frames++;

        var now = Lib.getTimer();
        var delta = now - _lastTime;

        if (delta >= 1000) {
            _fps = _frames;
            _frames = 0;
            _lastTime = now;

            updateText();
        }
    }

    private function updateText() {
        var memoryMB:Float = System.totalMemory / 1024 / 1024;

        field.text = 'FPS: ' + _fps + ' · Memory: ' + Std.int(memoryMB) + ' MB\nOffset Engine v' + Main.version;

        redrawBackground();
    }

    private function redrawBackground() {
        background.graphics.clear();
        background.graphics.beginFill(0x000000, BG_ALPHA);

        background.graphics.drawRoundRect(0, 0, field.textWidth + PADDING * 2, field.textHeight + PADDING * 2, CORNER, CORNER);

        background.graphics.endFill();
    }

    public function destroy() {
        removeEventListener(Event.ENTER_FRAME, onEnterFrame);

        if (parent != null)
            removeChild(this);
    }
}