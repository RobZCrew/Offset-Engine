package funkin.states;

import sys.FileSystem;
import sys.io.File;
import flixel.ui.FlxBar;
import flixel.addons.effects.FlxTrail;
import funkin.objects.game.*;
import funkin.objects.game.stage.StageBuilder;
import funkin.objects.game.cutscene.CutsceneHandler;
import funkin.objects.game.cutscene.dialogue.DialogueBox;
import funkin.objects.songs.Song;
import funkin.objects.notes.*;
import funkin.utils.Highscore;
import funkin.system.interfaces.IBeatReceiver;

#if MODS_ALLOWED
import funkin.objects.script.HScript;
#end

// Early PlayState
// TODO: Remove placeholders when the state is finished
class PlayState extends MusicBeatState {
    // PlayState Instance
    public static var instance:PlayState;

    // Song Info
    public static var SONG:SongData;
    public static var song(get, set):SongData;

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
    public var comboGroup:ComboGroup;

    #if MODS_ALLOWED
    public var scripts:Array<HScript> = [];
    #end

    // Note Stuff
    public var notes:FlxTypedGroup<Note>;
    public var unspawnNotes:Array<Note> = [];

    public var grpNoteSplashes:SplashGroup;

    public static var singAnimations:Array<String> = ['singLEFT', 'singDOWN', 'singUP', 'singLEFT'];

    // Strumlines (not the note one)
    public var strumLines:FlxTypedGroup<StrumLine>;

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

    // Beat receivers
    public var beatReceivers:Array<IBeatReceiver> = [];

    // Internal
    /// nothing lol

    inline function get_song():SongData
        return SONG;
    inline function set_song(value:SongData):SongData
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
        return PlayList.isStoryMode;
    inline function set_isStoryMode(value:Bool):Bool
        return PlayList.isStoryMode = value;

    function set_playbackRate(value:Float):Float {
        if (!generatedMusic)
            return playbackRate;

        playbackRate = value;

        inst.pitch = playbackRate;
        songSpeed *= playbackRate;

        for (strum in strumLines.members) {
            if (strum != null)
                strum.vocals.pitch = playbackRate;
        }

        return playbackRate;
    }

    override function create() {
        instance = this;

        super.create();

        // Configure song and some variables
        if (SONG == null)
            SONG = Song.loadFromJson('tutorial');

        Conductor.mapBPMChanges(SONG);
        Conductor.changeBPM(SONG.meta.bpm);

        curStage = SONG.stage;
        songName = SONG.song;
        songLower = songName.toLowerCase();

        // Start building
        // TODO: Maybe make a separated class for this part?
        buildCameras();
        buildGameplay();
        buildStrumLines();
        buildCameraFollow();
        buildUI();

        // Generate song
        generateSong(SONG.song);

        // Start scripts
        for (globalPath in FileSystem.readDirectory(Mods.getPath('scripts'))) {
            var globalScript = new HScript(null, globalPath, {game: this});
            scripts.push(globalScript);
        }

        for (path in FileSystem.readDirectory(Mods.getPath('data/${Highscore.formatSong(songName)}/scripts'))) {
            var script = new HScript(null, path, {game: this});
            scripts.push(script);
        }

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

    override function beatHit(curBeat:Int) {
        super.beatHit(curBeat);

        for (receiver in beatReceivers)
            receiver.beatHit(curBeat);
    }

    // Builders
    private function buildCameras() {
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
    }

    private function buildGameplay() {
        stage = new StageBuilder();
        stage.buildStage(curStage);
        stage.addLayersToState(this);

        comboGroup = new ComboGroup(camHUD);
        add(comboGroup);
    }

    private function buildStrumLines() {
        strumLines = new FlxTypedGroup<StrumLine>();
        add(strumLines);
        for (i=>strum in SONG.strumLines) {
            var strumLine:StrumLine = new StrumLine(50, 50, strum.type);
            strumLines.add(strumLine);

            if (strum.vocalsSuffix != '') {
                var strumVocals:FlxSound = new FlxSound().loadEmbedded(Paths.voices(SONG.meta.song, strum.vocalsSuffix));
                strumVocals.presist = false;
                strumLine.vocals = strumVocals;
            }

            for (charName in strum.characters) {
                var character:Character = new Character(0, 0, charName);
                beatReceivers.push(character);
                add(character);

                if (strumLines.members[i] != null)
                    strumLines.members[i].characters.push(character);

                var charPos:Array<Float> = switch(strum.position) {
                    case DAD: stage.dadPosition;
                    case BF: stage.bfPosition;
                    case GF: stage.gfPosition;
                }

                character.setPosition(charPos[0] + character.positionOffsets[0], charPos[1] + character.positionOffsets[1]);
            }
        }
    }

    private function buildCameraFollow() {
        var camPos:Array<Float> = strumLineCharacters[0][0].getCameraPosition();

        camFollow = new FlxObject(0, 0, 1, 1);
        camFollowPoint = new FlxPoint();

        setCameraPosition(camPos[0], camPos[1], true);

        if (_prevCamFollow != null) {
            camFollow = _prevCamFollow;
            _prevCamFollow = null;
        }

        if (_prevCamFollowPoint != null) {
            camFollowPoint = _prevCamFollowPoint;
            _prevCamFollowPoint = null;
        }

        add(camFollow);

        FlxG.camera.follow(camFollow, LOCKON, 0.04);
        FlxG.camera.zoom = defaultZoom;
        FlxG.camera.focusOn(camFollowPoint);

        FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);
        FlxG.fixedTimestep = false;
    }

    private function buildUI() {
        healthBarBG = new FlxSprite(0, (downscroll ? (FlxG.height * 0.11 : FlxG.height * 0.9)
        healthBarBG.screenCenter(X);
        healthBarBG.scrollFactor.set();
        healthBarBG.cameras = [camHUD];
        add(healthBarBG);

        healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this, 'health', 0, 2);
        healthBar.scrollFactor.set();
        healthBar.createFilledBar(0xFFFF0000, 0xFF66FF33);
        healthBar.cameras = [camHUD];
        add(healthBar);

        iconP1 = new HealthIcon(strumLines.members[0].characters[0].healthicon, true);
        iconP1.cameras = [camHUD];
        add(iconP1);

        iconP2 = new HealthIcon(strumLines.members[1].characters[0].healthicon);
        iconP2.cameras = [camHUD];
        add(iconP2);

        scoreTxt = new FlxText(155, (downscroll ? 105 : 670), FlxG.width, 'Score: 0', 17);
        scoreTxt.setFormat(Paths.font('vcr.ttf'), 17, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        scoreTxt.scrollFactor.set();
        scoreTxt.borderSize = 0.7;
        scoreTxt.cameras = [camHUD];
        add(scoreTxt);
    }

    // Helpers
    private function generateSong(dataPath:String):Void {
        var songData = SONG;
        Conductor.changeBPM(songData.meta.bpm);

        vocals = new FlxSound().loadEmbedded(Paths.voices(SONG.meta.song));

        for (i=>strum in songData.strumLines) {
            if (strumLines.members[i] != null && strumLines.members[i].vocals != null)
                FlxG.sound.list.add(strumLines.members[i].vocals);

            for (note in strum.notes) {
                var daStrumTime:Float = note.t;
                var daNoteData:Int = note.l;
                var gottaHitNote:Bool = strum.type == PLAYER;
            }
        }
    }

    /// Hscript Helpers
    public function startCutscene(video:FunkinVideo) {
        if (video == null) return;

        swagCutscene = new CutsceneHandler(this, video);
        add(swagCutscene);

        onCutscene = true;
        seenCutscene = false;
    }
}