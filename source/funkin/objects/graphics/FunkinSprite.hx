package funkin.objects.graphics;

import flixel.addons.effects.FlxSkewedSprite;
import flixel.graphics.FlxGraphic;
import flixel.animation.FlxAnimation;
import flixel.util.typeLimit.OneOfTwo;

enum SpriteType {
    NONE;
    NORMAL;
    SPARROW;
    ATLAS;
}

// Custom FlxSprite that adds FlxAnimate support and some improvements maybe
// TIP 1: You don't need to use type in constructor, you can define it yourself (anyways for atlas i recommend use createAtlas function instead of create it yourself)
// TIP 2: You can set animPaused to true if you want the animation to pause
class FunkinSprite extends FlxSkewedSprite {
    public var type:SpriteType = NONE;

    public var atlas:FlxAnimate;
    public var isAnimateAtlas:Bool = false;
    
    public var animOffsets:Map<String, Array<Float>> = [];
    public var animPaused(get, set):Bool;

    private var _lastPlayedAnimation:String;
    
    public function new(x:Float = 0, y:Float = 0, key:String = '', ?type:SpriteType = NONE) {
        super(x, y);

        this.type = type;

        if ((key == '' || key.length <= 0) || key == null)
            return;

        switch(type) {
            case NORMAL: loadGraphic(Paths.image(key));
            case SPARROW: createSparrow(key);
            case ATLAS: createAtlas(key);
        }
    }

    public function createSparrow(key:String) {
        frames = Paths.getSparrowAtlas(key);
    }

    public function createAtlas(key:String) {
        #if flxanimate
        atlas = new FlxAnimate();
        atlas.showPivot = false;
        try {
            isAnimateAtlas = true;
            atlas.loadAtlas(Paths.getAtlas(key));
        } catch(e:haxe.Exception) {
            FlxG.log.warn('Could not load atlas $key: $e');
            trace(e.stack);
        }
        #else
        FlxG.log.warn('FlxAnimate unsupported or not defined in haxelib');
        #end
    }

    public static function copyFrom(source:FlxSprite):FunkinSprite {
        var spr:FunkinSprite = new FunkinSprite();
        var casted:FunkinSprite = null;
        if (source is FunkinSprite)
            casted = cast source;

        @:privateAccess {
            spr.setPosition(source.x, source.y);
            spr.frames = source.frames;
            spr.animation.copyFrom(source.animation);
            spr.visible = source.visible;
            spr.alpha = source.alpha;
            spr.antialiasing = source.antialiasing;
            spr.scale.set(source.scale.x, source.scale.y);
            spr.scrollFactor.set(source.scrollFactor.x, source.scrollFactor.y);

            if (casted != null) {
                spr.skew.set(casted.skew.x, casted.skew.y);
                spr.animOffsets = new Map<String, Array<Float>>();
                for (key in casted.animOffsets.keys()) {
                    var val = casted.animOffsets.get(key);
                    spr.animOffsets.set(key, [val[0], val[1]]);
                }
            }
        }

        return spr;
    }

    public function makeSolid(width:Int, height:Int, color:FlxColor = FlxColor.WHITE) {
        var graphic:FlxGraphic = FlxG.bitmap.create(2, 2, color, false, 'solid#{color.toHexString(true, false)}');
        frames = graphic.imageFrame;
        scale.set(width / 2, height / 2);
        updateHitbox();
    }

    public function addAnim(animName:String, anim:String, fps:Int = 24, loop:Bool = false) {
        if (!isAnimateAtlas)
            animation.addByPrefix(animName, anim, fps, loop);
        else
            atlas.anim.addBySymbol(animName, anim, fps, loop);
    }

    public function addAnimByIndices(animName:String, anim:String, indices:Array<Int>, fps:Int = 24, loop:Bool = false) {
        if (!isAnimateAtlas)
            animation.addByIndices(animName, anim, indices, '', fps, loop);
        else
            atlas.anim.addBySymbolIndices(animName, anim, indices, fps, loop);
    }

    public function addAnimByFrameLabel(animName:String, anim:String, fps:Int = 24, loop:Bool = false) {
        if (isAnimateAtlas)
            atlas.anim.addByFrameLabel(animName, anim, fps, loop);
    }

    public function addAnimByFrameLabelIndices(animName:String, anim:String, indices:Array<Int>, fps:Int = 24, loop:Bool = false) {
        if (isAnimateAtlas)
            atlas.anim.addByFrameLabelIndices(animName, anim, indices, fps, loop);
    }

    public function playAnim(animName:String, force:Bool = false, reversed:Bool = false, frame:Int = 0):Void {
        if (!isAnimateAtlas)
            animation.play(animName, force, reversed, frame);
        else {
            atlas.anim.play(animName, force, reversed, frame);
            atlas.update(0);
        }
        _lastPlayedAnimation = animName;

        if (animOffsets.exists(animName)) {
            var daOffset:Array<Float> = animOffsets.get(animName);
            if (daOffset != null)
                offset.set(daOffset[0], daOffset[1]);
        }
    }
                
    public function addOffset(name:String, x:Float = 0, y:Float = 0) {
        animOffsets[name] = [x, y];
    }

    public function removeOffset(name:String) {
        animOffsets.remove(name);
    }

    public function switchOffset(anim1:String, anim2:String) {
        if (!animOffsets.exists(anim1) || !animOffsets.exists(anim2))
            return;

        var old = animOffsets[anim1];
        animOffsets[anim1] = animOffsets[anim2];
        animOffsets[anim2] = old;
    }

    public function quickAnimAdd(name:String, anim:String) {
        animation.addByPrefix(name, anim, 24, false);
    }

    
    inline public function isAnimationNull():Bool {
        return !isAnimateAtlas ? (animation.curAnim == null) : (atlas.anim.curInstance == null || atlas.anim.curSymbol == null);
    }

    inline public function getAnimation(name:String):FlxAnimation {
        return animation.getByName(name);
    }

    inline public function getAnimationName():String {
        return _lastPlayedAnimation;
    }

    public function isAnimationFinished():Bool {
        if(isAnimationNull()) return false;
        return !isAnimateAtlas ? animation.curAnim.finished : atlas.anim.finished;
    }

    public function finishAnimation():Void {
        if(isAnimationNull()) return;

        if(!isAnimateAtlas) animation.curAnim.finish();
        else atlas.anim.curFrame = atlas.anim.length - 1;
    }

    public function hasAnimation(anim:String):Bool {
        return getAnimation(anim) != null;
    }

    private function get_animPaused():Bool {
        if(isAnimationNull()) return false;
        return !isAnimateAtlas ? animation.curAnim.paused : !atlas.anim.isPlaying;
    }

    private function set_animPaused(value:Bool):Bool {
        if(isAnimationNull()) return value;
        if(!isAnimateAtlas) animation.curAnim.paused = value;
        else {
            if(value) atlas.pauseAnimation();
            else atlas.resumeAnimation();
        }

        return value;
    }

    public override function destroy() {
        atlas = FlxDestroyUtil.destroy(atlas);
        super.destroy();
    }
}