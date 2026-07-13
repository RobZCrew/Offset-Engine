package funkin.states;

import lime.utils.Assets;

/**
 * @author RobZ
 */

class CreditsState extends MusicBeatState {
    var scrollGroup:FlxSpriteGroup;
    var scrollY:Float = 0;

    var scrollSpeed:Float = 60;
    var titleSize:Int = 48;
    var entrySize:Int = 28;

    override public function create():Void {
        super.create();
        loadCredits();
    }

    function loadCredits():Void {
        var raw:String = Assets.getText(Paths.json('credits'));
        var data:CreditData = cast haxe.Json.parse(raw);

        if (data.meta != null) {
            if (data.meta.scrollSpeed != null)
                scrollSpeed = data.meta.scrollSpeed;

            if (data.meta.titleSize != null)
                titleSize = data.meta.titleSize;

            if (data.meta.entrySize != null)
                entrySize = data.meta.entrySize;
        }

        scrollGroup = new FlxSpriteGroup();
        add(scrollGroup);

        var yPos:Float = 80;

        for (section in data.sections) {
            var title = new FlxText(0, yPos, FlxG.width, section.title, titleSize);
            title.setFormat(null, titleSize, parseColor(section.color), CENTER);
            scrollGroup.add(title);

            yPos += title.height + 20;

            for (entry in section.entries) {
                var entryText = new FlxText(0, yPos, FlxG.width, entry.name + " - " + entry.role, entrySize);
                entryText.setFormat(null, entrySize, FlxColor.WHITE, CENTER);
                scrollGroup.add(entryText);

                yPos += entryText.height + 12;
            }

            yPos += 40;
        }
    }

    override function update(elapsed:Float):Void {
        if (controls.UI_UP)
            scrollY += scrollSpeed * elapsed;

        if (controls.UI_DOWN)
            scrollY -= scrollSpeed * elapsed;

        scrollY += FlxG.mouse.wheel * 40;
        scrollY = FlxMath.bound(scrollY, -scrollGroup.height + FlxG.height - 40, 0);

        scrollGroup.y = scrollY;

        if (controls.BACK)
            MusicBeatState.switchState(new MainMenuState());

        super.update(elapsed);
    }

    function parseColor(arr:Array<Int>):FlxColor {
        if (arr == null || arr.length < 3)
            return FlxColor.WHITE;

        return FlxColor.fromRGB(arr[0], arr[1], arr[2]);
    }
}

typedef CreditData = {
    var meta:CreditMeta;
    var sections:Array<CreditSection>;
};

typedef CreditMeta = {
    var ?scrollSpeed:Float;
    var ?titleSize:Int;
    var ?entrySize:Int;
};

typedef CreditSection = {
    var title:String;
    var color:Array<Int>;
    var entries:Array<CreditEntry>;
};

typedef CreditEntry = {
    var name:String;
    var role:String;
};