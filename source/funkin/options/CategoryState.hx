package funkin.options;

import funkin.objects.menus.HelperText;
import funkin.objects.menus.MenuColumnItem;
import funkin.objects.options.*;

typedef OptionDef = {
    var name:String;
    var option:String;
    var description:String;
    var type:OptionType;
    var defaultValue:Dynamic;
}

enum OptionType {
    BOOL;
    STRING;
    NUMBER;
}

class CategoryState extends MusicBeatState {
    private var options(default, set):Array<OptionDef> = [];

    private var grpOptions:FlxTypedGroup<MenuColumnItem>;
    private var grpCheckBox:FlxTypedGroup<CheckBox>;
    private var helperText:HelperText;

    private var curSelected:Int = 0;

    function set_options(value:Array<OptionDef>):Array<OptionDef> {
        options = value;
        updateTexts();
        return options;
    }

    override function create() {
        var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menus/menuBG'));
        bg.scrollFactor.set();
        bg.setGraphicSize(Std.int(bg.width * 1.185));
        bg.updateHitbox();
        bg.screenCenter();
        add(bg);

        grpOptions = new FlxTypedGroup<MenuColumnItem>();
        add(grpOptions);

        grpCheckBox = new FlxTypedGroup<CheckBox>();
        add(grpCheckBox);

        helperText = new HelperText('');
        add(helperText);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (controls.BACK)
            MusicBeatState.switchState(new OptionsState());

        if (controls.UI_UP_P)
            changeSelection(-1);

        if (controls.UI_DOWN_P)
            changeSelection(1);

        if (controls.ACCEPT) {
            var curCheckBox:CheckBox = grpCheckBox.members[curSelected];
            curCheckBox.checked = !curCheckBox.checked;

            var value = Reflect.getProperty(Preferences, options[curSelected].option);
            if (value != null && Std.isOfType(value, Bool))
                Reflect.setProperty(Preferences, options[curSelected].option, !value);

            trace('changed value: ' + Std.string(curCheckBox.checked));
        }
    }

    private function changeSelection(change:Int = 0) {
        FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

        curSelected += change;

        if (curSelected < 0)
            curSelected = options.length - 1;
        if (curSelected >= options.length)
            curSelected = 0;

        var currentItem:Int = 0;

        for (item in grpOptions.members) {
            item.targetY = currentItem - curSelected;
            currentItem++;

            item.alpha = 0.6;

            if (item.targetY == 0) {
                item.alpha = 1;
            }
        }

        helperText.field.text = options[curSelected].description ?? '';
    }

    private function addOption(data:OptionDef, onlyPushArray:Bool = false) {
        options.push(data);

        if (!onlyPushArray) {
            updateTexts();
        }
    }

    private function removeOption(index:Int) {
        options.remove(options[index]);
        updateTexts();
    }

    private function updateTexts() {
        grpOptions.clear();
        grpCheckBox.clear();
        for (i in 0...options.length) {
            var option:MenuColumnItem = new MenuColumnItem(i, options[i].name);
            grpOptions.add(option);

            switch(options[i].type) {
                case BOOL:
                    var checkBox:CheckBox = new CheckBox(0, 0, option);
                    grpCheckBox.add(checkBox);

                    if (Std.isOfType(options[i].defaultValue, Bool)) {
                        checkBox.checked = options[i].defaultValue;
                    } else if (Std.isOfType(options[i].defaultValue, String)) {
                        checkBox.checked = options[i].defaultValue.toLowerCase() == 'true';
                    }
                default: // nothing
            }
        }
    }
}