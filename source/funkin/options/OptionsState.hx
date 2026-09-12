package funkin.options;

import funkin.objects.menus.MenuColumnItem;

typedef Category = {
    var name:String;
    //var desc:String;
    var ?state:Class<MusicBeatState>;
    var ?substate:Class<MusicBeatSubstate>;
}

class OptionsState extends MusicBeatState {
    private static var categories:Array<Category> = [
        {
            name: 'controls',
            substate: ControlsSubState
        },
        {
            name: 'gameplay',
            state: GameplayChangersState
        }
    ];

    private var grpCategories:FlxTypedGroup<Alphabet>;

    private var curSelected:Int = 0;

    override function create() {
        super.create();

        var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menus/menuBG'));
        bg.scrollFactor.set();
        bg.setGraphicSize(Std.int(bg.width * 1.185));
        bg.updateHitbox();
        bg.screenCenter();
        add(bg);

        grpCategories = new FlxTypedGroup<Alphabet>();
        add(grpCategories);

        for (i in 0...categories.length) {
            var category:Alphabet = new Alphabet(0, (i * 70) + 30, categories[i].name, true, false);
            category.screenCenter(X);
            category.isMenuItem = true;
            category.targetY = i;
            grpCategories.add(category);
        }

        changeSelection();
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (controls.BACK)
            MusicBeatState.switchState(new funkin.states.MainMenuState());

        if (controls.UI_UP_P)
            changeSelection(-1);

        if (controls.UI_DOWN_P)
            changeSelection(1);

        if (controls.ACCEPT) {
            var curCategory:Category = categories[curSelected];
            if (curCategory.state != null) {
                MusicBeatState.switchState(Type.createInstance(curCategory.state, []));
            } else if (curCategory.substate != null) {
                openSubState(Type.createInstance(curCategory.substate, []));
            }
        }
    }

    private function changeSelection(change:Int = 0) {
        FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

        curSelected += change;

        if (curSelected < 0)
            curSelected = categories.length - 1;
        if (curSelected >= categories.length)
            curSelected = 0;

        var currentItem:Int = 0;

        for (item in grpCategories.members) {
            item.targetY = currentItem - curSelected;
            currentItem++;

            item.alpha = 0.6;

            if (item.targetY == 0) {
                item.alpha = 1;
            }
        }
    }
}