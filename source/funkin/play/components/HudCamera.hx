package funkin.game;

class HudCamera extends FlxCamera {
    @:allow(funkin.game.PlayState)
    private var _downscroll:Bool = false;

    public function new(downscroll:Bool = false, x:Float = 0, y:Float = 0, width:Int = FlxG.width, height:Int = FlxG.height) {
        super(x, y, width, height);
        this._downscroll = downscroll;
    }
}