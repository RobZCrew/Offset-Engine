package customFlixel;

import flixel.FlxSprite;
import flixel.FlxObject;

class FlxFollowSprite extends FlxSprite {
    public var target:FlxObject;
    public var lerp:Float = 0.2;

    public function follow(obj:FlxObject) {
        target = obj;
    }

    override function update(elapsed:Float) {
        if (target != null) {
            x += (target.x - x) * lerp;
            y += (target.y - y) * lerp;
        }
        super.update(elapsed);
    }
}