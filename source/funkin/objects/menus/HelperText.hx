package funkin.objects.menus;

class HelperText extends FlxGroup {
    public var bg:FlxSprite;
    public var field:FlxText;

    public function new(text:String) {
        super();

        bg = new FlxSprite(0, FlxG.height - 26).makeGraphic(FlxG.width, 26, 0xFF000000);
        bg.alpha = 0.6;
        add(bg);

        field = new FlxText(bg.x, bg.y + 4, FlxG.width, text, 16);
        field.setFormat(Paths.font('vcr.ttf'), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.TRANSPARENT);
        field.scrollFactor.set();
        add(field);
    }
}