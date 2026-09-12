package funkin.objects.options;

class CheckBox extends FlxSprite {
    public var sprTracker:FlxSprite;
    public var addX:Float = 0;
    public var addY:Float = 0;

    public var checked(default, set):Bool = false;

    function set_checked(value:Bool):Bool {
        if (value) {
            if (animation.curAnim.name != 'checked' && animation.curAnim.name != 'check') {
                animation.play('check', true);
                offset.set(34, 25);
            }
        } else {
            animation.play('uncheck', true);
            offset.set(25, 28);
        }
        return checked = value;
    }

    public function new(x:Float = 0, y:Float = 0, ?sprTracker:FlxSprite) {
        super(x, y);

        this.sprTracker = sprTracker;

        frames = Paths.getSparrowAtlas('menus/checkboxanim');
        animation.addByPrefix('unchecked', 'checkbox0', 24, false);
        animation.addByPrefix('uncheck', 'checkbox anim reverse', 24, false);
        animation.addByPrefix('checked', 'checkbox finish', 24, false);
        animation.addByPrefix('check', 'checkbox anim0', 24, false);
        animation.play('unchecked', true);

        setGraphicSize(Std.int(0.9 * width));
        updateHitbox();

        animation.onFinish.add(function(name:String) {
            if (name == 'check') {
                animation.play('checked', true);
                offset.set(3, 12);
            } else if (name == 'uncheck') {
                animation.play('unchecked', true);
                offset.set(0, 2);
            }
        });
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (sprTracker != null) {
            setPosition(sprTracker.x + sprTracker.width + 30 + addX, sprTracker.y - 25 + addY);
        }
    }
}