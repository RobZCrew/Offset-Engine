package customFlixel;

import Math;
import flixel.FlxSprite;

class FlxFloatSprite extends FlxSprite {
    public var floatAmplitudeX:Float = 0;
    public var floatAmplitudeY:Float = 5;
    public var floatSpeed:Float = 2;

    private var _time:Float = 0;
    private var _baseX:Float = 0;
    private var _baseY:Float = 0;
    private var _initialized:Bool = false;

    override function update(elapsed:Float) {
        super.update(elapsed);

        // Save base position just one time
        if (!_initialized) {
            _baseX = x;
            _baseY = y;
            _initialized = true;
        }

        _time += elapsed * floatSpeed;

        // Clean movement (whitout acumule)
        x = _baseX + Math.sin(_time) * floatAmplitudeX;
        y = _baseY + Math.sin(_time) * floatAmplitudeY;
    }

    public function setFloat(amplitudeX:Float, amplitudeY:Float, speed:Float) {
        floatAmplitudeX = amplitudeX;
        floatAmplitudeY = amplitudeY
        floatSpeed = speed;
    }

    public function resetFloatBase() {
        _baseX = x;
        _baseY = y;
    }

    public function stopFloat() {
        floatAmplitudeX = 0;
        floatAmplitudeY = 0;
        x = _baseX;
        y = _baseY;
    }
}