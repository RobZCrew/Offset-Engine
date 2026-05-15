package funkin.graphics.text;

class FunkinText extends FlxText {
    public function new(x:Float = 0, y:Float = 0, width:Int = 0, ?text:String, ?size:Int = 16, ?border:Bool = true) {
        super(x, y, text, size);
        setFormat(Paths.font('vcr.ttf'), size, FlxColor.WHITE);
        if (border) {
            borderStyle = OUTLINE;
            borderSize = 1;
            borderColor = 0xFF000000;
        }
    }
}
