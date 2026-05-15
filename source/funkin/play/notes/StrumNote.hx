package funkin.game;

class StrumNote extends FlxSprite {
    public var player:Int = 0;
    private var noteData:Int = 0;

    public function new(x:Float, y:Float, noteData:Int, player:Int = 0) {
        super(x, y);

        this.noteData = noteData;
        this.player = player;
        ID = noteData;

        if (PlayState.curStage.startsWith('school')) {
            loadGraphic(Paths.image('pixelUI/arrows-pixels'), true, 17, 17);
            animation.add('green', [6]);
            animation.add('red', [7]);
            animation.add('blue', [5]);
            animation.add('purplel', [4]);

            setGraphicSize(Std.int(width * PlayState.daPixelZoom));
            updateHitbox();
            antialiasing = false;

            switch(noteData) {
                case 0:
                    animation.add('static', [0]);
                    animation.add('pressed', [4, 8], 12, false);
                    animation.add('confirm', [12, 16], 24, false);

                case 1:
                    animation.add('static', [1]);
                    animation.add('pressed', [5, 9], 12, false);
                    animation.add('confirm', [13, 17], 24, false);

                case 2:
                    animation.add('static', [2]);
                    animation.add('pressed', [6, 10], 12, false);
                    animation.add('confirm', [14, 18], 24, false);

                case 3:
                    animation.add('static', [3]);
                    animation.add('pressed', [7, 11], 12, false);
                    animation.add('confirm', [15, 19], 24, false);
            }
        } else {
            frames = Paths.getSparrowAtlas('game/notes/default');
            animation.addByPrefix('green', 'arrowUP');
            animation.addByPrefix('blue', 'arrowDOWN');
            animation.addByPrefix('purple', 'arrowLEFT');
            animation.addByPrefix('red', 'arrowRIGHT');

            setGraphicSize(Std.int(width * 0.7));
            antialiasing = true;

            switch(noteData) {
                case 0:
                    animation.addByPrefix('static', 'arrowLEFT');
                    animation.addByPrefix('pressed', 'left press', 24, false);
                    animation.addByPrefix('confirm', 'left confirm', 24, false);

                case 1:
                    animation.addByPrefix('static', 'arrowDOWN');
                    animation.addByPrefix('pressed', 'down press', 24, false);
                    animation.addByPrefix('confirm', 'down confirm', 24, false);

                case 2:
                    animation.addByPrefix('static', 'arrowUP');
                    animation.addByPrefix('pressed', 'up press', 24, false);
                    animation.addByPrefix('confirm', 'up confirm', 24, false);

                case 3:
                    animation.addByPrefix('static', 'arrowRIGHT');
                    animation.addByPrefix('pressed', 'right press', 24, false);
                    animation.addByPrefix('confirm', 'right confirm', 24, false);
            }
        }

        updateHitbox();
        scrollFactor.set();

        if (!PlayState.isStoryMode) {
            y -= 10;
            alpha = 0;
            FlxTween.tween(this, {y: this.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * noteData)});
        }

        animation.play('static');
        x += 50;
        x += ((FlxG.width / 2) * player);
    }

    public function press() {
        animation.play('pressed', true);
    }

    public function confirm() {
        animation.play('confirm', true);
    }

    public function resetAnim() {
        animation.play('static');
    }
}