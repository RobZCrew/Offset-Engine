package funkin.game;

class NoteSplash extends FlxSprite {
    public var finished:Bool = false;

    public function new() {
        super();

        frames = Paths.getSparrowAtlas('game/splashes/default');
        animation.addByPrefix('left1', 'note splash purple1', 24, false);
        animation.addByPrefix('down1', 'note splash blue1', 24, false);
        animation.addByPrefix('up1', 'note splash green1', 24, false);
        animation.addByPrefix('right1', 'note splash red1', 24, false);
        animation.addByPrefix('left2', 'note splash purple2', 24, false);
        animation.addByPrefix('down2', 'note splash blue2', 24, false);
        animation.addByPrefix('up2', 'note splash green2', 24, false);
        animation.addByPrefix('right2', 'note splash red2', 24, false);

        animation.finishCallback = function(name:String) {
            finished = true;
            visible = false;
        };

        visible = false;
    }

    public function playSplash(dir:Int, x:Float, y:Float):Void {
        setPosition(x, y);
        finished = false;
        visible = true;

        var random = FlxG.random.int(1, 2);

        switch(dir) {
            case 0: playAnim('left' + random, true);
            case 1: playAnim('down' + random, true);
            case 2: playAnim('up' + random, true);
            case 3: playAnim('right' + random, true);
        }
    }
}