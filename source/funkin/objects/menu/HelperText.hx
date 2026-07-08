package funkin.menus.ui;

class HelperText extends FlxText {
    public var bg:FlxSprite;

    public function new(text:String) {
        bg = new FlxSprite(0, FlxG.height - 26).makeGraphic(FlxG.width, 26, 0xFF000000);
        bg.alpha = 0.6;
        add(bg);

        super(bg.x, bg.y + 4, FlxG.width, text, 16);
        setFormat(Paths.font('vcr.ttf'), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.TRANSPARENT);
        scrollFactor.set();
    }
}