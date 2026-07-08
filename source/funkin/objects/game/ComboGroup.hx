package funkin.objects.game;

class ComboGroup extends FlxSpriteGroup {
    private var ratingSpr:FlxSprite;

    public function new(camera:FlxCamera = FlxG.camera) {
        super();

        ratingSpr = new FlxSprite();
        ratingSpr.y = 50;
        ratingSpr.screenCenter(X);
        ratingSpr.camera = camera;
        ratingSpr.alpha = 0;
        add(ratingSpr);
    }

    public function popUp(curRating:String, combo:Int = 0) {
        var part1 = 'game/combo/';
        var part2 = '';

        if (PlayState.curStage.startsWith('school')) {
            part1 = 'pixelUI/';
            part2 = '-pixel';
        }

        ratingSpr.loadGraphic(part1 + curRating + part2);
        ratingSpr.scale.set(1.1, 1.1);

        var comboString = Std.string(combo);

        for (i in 0...comboString.length) {
            var num = Std.parseInt(comboString.charAt(i));

            var comboNumSpr = createComboNum(num, i, part1, part2);
            comboNumSpr.x = ratingSpr.x + (i * 40);
            comboNumSpr.y = ratingSpr.y + 100;
            comboNumSpr.scale.set(1.1, 1.1);
            add(comboNumSpr);

            FlxTween.tween(comboNumSpr.scale, {x: 1, y: 1}, 1, {ease: FlxEase.quadOut});
        }

        FlxTween.cancelTweensOf(ratingSpr);
        FlxTween.tween(ratingSpr.scale, {x: 1, y: 1}, 1, {ease: FlxEase.quadOut});
    }

    private static function createComboNum(combo:Int, ?index:Int, ?part1:String, ?part2:String):FlxSprite {
        if (part1 == null) part1 = 'game/combo/';
        if (part2 == null) part2 = '';

        var sprite = new FlxSprite().loadGraphic(part1 + 'num' + combo + part2);
        sprite.scale.set(1.1, 1.1);

        if (index != null)
            comboNumSpr.ID = index;

        return sprite;
    }
}