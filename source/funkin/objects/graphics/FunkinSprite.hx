package funkin.objects.graphics;

import lime.utils.Assets;
import openfl.utils.Assets as OpenFlAssets;
import openfl.utils.AssetType;
import flixel.animation.FlxAnimation;
import flixel.util.typeLimit.OneOfTwo;
import flixel.system.FlxAssets.FlxGraphicAsset;
import animate.FlxAnimateFrames.FlxAnimateSettings;
import animate.FlxAnimateController.FlxAnimateAnimation;

class FunkinSprite extends FlxAnimate {
    public var animEnabled:Bool = true;
    public var animOffsets:Map<String, FlxPoint> = new Map<String, FlxPoint>();
    public var animPaused(default, set):Bool = false;

    public var animateSettings:FlxAnimateSettings = {};

    public function new(X:Float = 0, Y:Float = 0) {
        super(X, Y);
    }

    public override function destroy() {
        if (animOffsets != null) {
            for (key in animOffsets.keys()) {
                var point = animOffsets.get(key);
                animOffsets.remove(key);
                if (point != null)
                    point.put();
            }
            animOffsets = null;
        }
        super.destroy();
    }

    override function updateAnimation(elapsed:Float) {
        if (animEnabled)
            super.updateAnimation(elapsed);
    }

    public function addOffset(anim:String, x:Float, y:Float) {
        animOffsets.set(anim, FlxPoint.get(x, y));
    }

    public function playAnim(anim:String, force:Bool = false, reversed:Bool = false, frame:Int = 0) {
        if (!hasAnimation(anim)) return;

        animation.play(anim, force, reversed, frame);

        var daOffset = getAnimationOffset(anim);
        offset.set(daOffset.x, daOffset.y);
        daOffset.putWeak();
    }

    public inline function getAnimationOffset(anim:String):FlxPoint {
        if (animOffsets[anim] != null)
            return animOffsets[anim];
        return FlxPoint.weak(0, 0);
    }

    public inline function removeAnimation(anim:String) {
        animation.remove(anim);
    }

    public inline function hasAnimation(anim:String):Bool
        return animation.exists(anim);

    public inline function getAnimation(anim:String):OneOfTwo<FlxAnimation, FlxAnimateAnimation>
        return animation.getByName(anim);

    public inline function stopAnimation()
        animation.stop();

    public inline function isAnimationFinished():Bool
        return animation.curAnim?.finished ?? true;

    public inline function isAnimationReversed():Bool
        return animation.curAnim?.reversed ?? false;

    @:noCompletion function set_animPaused(value:Bool):Bool {
        animPaused = value;

        if (value)
            animation.pause();
        else
            animation.resume();

        return animPaused;
    }
}