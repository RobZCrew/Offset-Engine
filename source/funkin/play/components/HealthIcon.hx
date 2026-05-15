package funkin.game;

class HealthIcon extends FlxSprite {
    public var hasLosingIcon:Bool = true;
    public var hasWinningIcon:Bool = false;
    public var character:String;

    public var sprTracker:FlxSprite;

    public function new(character:String = 'bf', isPlayer:Bool = false) {
        super();
        changeIcon(character, isPlayer);
        scrollFactor.set();
    }

    public function changeIcon(character:String = 'bf', isPlayer:Bool = false) {
        if (this.character == character) return;

        this.character = character;

        loadGraphic(Paths.image('icons/$character'), true, 150, 150);

        hasLosingIcon = width >= 200;
        hasWinningIcon = hasLosingIcon && width >= 450;

        antialiasing = true;

        var array = [0];

        if (hasLosingIcon)
            array = [0, 1];
        else if (hasLosingIcon && hasWinningIcon)
            array = [0, 1, 2];

        animation.add(character, array, 0, false, isPlayer);
        animation.play(character);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (sprTracker != null)
            setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
    }
}