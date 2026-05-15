package customFlixel;

import Math;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;

class FlxColorSprite extends FlxSprite {
    public var baseColor:FlxColor = FlxColor.WHITE;

    private var _pulseTime:Float = 0;
    private var _pulseSpeed:Float = 0;
    private var _pulseStrength:Float = 0;

    private var _blinkTime:Float = 0;
    private var _blinkInterval:Float = 0;
    private var _blinkState:Bool = false;

    override function update(elapsed:Float) {
        super.update(elapsed);

        updatePulse(elapsed);
        updateBlink(elapsed);
    }

    public function setColor(color:FlxColor) {
        baseColor = color;
        this.color = color;
    }

    public function pulse(speed:Float = 2, strength:Float = 0.5) {
        _pulseSpeed = speed;
        _pulseStrength = strength;
        _pulseTime = 0;
    }

    private function updatePulse(elapsed:Float) {
        if (_pulseStrength <= 0) return;

        _pulseTime += elapsed * _pulseSpeed;

        var value = (Math.sin(_pulseTime) * 0.5 + 0.5);
        var mult = 1 - _pulseStrength + (_pulseStrength * value);

        this.color = FlxColor.fromRGBFloat(baseColor.redFloat * mult, baseColor.greenFloat * mult, baseColor.blueFloat * mult);
    }

    public function stopPulse() {
        _pulseStrength = 0;
        this.color = baseColor;
    }

    public function blink(interval:Float = 0.1) {
        _blinkInterval = interval;
        _blinkTime = 0;
    }

    private function updateBlink(elapsed:Float) {
        if (_blinkInterval <= 0) return;

        _blinkTime += elapsed;

        if (_blinkTime >= _blinkInterval) {
            _blinkTime = 0;
            _blinkState = !_blinkState;
            visible = _blinkState;
        }
    }

    public function stopBlink() {
        _blinkInterval = 0;
        visible = true;
    }

    public function flashColor(color:FlxColor, time:Float = 0.2) {
        this.color = color;

        FlxTween.color(this, time, color, baseColor);
    }
}