package customFlixel;

import openfl.display.Sprite;
import flixel.FlxSprite;
import flixel.util.FlxColor;

// Designed to draw a OpenFL Sprite as a FlxSprite
// Made in Kade Engine
// Improved by RobZ (Offset Engine)
class OFLSprite extends FlxSprite {
    public var flSprite:Sprite;

    public function new(x:Float = 0, y:Float = 0, width:Int, height:Int, sprite:Sprite) {
        super(x, y);
        makeGraphic(width, height, FlxColor.TRANSPARENT);
        flSprite = sprite;
        pixels.draw(flSprite);
    }

    private var _frameCount:Int = 0;

    override function update(elapsed:Float) {
        if (_frameCount != 2) {
            pixels.draw(flSprite);
            _frameCount++;
        }
    }

    public function updateDisplay() {
        pixels.draw(flSprite);
    }
}