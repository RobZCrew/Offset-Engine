package funkin.play;

import sys.FileSystem;
import sys.io.File;
import flixel.ui.FlxBar;
import flixel.addons.effects.FlxTrail;
import funkin.play.song.Song;
import funkin.data.song.SongData:
import funkin.play.character.BaseCharacter;
import funkin.data.character.CharacterData;
import funkin.play.components.HealthIcon;
import funkin.play.components.HudCamera;
import funkin.play.components.ComboHandler;
import funkin.play.cutscene.dialogue.DialogueBox;
import funkin.play.cutscene.CutsceneHandler;
import funkin.play.notes.Note;
import funkin.play.notes.SplashHandler;
import funkin.play.notes.StrumLine;
import funkin.play.stage.StageBuilder;

// Early PlayState
// TODO: Remove placeholders when the state is finished
class PlayState extends MusicBeatState {
    // PlayState Instance
    public static var instance:PlayState;

    // Song Info
    public static var SONG:SwagSong;
    public static var song(get, set):SwagSong;

    // Song
    public var inst(get, set):FlxSound;
    public var vocals:FlxSound;

    public var songSpeed:Float;
    public var playbackRate(default, set):Float = 1;
    public var songLength:Float;

    public static var curStage:String;
    public var songName:String;
    public var songLower:String;

    // Gameplay
    /// Is Story Mode?
    public static var isStoryMode(get, set):Bool;

    /// Botplay / Practice Mode
    public var botplayMode:Bool = false;
    public var cpuControlled(get, set):Bool;
    public var practiceMode:Bool = false;

    /// Score Info
    public var songScore:Int = 0;
    public var combo:Int = 0;

    /// Gameplay Info
    public var health(default, set):Float = 1;
    public var defaultZoom(get, set):Float;
    public var downscroll(get, never):Bool;
    public var canPause:Bool = true;
    public var paused:Bool = false;
    public var generatedMusic:Bool = false;
    public var startedCountdown:Bool = false;

    /// Misc
    public var stage:StageBuilder;
    public var playlist:PlayList;
    public var comboGroup:ComboHandler;

    // Note / Strums Stuff
    public var notes:FlxTypedGroup<Note>;
    public var unspawnNotes:Array<Note> = [];

    public var grpNoteSplashes:SplashGroup;

    public var opponentStrums:StrumLine;
    public var playerStrums:StrumLine;
    public var strumLineNotes:StrumLine;

    public static var singAnimations:Array<String> = ['singLEFT', 'singDOWN', 'singUP', 'singLEFT'];

    // Characters
    public var boyfriend:Character;
    public var gf:Character;
    public var dad:Character;

    // Cameras
    public var camGame:FlxCamera;
    public var camUI:FlxCamera;
    public var camHUD:HudCamera;
    public var camOther:FlxCamera;

    // Camera Follow Stuff
    public static var camFollow:FlxObject;
    public static var camFollowPoint:FlxPoint;

    private var _prevCamFollow:FlxObject;
    private var _prevCamFollowPoint:FlxPoint;

    // UI
    public var healthBar:FlxBar;
    public var healthBarBG:FlxSprite;
    public var iconP1:HealthIcon;
    public var iconP2:HealthIcon;
    public var scoreTxt:FlxText;

    // Cutscene / Dialogue
    public var swagDialogue:DialogueBox;
    public var swagCutscene:CutsceneHandler;
    public var seenCutscene:Bool = true;
    public var onCutscene(default, null):Bool = false;

    // Internal
    /// nothing lol

    inline function get_song():SwagSong
        return SONG;
    inline function set_song(value:SwagSong):SwagSong
        return SONG = value;

    inline function get_inst():FlxSound
        return FlxG.sound.music;
    inline function set_inst(value:FlxSound):FlxSound
        return FlxG.sound.music = value;

    inline function get_cpuControlled():Bool
        return botplayMode;
    inline function set_cpuControlled(value:Bool):Bool
        return botplayMode = value;

    inline function set_health(value:Float):Float
        return health = FlxMath.bound(value, 0, 2);

    inline function get_defaultZoom():Float
        return stage.defaultZoom;
    inline function set_defaultZoom(value:Float):Float
        return stage.defaultZoom = value;

    inline function get_downscroll():Bool
        return camHUD._downscroll;

    inline function get_isStoryMode():Bool
        return playlist.isStoryMode;
    inline function set_isStoryMode(value:Bool):Bool
        return playlist.isStoryMode = value;

    function set_playbackRate(value:Float):Float {
        if (!_generatedMusic)
            return playbackRate;

        playbackRate = value;

        inst.pitch = playbackRate;
        vocals.pitch = playbackRate;
        songSpeed *= playbackRate;

        return playbackRate;
    }

    override function create() {
        instance = this;

        super.create();

        // Configure song and some variables
        if (SONG == null)
            SONG = Song.loadFromJson('tutorial');

        Conductor.mapBPMChanges(SONG);
        Conductor.changeBPM(SONG.bpm);

        curStage = SONG.stage;
        songName = SONG.name;
        songLower = songName.toLowerCase();

        FlxG.sound.playMusic(Paths.inst(songName), true);
        vocals = new FlxSound().loadEmbedded(Paths.voices(songName));
        FlxG.sound.list.add(vocals);

        // Start building
        buildCameras(false);
        buildGameplay();
        buildCharacters();
        buildCameras(true);
        buildUI();

        trace('Early PlayState');

        // i hate Null Object Reference
        /*new FlxTimer().start(0.25, () -> {
            if (isStoryMode)
                MusicBeatState.switchState(new funkin.ui.story.StoryMenuState());
            else
                MusicBeatState.switchState(new funkin.ui.freeplay.FreeplayState());
        });*/
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (FlxG.mouse.justPressed.ESCAPE && canPause) {
            PauseSubState._onCutscene = false; // just in case
            paused = true;
            openSubState(new PauseSubState());
        }
    }

    // Builders
    private function buildCameras(camFollow:Bool = false) {
        if (!camFollow) {
            camGame = new FlxCamera();
            camUI = new FlxCamera();
            camHUD = new HudCamera(Options.downscroll);
            camOther = new FlxCamera();

            camUI.bgColor.alpha = 0;
            camHUD.bgColor.alpha = 0;
            camOther.bgColor.alpha = 0;

            FlxG.cameras.reset(camGame);
            FlxG.cameras.add(camUI, false);
            FlxG.cameras.add(camHUD, false);
            FlxG.cameras.add(camOther, false);

            FlxG.cameras.setDefaultDrawTarget(camGame, true);
        } else {
            camFollow = new FlxObject(0, 0, 1, 1);
            camFollowPoint = new FlxPoint();

            setCameraPosition(100, 100, true) // placeholder

            if (_prevCamFollow != null) {
                camFollow = _prevCamFollow;
                _prevCamFollow = null;
            }

            if (_prevCamFollowPoint != null) {
                camFollowPoint = _prevCamFollowPoint;
                _prevCamFollowPoint = null;
            }

            add(camFollow);
        }
    }

    private function buildGameplay() {
        stage = new StageBuilder();
        stage.buildStage(curStage);
        stage.addLayersToState(this);

        comboGroup = new ComboHandler(camHUD);
        add(comboGroup);
    }

    private function buildCharacters() {
        gf = new Character(stage.gfPosition[0], stage.gfPosition[1], SONG.gfVersion ?? SONG.gfPlayer);
        gf.scrollFactor.set(0.95, 0.95);
        add(gf);

        dad = new Character(stage.dadPosition[0], stage.dadPosition[1], SONG.player2);
        add(dad);

        boyfriend = new Character(stage.bfPosition[0], stage.bfPosition[1], SONG.player1, true);
        add(boyfriend);

        gf.x += gf.positionOffsets[0];
        gf.y += gf.positionOffsets[1];
        dad.x += dad.positionOffsets[0];
        dad.y += dad.positionOffsets[1];
        boyfriend.x += boyfriend.positionOffsets[0];
        boyfriend.y += boyfriend.positionOffsets[1];
   }

    private function buildUI() {
        healthBarBG = new FlxSprite(0, (downscroll ? (FlxG.height * 0.11 : FlxG.height * 0.9)
        healthBarBG.screenCenter(X);
        healthBarBG.scrollFactor.set();
        add(healthBarBG);

        healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this, 'health', 0, 2);
        healthBar.scrollFactor.set();
        healthBar.createFilledBar(0xFFFF0000, 0xFF66FF33);
        add(healthBar);

        iconP1 = new HealthIcon(boyfriend.healthicon, true);
        add(iconP1);

        iconP2 = new HealthIcon(dad.healthicon);
        add(iconP2);
    }

    // Helpers
    /// Hscript Helpers
    public function startCutscene(video:FunkinVideo) {
        swagCutscene = new CutsceneHandler(this, video);
        add(swagCutscene);

        if (video == null) return;

        onCutscene = true;
        seenCutscene = false;
    }
}