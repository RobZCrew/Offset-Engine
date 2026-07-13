package funkin.states;

class MainMenuState extends MusicBeatState {
    private static var version:String = '0.1.0';
    public static var curSelected:Int = 0;

    private var camGame:FlxCamera;
    private var camAchievement:FlxCamera;
    private var camFollow:FlxObject;
    private var camFollowPos:FlxObject;
    private var magenta:FlxSprite;
    private var menuItems:FlxTypedGroup<FlxSprite>;
    private var engineVersion:FlxText;

    private var optionShit:Array<String> = [
        'story_mode',
        'freeplay',
        'credits',
        'options'
    ];
    private var shiftMult:Int = 1;

    override public function create():Void {
        camGame = new FlxCamera();
        camAchievement = new FlxCamera();
        camAchievement.bgColor.alpha = 0;

        FlxG.cameras.reset(camGame);
        FlxG.cameras.add(camAchievement);
        FlxG.cameras.setDefaultDrawTarget(camGame, true);

        persistentUpdate = true;
        persistentDraw = true;

        var yScroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);
        var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menus/menuBG'));
        bg.scrollFactor.set(0, yScroll);
        bg.setGraphicSize(Std.int(bg.width * 1.185));
        bg.updateHitbox();
        bg.screenCenter();
        add(bg);

        camFollow = new FlxObject(0, 0, 1, 1);
        add(camFollow);

        camFollowPos = new FlxObject(0, 0, 1, 1);
        add(camFollowPos);

        magenta = new FlxSprite(-80).loadGraphic(Paths.image('menus/menuDesat'));
        magenta.scrollFactor.set(0, yScroll);
        magenta.setGraphicSize(Std.int(bg.width * 1.175));
        magenta.updateHitbox();
        magenta.screenCenter();
        magenta.visible = false;
        magenta.color = 0xFFfd719b;
        add(magenta);

        menuItems = new FlxTypedGroup<FlxSprite>();
        add(menuItems);

        var scale:Float = 0.9;

        for (i in 0...optionShit.length) {
            var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
            var menuItem:FlxSprite = new FlxSprite(0, (i * 140) + offset);
            menuItem.scale.x = scale;
            menuItem.scale.y = scale;
            menuItem.frames = Paths.getSparrowAtlas('menus/mainmenu/menu_' + optionShit[i]);
            menuItem.animation.addByPrefix('idle', optionShit[i] + ' idle', 24);
            menuItem.animation.addByPrefix('selected', optionShit[i] + ' selected', 24);
            menuItem.animation.play('idle');
            menuItem.ID = i;
            menuItem.screenCenter(X);
            menuItems.add(menuItem);
            var scr:Float = (optionShit.length - 4) * 0.135;
            if (optionShit.length < 6) scr = 0;
            menuItem.scrollFactor.set(0, scr);
            menuItem.updateHitbox();
        }

        //FlxG.camera.follow(camFollowPos, null, 1);

        engineVersion = new FlxText(5, FlxG.height - 18, 0, 'Offset Engine v' + version, 12);
        engineVersion.scrollFactor.set();
        engineVersion.setFormat(Paths.font('vcr.ttf'), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        add(engineVersion);

        changeItem();

        super.create();
    }

    var selectedSomethin:Bool = false;

    override public function update(elapsed:Float):Void {
        var lerpVal:Float = CoolUtil.boundTo(elapsed * 7.5, 0, 1);
        camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));
        //trace(camFollowPos.x + ', ' + camFollowPos.y);

        if (FlxG.keys.justPressed.SEVEN)
            MusicBeatState.switchState(new funkin.states.editors.TestEditorState());

        if (!selectedSomethin) {
            if (controls.UI_UP_P) {
                FlxG.sound.play(Paths.sound('scrollMenu'));
                changeItem(-1);
            }

            if (controls.UI_DOWN_P) {
                FlxG.sound.play(Paths.sound('scrollMenu'));
                changeItem(1);
            }

            if (controls.BACK) {
                debug.showPopup("You can't go back to TitleState due to a crash");
                trace('blocked');
            }

            if (FlxG.mouse.wheel != 0) {
                FlxG.sound.play(Paths.sound('scrollMenu'), 0.2);
                changeItem(-shiftMult * FlxG.mouse.wheel);
            }

            if (controls.ACCEPT) {
                if (optionShit[curSelected] == 'merch') {
                    CoolUtil.browserLoad('https://www.makeship.com/shop/creator/friday-night-funkin');
                }

                if (optionShit[curSelected] == 'donate') {
                    CoolUtil.browserLoad('https://ninja-muffin24.itch.io/funkin');
                } else {
                    selectedSomethin = true;
                    FlxG.sound.play(Paths.sound('confirmMenu'));

                    if (Preferences.flashing) FlxFlicker.flicker(magenta, 1.1, 0.15, false);

                    menuItems.forEach(function(spr:FlxSprite) {
                        if (curSelected != spr.ID) {
                            FlxTween.tween(spr, {alpha: 0}, 0.4, {
                                ease: FlxEase.quadOut,
                                onComplete: function(twn:FlxTween) {
                                    spr.kill();
                                }
                            });
                        } else {
                            FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker) {
                                var daChoice:String = optionShit[curSelected];

                                switch(daChoice) {
                                    case 'credits':
                                        MusicBeatState.switchState(new CreditsState());
                                }
                            });
                        }
                    });
                }
            }
        }

        super.update(elapsed);

        menuItems.forEach(function(spr:FlxSprite) {
            spr.screenCenter(X);
        });
    }

    private function changeItem(huh:Int = 0) {
        curSelected += huh;

        if (curSelected >= menuItems.length)
            curSelected = 0;
        if (curSelected < 0)
            curSelected = menuItems.length - 1;

        menuItems.forEach(function(spr:FlxSprite) {
            spr.animation.play('idle');
            spr.updateHitbox();

            if (spr.ID == curSelected) {
                spr.animation.play('selected');
                var add:Float = 0;
                if (menuItems.length > 4) {
                    add = menuItems.length * 8;
                }
                camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y - add);
                spr.centerOffsets();
                //trace('changed camera position: ' + camFollow.x + ', ' + camFollow.y);
            }
        });
    }
}