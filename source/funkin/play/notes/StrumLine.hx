package funkin.game;

class StrumLine extends FlxTypedGroup<StrumNote> {
    public var player(default, set):Int = 0;
    public var downscroll:Bool = false;
    public var baseX:Float = 50;
    public var baseY:Float = 50;

    inline function set_player(value:Int):Int
        return player = FlxMath.bound(value, 0, 1);

    public function new(x:Float = 50, y:Float = 50, player:Int = 0, ?skin:String = 'default') {
        super();
        downscroll = PlayState.downscroll;
        baseX = x;
        baseY = y;
        this.player = player;
    }

    public function generateStrums(strumLineNotes:StrumLine = null) {
        for (i in 0...4) {
             var note = new StrumNote(baseX + Note.swagWidth * i, baseY, i, player);
             add(note);

             if (strumLineNotes != null)
                 strumLineNotes.add(note);
        }

        if (player != 1) {
            forEach(function(note:StrumNote) {
                note.centerOffsets();
            });
        }
    }

    public function refresh() {
        forEach(function(note:StrumNote) {
            note.destroy();
        });

        clear();
        generateStrums();
    }
}