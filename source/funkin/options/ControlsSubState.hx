package funkin.options;

class ControlsSubState extends MusicBeatSubstate {
    override function create() {
        super.create();

        var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
        bg.scrollFactor.set();
        bg.alpha = 0.5;
        add(bg);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (controls.BACK)
            close();
    }
}