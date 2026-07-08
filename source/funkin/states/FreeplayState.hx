package funkin.states;

import funkin.utils.Highscore;
import funkin.objects.songs.Song;
import funkin.objects.game.HealthIcon;

#if MODS_ALLOWED
import funkin.utils.Mods;
#end

class FreeplayState extends ScriptableState {
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

    override function create() {
        var initSongList = CoolUtil.coolTextFile(Paths.getPath('data/freeplaySonglist.txt', TEXT, null, true)); // this is better than allow mods to break the freeplay song list lol

        for (i in 0...initSongList.length) {
            songs.push(new SongMetadata(initSongList[i], 1, 'gf'));
        }

        var isDebug = false;

        #if debug
        isDebug = true;
        #end

        if (StoryMenuState.weekUnlocked[1] || isDebug) {
            addWeek(['Bopeebo', 'Fresh', 'Dadbattle'], 1, ['dad']);
        }

        if (StoryMenuState.weekUnlocked[2] || isDebug) {
            addWeek(['Spookeez', 'South', 'Monster'], 2, ['spooky', 'spooky', 'monster']);
        }

        if (StoryMenuState.weekUnlocked[3] || isDebug) {
            addWeek(['Philly', 'Philly-Nice', 'Blammed'], 3, ['pico']);
        }

        if (StoryMenuState.weekUnlocked[4] || isDebug) {
            addWeek(['Satin-Panties', 'High', 'Milf'], 4, ['mom']);
        }

        if (StoryMenuState.weekUnlocked[5] || isDebug) {
            addWeek(['Cocoa', 'Eggnog'], 5, ['parents-christmas']);
        }

        if (StoryMenuState.weekUnlocked[6] || isDebug) {
            addWeek(['Senpai', 'Roses', 'Thorns'], 6, ['senpai-pixel', 'senpai-pixel', 'spirit-pixel']);
        }

        #if MODS_ALLOWED
        var modSongList = Mods.getSongList();
        for (song in modSongList.songs) {
            addSong(song[0], 7, song[1]);
        }
        #end

        var bg:FlxSprite = new FlxSprite().loadGraphic('menus/menuBGBlue');
        add(bg);

        for (i in 0...songs.length) {
            var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false);
            songText.isMenuItem = true;
            songText.targetY = i;
            grpSongs.add(songText);

            var icon:HealthIcon = new HealthIcon(songs[i].songIcon);
            icon.sprTracker = songText;
            iconArray.push(icon);
            add(icon);
        }
    }

    function addSong(song:String, week:Int, ?songIcon:String = 'face') {
        songs.push(new SongMetadata(song, week, songIcon));
    }

    function addWeek(songs:Array<String>, week:Int, ?songIcons:Array<String>) {
        if (songIcons == null)
            songIcons = ['face'];

        var num:Int = 0;
        for (song in songs) {
            addSong(song, weekName, songIcons[num]);

            if (songIcons.length != 1)
                num++;
        }
    }
}

class SongMetadata {
    public var songName:String = '';
    public var week:Int = 0;
    public var songIcon:String = '';

    public function new(song:String, week:Int, songIcon:String) {
        this.songName = song;
        this.week = week;
        this.songIcon = songIcon;
    }
}