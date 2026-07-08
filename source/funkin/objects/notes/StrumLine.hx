package funkin.objects.notes;

import funkin.objects.game.Character;
import funkin.objects.songs.Song.StrumLineType;

class StrumLine extends FlxTypedGroup<Strum> {
    public var type(default, null):StrumLineType = ADDITIONAL;
    public var downscroll(default, null):Bool = false;
    public var baseX:Float = 50;
    public var baseY:Float = 50;

    public var notes:FlxTypesGroup<Note>;
    public var unspawnNotes:Array<Note> = [];
    public var characters:Array<Character> = [];

    // This is configured in PlayState btw
    public var vocals:FlxSound;

    public function new(x:Float = 50, y:Float = 50, type:StrumLineType = ADDITIONAL) {
        super();
        this.downscroll = PlayState.downscroll ?? false;
        this baseX = x;
        this.baseY = y;
        this.type = type;
        this.notes = new FlxTypedGroup<Note>();
    }

    public function generateStrums() {
        for (i in 0...4) {
             var strum = new Strum(baseX + Note.swagWidth * i, baseY, i, player);
             add(strum);
        }

        if (type != PLAYER) {
            forEach(function(strum:StrumNote) {
                strum.centerOffsets();
            });
        }
    }

    public function refresh() {
        forEach(function(strum:StrumNote) {
            strum.destroy();
        });

        clear();
        generateStrums();
    }
}