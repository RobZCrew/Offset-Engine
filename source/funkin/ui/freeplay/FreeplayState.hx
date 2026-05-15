package funkin.ui.freeplay;

import funkin.Highscore;
import funkin.play.song.Song;

#if MODS_ALLOWED
import funkin.modding.Mods;
#end

class FreeplayState extends MusicBeatState {
    public var songs:Array<SongMetadata> = [];

    public var selector:FlxText;
    public var curSelected:Int = 0;
    public var curDifficulty:Int = 1;

    public var scoreText:FlxText;
    public var diffText:FlxText;
    public var lerpScore:Int = 0;
    public var intendedScore:Int = 0;

    private var grpSongs:FlxTypedGroup<Alphabet>;
    private var iconArray:Array<HealthIcon> = [];
    private var curPlaying:Bool = false;
}

class SongMetadata {
}