package funkin.states;

import flixel.input.gamepad.FlxGamepad;

class TitleState extends MusicBeatState {
    public static var initialized:Bool = false;

    public var ngSpr:FlxSprite;
    public var logoBl:FlxSprite;
    public var gfDance:FlxSprite;
    public var titleText:FlxSprite;
    public var textGroup:FlxGroup;

    public var danceLeft:Bool = false;
    public var curWacky:Array<String> = [];
    public var skippedIntro:Bool = false;
    public var transitioning:Bool = false;

    override public function create():Void {
        curWacky = FlxG.random.getObject(getIntroTextShit());

        super.create();

        // debug stuff
        /*var text = new FlxText(0, 0, 1280, "Offset Engine");
        text.setFormat(null, 64, 0xFFF70035, "center");
        text.screenCenter();
        add(text);*/

        new FlxTimer().start(1, function(_:FlxTimer) {
            startIntro();
        });
    }

    private function getIntroTextShit():Array<Array<String>> {
        var fullText:String = Paths.getText(Paths.txt('introText'));

        var firstArray:Array<String> = fullText.split('\n');
        var swagGoodArray:Array<Array<String>> = [];

        for (i in firstArray) {
            swagGoodArray.push(i.split('--'));
        }

        return swagGoodArray;
    }

    private function startIntro():Void {
        Conductor.changeBPM(102);
        persistentUpdate = true;

        if (!initialized) {
            FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
            FlxG.sound.music.fadeIn(4, 0, 0.7);
            initialized = true;
        } else
            skipIntro();

        var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0x000000);
        add(bg);

        ngSpr = new FlxSprite(0, FlxG.height * 0.52).loadGraphic(Paths.image('menus/newgrounds_logo'));
        ngSpr.screenCenter(X);
        ngSpr.setGraphicSize(Std.int(ngSpr.width * 0.8));
        ngSpr.updateHitbox();
        ngSpr.antialiasing = true;
        ngSpr.visible = false;
        add(ngSpr);

        logoBl = new FlxSprite(-150, -100);
        logoBl.frames = Paths.getSparrowAtlas('menus/logoBumpin');
        logoBl.animation.addByIndices('bump', 'logo bumpin', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], '', 24, false);
        logoBl.animation.play('bump');
        logoBl.antialiasing = true;
        logoBl.updateHitbox();
        logoBl.visible = false;
        add(logoBl);

        gfDance = new FlxSprite(FlxG.width * 0.4, FlxG.height * 0.07);
        gfDance.frames = Paths.getSparrowAtlas('menus/gfDanceTitle');
        gfDance.animation.addByIndices('danceLeft', 'gfDance', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], '', 24, false);
        gfDance.animation.addByIndices('danceRight', 'gfDance', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], '', 24, false);
        gfDance.antialiasing = true;
        gfDance.visible = false;
        add(gfDance);

        titleText = new FlxSprite(100, FlxG.height * 0.8);
        titleText.frames = Paths.getSparrowAtlas('menus/titleEnter');
        titleText.animation.addByPrefix('idle', 'Press Enter to Begin', 24);
        titleText.animation.addByPrefix('press', 'ENTER PRESSED', 24);
        titleText.animation.play('idle');
        titleText.antialiasing = true;
        titleText.updateHitbox();
        titleText.visible = false;
        add(titleText);

        textGroup = new FlxGroup();
        add(textGroup);

        trace('hi');
    }

    private function skipIntro():Void {
        if (skippedIntro) return;

        if (ngSpr != null)
            remove(ngSpr);

        FlxG.camera.flash(FlxColor.WHITE, 4);

        if (textGroup != null)
            textGroup.visible = false;

        logoBl.visible = true;
        gfDance.visible = true;
        titleText.visible = true;

        skippedIntro = true;
    }

    override public function update(elapsed:Float):Void {
        if (FlxG.sound.music != null)
            Conductor.songPosition = FlxG.sound.music.time;

        var pressedEnter:Bool = FlxG.keys.justPressed.ENTER;

        var gamepad:FlxGamepad = FlxG.gamepads.lastActive;
        if (gamepad != null) {
            if (gamepad.justPressed.START)
                pressedEnter = true;
        }

        if (pressedEnter && !transitioning && skippedIntro) {
            titleText.animation.play('press', true);

            FlxG.camera.flash(FlxColor.WHITE, 1);
            FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

            transitioning = true;

            new FlxTimer().start(1, function(_:FlxTimer) {
                FlxG.switchState(new funkin.states.editors.TestEditorState());
                trace('switching to editor state');
            });
        }

        if (pressedEnter && !skippedIntro)
            skipIntro();

        super.update(elapsed);
    }

    override public function beatHit(curBeat:Int) {
        super.beatHit(curBeat);

        if (skippedIntro) {
            logoBl.animation.play('bump');

            danceLeft = !danceLeft;

            if (danceLeft)
                gfDance.animation.play('danceLeft');
            else
                gfDance.animation.play('danceRight');
        }

        FlxG.log.add(curBeat);

        switch(curBeat) {
            case 1:
                createCoolText(['The', 'Offset Engine Team']);

            case 3:
                addMoreText('Presents');

            case 4:
                deleteCoolText();

            case 5:
                createCoolText(['Not Associated', 'with']);

            case 6:
                addMoreText('newgrounds');
                ngSpr.visible = true;

            case 7:
                deleteCoolText();
                ngSpr.visible = false;

            case 8:
                createCoolText([curWacky[0]]);

            case 9:
                addMoreText(curWacky[1]);

            case 12:
                deleteCoolText();

            case 13:
                addMoreText('Friday');

            case 14:
                addMoreText('Night');

            case 15:
                addMoreText('Funkin');

            case 16:
                skipIntro();
        }
    }

    private function createCoolText(textArray:Array<String>) {
        for (i in 0...textArray.length) {
            var money:Alphabet = new Alphabet(0, 0, textArray[i], true, false);
            money.screenCenter(X);
            money.y += (i * 60) + 200;
            textGroup.add(money);
        }
    }

    private function addMoreText(text:String) {
        var coolText:Alphabet = new Alphabet(0, 0, text, true, false);
        coolText.screenCenter(X);
        coolText.y += (textGroup.length * 60) + 200;
        textGroup.add(coolText);
    }

    private function deleteCoolText() {
        textGroup.clear();
    }
}