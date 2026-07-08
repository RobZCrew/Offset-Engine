package funkin.menus.ui;

class MenuColumnItem extends Alphabet {
    public var baseY:Float = 70;
    public var spacing:Float = 30;

    public function new(index:Int, text:String, ?baseY:Float = 70, ?spacing:Float = 30) {
        super(0, (baseY * index) + spacing, text, true, false);
        this.baseY = baseY;
        this.spacing = spacing;
        isMenuItem = true;
        targetY = index;
    }
}