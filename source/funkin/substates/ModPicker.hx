package funkin.substates;

import funkin.utils.Mods;
import funkin.objects.menu.MenuColumnItem;

class ModPicker extends MusicBeatSubstate {
    var mods:Array<ModInfo>;
    var curSelected:Int = 0;

    var grpMods:FlxTypedGroup<MenuColumnItem>;

    override function create() {
        super.create();

        var modList = Mods.getModList();
        var hasRealMods = modList.length > 0;

        mods = modList.copy();
        mods.push({
            folder: null,
            name: hasRealMods ? "Disable Mods" : "Base Game",
            author: "",
            version: "",
            isActive: !Mods.hasMod()
        });

        var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        bg.screenCenter();
        bg.alpha = 0.5;
        add(bg);

        refreshUI();
    }

    override function update(elapsed) {
        super.update(elapsed);

        if (controls.UI_UP_P)
            changeSelection(-1);

        if (controls.UI_DOWN_P)
            changeSelection(1);

        if (controls.ACCEPT)
            selectMod();

        if (controls.BACK) {
            FlxG.sound.play(Paths.sound('cancelMenu'));
            close();
        }
    }

    function refreshUI() {
        if (grpMods == null)
            grpMods = new FlxTypedGroup<MenuColumnItem>();

        for (text in grpMods.members) {
            remove(text);
            text.destroy();
        }

        grpMods.clear();

        for (i in 0...mods.length) {
            var mod = mods[i];

            var display = mod.name;

            if (mod.isActive)
                display += ' [ACTIVE]';

            var money = new MenuColumnItem(i, display);
            money.alpha = (i == curSelected) ? 1 : 0.6;
            grpMods.add(money);
        }
    }

    function changeSelection(dir:Int) {
        FlxG.sound.play(Paths.sound('scrollMenu'));
        curSelected = FlxMath.wrap(curSelected + dir, 0, mods.length - 1);

        var curItem:Int = 0;

        for (item in grpMods.members) {
            item.targetY = curItem - curSelected;
            curItem++;

            item.alpha = (item.targetY == 0) ? 1 : 0.6;
        }
    }

    function selectMod() {
        var selected = mods[curSelected];

        if (selected.folder == null) {
            Mods.setCurrentMod(null); // disable mods
        } else {
            Mods.setCurrentMod(selected.folder);
        }

        FlxG.resetGame(); // restart game
    }
}