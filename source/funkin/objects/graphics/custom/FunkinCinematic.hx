package funkin.onjects.graphics.custom

typedef TweenConfig = {
    var time:Float;
    var ease:Float->Float;
};

class FunkinCinematic extends FlxSpriteGroup {
    public static inline var MAX_ALLOWED_HEIGHT(default, null):Float = 300;

    public var maxHeight(default, set):Float;

    public var up:FlxSprite;
    public var down:FlxSprite;

    public var tweenConfig:TweenConfig = {time: 0.3, ease: FlxEase.quadOut};
    public var appeared:Bool = false;
    public var baseColor:FlxColor;
    public var baseCamera:FlxCamera;
    public var baseHeight(default, set):Float;

    function set_maxHeight(value:Float):Float {
        maxHeight = FlxMath.bound(value, 0, MAX_ALLOWED_HEIGHT);
        baseHeight = FlxMath.bound(baseHeight, 0, maxHeight);
        
        return maxHeight;
    }

    function set_baseHeight(value:Float):Float {
        baseHeight = FlxMath.bound(value, 0, maxHeight);

        if (appeared)
            updatePosition();

        return baseHeight;
    }

    public function new(tweenConfig:TweenConfig, height:Float, maxHeight:Float = MAX_ALLOWED_HEIGHT, ?camera:FlxCamera = FlxG.camera, ?color:FlxColor = FlxColor.BLACK) {
        super();

        if (tweenConfig != null) // If is null then will use the default one
            this.tweenConfig = tweenConfig;
        
        this.maxHeight = maxHeight;
        baseHeight = height;
        baseCamera = camera;
        baseColor = color;

        up = new FlxSprite().makeGraphic(FlxG.width, maxHeight, color);
        up.y = -maxHeight;
        up.camera = camera;
        add(up);

        down = new FlxSprite().makeGraphic(FlxG.width, maxHeight, color);
        down.y = FlxG.height;
        down.camera = camera;
        add(down);
    }

    public function appear(?doTween:Bool = true) {
        clearTweens();

        if (!doTween) {
            up.y = maxHeight - baseHeight;
            down.y = FlxG.height - baseHeight;
        } else {
            FlxTween.tween(up, {y: maxHeight - baseHeight}, tweenConfig.time, {ease: tweenConfig.ease});
            FlxTween.tween(down, {y: FlxG.height - baseHeight}, tweenConfig.time, {ease: tweenConfig.ease});
        }

        appeared = true;
    }

    public function disappear(?doTween:Bool = true) {
        clearTweens();

        if (!doTween) {
            up.y = -maxHeight;
            down.y = FlxG.height;
        } else {
            FlxTween.tween(up, {y: -maxHeight}, tweenConfig.time, {ease: tweenConfig.ease});
            FlxTween.tween(down, {y: FlxG.height}, tweenConfig.time, {ease: tweenConfig.ease});
        }

        appeared = false;
    }

    private function updatePosition() {
        up.y = maxHeight - baseHeight;
        down.y = FlxG.height - baseHeight;
    }

    public function clearTweens() {
        FlxTween.cancelTweensOf(up);
        FlxTween.cancelTweensOf(down);
    }
}