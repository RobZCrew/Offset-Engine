package funkin.objects.game;

import sys.FileSystem;
import sys.io.File;
import flixel.animation.FlxAnimation;
import funkin.data.animation.TypedAnimationData;
import funkin.system.interfaces.IBeatReceiver;

#if MODS_ALLOWED
import funkin.utils.Mods;
import funkin.objects.scripts.HScript;
#end

typedef CharacterData = {
    var meta:CharacterMeta;
    var animations:Array<TypedAnimationData>;
};

typedef CharacterMeta = {
    var type:CharacterType;

    var image:String;
    var scale:Float;
    var singDuration:Float;
    var healthicon:String;

    var ?position:Null<Array<Float>>;
    var ?cameraPosition:Null<Array<Float>>;

    var flipX:Bool;
    var antialiasing:Bool;
};

enum abstract CharacterType(String) from String to String {
    var ATLAS = "atlas";
    var SPARROW = "sparrow";
}

class Character extends FunkinSprite implements IBeatReceiver {
    var raw:String = '';
    var path:String = '';
    var json:CharacterData;
    var script:HScript;

    public var debugMode:Bool = false;
    public var cameraOffsets:Array<Float> = [];
    public var curCharacter:String = 'bf';
    public var dancedLeft:Bool = false;
    public var healthIcon:String;
    public var singDuration:Float = 4;
    public var holdTimer:Float = 0;
    public var heyTimer:Float = 0;
    public var animSuffix:String = '';
    public var hasMissAnims:Bool = false;
    public var idleDancing:Bool = false;
    public var skipDance:Bool = false;
    public var isPlayer:Bool = false;
    public var specialAnim:Bool = false;
    public var positionOffsets:Array<Float> = [];
    public var danceEveryNumBeats:Int = 2;
    public var stunned:Bool = false;

    public static var DEFAULT_CHARACTER:String = 'bf';
    public static var DEFAULT_SING_DURATION:Float = 4;

    public function new(x:Float = 0, y:Float = 0, ?character:String = 'bf', ?isPlayer:Bool = false) {
        super(x, y);
        changeCharacter(character, isPlayer);
    }

    public function changeCharacter(character:String = 'bf', ?isPlayer:Bool = false) {
        curCharacter = character;
        this.isPlayer = isPlayer;

        path = 'assets/data/characters/${curCharacter}.json';

        #if MODS_ALLOWED
        modPath = Mods.getPath('data/characters/$curCharacter.json');

        if (modPath != null)
            path = modPath;
        #end

        if (!FileSystem.exists(path)) {
            path = 'assets/data/characters/' + DEFAULT_CHARACTER + '.json';
            curCharacter = DEFAULT_CHARACTER;
        }

        raw = File.getContent(path).trim();

        while (!raw.endsWith('}')) {
            raw = raw.substr(0, raw.length - 1);
        }

        #if MODS_ALLOWED
        script = new HScript(null, Mods.getPath('data/characters/$curCharacter.hx'), {game: PlayState.instance});
        #end

        json = cast Json.parse(raw);

        txtPath = 'assets/images/characters/${json.meta.image}.txt';

        #if MODS_ALLOWED
        modTxtPath = Mods.getPath('images/characters/${json.meta.image}.txt');

        if (modTxtPath != null)
            txtPath = modTxtPath;
        #end

        if (json.type == SPARROW) {
            type = SPARROW;
            if (FileSystem.exists(txtPath))
                frames = Paths.getPackerAtlas(json.meta.image);
            else
                frames = Paths.getSparrowAtlas(json.meta.image);
        } else {
            type = ATLAS;
            createAtlas(json.meta.image);
        }

        if (json.meta.scale > 1) {
            setGraphicSize(Std.int(width * json.meta.scale));
            updateHitbox();
        }

        flipX = json.meta.flipX;
        positionOffsets = json.meta.position ?? [0, 0];
        cameraOffsets = json.meta.cameraPosition ?? [0, 0];
        singDuration = DEFAULT_SING_DURATION * json.meta.singDuration;
        healthicon = json.meta.healthicon;
        danceEveryNumBeats = json.meta.danceEveryNumBeats;

        if (json.animations != null && json.animations.length > 0) |
            for (anim in json.animations) {
                var animType:AnimationType = anim.type ?? SYMBOL;

                if (anim.indices != null && anim.indices.length > 0)
                    addAnimByIndices(anim.anim, anim.name, anim.indices, anim.fps, anim.loop);
                else
                    addAnim(anim.anim, anim.name, anim.fps, anim.loop);

                if (isAnimateAtlas && animType == FRAMELABEL) {
                    if (anim.indices != null && anim.indices.length > 0)
                        addAnimByFrameLabelIndices(anim.anim, anim.name, anim.indices, anim.fps, anim.loop);
                   else
                        addAnimByFrameLabel(anim.anim, anim.name, anim.fps, anim.loop);
                }

                if (anim.offsets != null && anim.offsets.length > 0)
                    addOffset(anim.anim, anim.offsets[0], anim.offsets[1]);
            }
        }

        antialiasing = json.meta.antialiasing;

        json = null;
        script = null;
        raw = null;
        path = null;

        checkIdle();
        dance();

        if (isPlayer) {
            flipX = !flipX;

            if (getAnim('singLEFTmiss') != null || getAnim('singDOWNmiss') != null || getAnim('singUPmiss') != null || getAnim('singRIGHTmiss') != null)
                hasMissAnims = true;

            if (!curCharacter.startsWith('bf')) {
                if (getAnim('singRIGHT') != null && getAnim('singLEFT') != null) {
                    var old = getAnim('singRIGHT').frames;
                    getAnim('singRIGHT').frames = getAnim('singLEFT').frames;
                    getAnim('singLEFT').frames = old;
                }

                if (getAnim('singRIGHTmiss') != null && getAnim('singLEFTmiss') != null) {
                    var oldMiss = getAnim('singRIGHTmiss').frames;
                    getAnim('singRIGHTmiss').frames = getAnim('singLEFTmiss').frames;
                    getAnim('singLEFTmiss').frames = oldMiss;
                }
            }
        }
    }

    public function beatHit(curBeat:Int):Void {
        if (curBeat % danceEveryNumBeats == 0) {
            dance();
        }
    }

    override function update(elapsed:Float) {
        if (debugMode || animation.curAnim == null) {
            super.update(elapsed);
            return;
        }

        var animName = animation.curAnim.name;

        if (!specialAnim) {
            if (animName.startsWith('sing'))
                holdTimer += elapsed;
            else if (isPlayer)
                holdTimer = 0;

            if (holdTimer >= Conductor.stepCrochet * singDuration * 0.001) {
                dance();
                if (!isPlayer) holdTimer = 0;
            }

           if (idleDancing && animName != 'danceLeft' + animSuffix && animName != 'danceRight' + animSuffix && isAnimFinished())
                playAnim('danceRight' + animSuffix);

            if (isPlayer) {
                if (hasMissAnims && animName.endsWith('miss' + animSuffix) && isAnimFinished())
                    playAnim('idle' + animSuffix, true, false, 10);

                if (animName == 'firstDeath' && isAnimFinished())
                    playAnim('deathLoop');
            }
        } else {
           if (heyTimer > 0) {
               heyTimer -= elapsed;
               if (heyTimer <= 0) {
                   if (animName == 'hey' || animName == 'cheer') {
                       specialAnim = false;
                       dance();
                   }
                   heyTimer = 0;
               }
           } else if (isAnimationFinished()) {
               if (idleDancing)
                   dancedLeft = !PlayState.isEvenBeat;
               specialAnim = false;
           }
        }

        super.update(elapsed);
    }

    // Helpers
    public function checkIdle():Void {
        if (hasAnim('danceRight'))
            idleDancing = true;
        else {
            idleDancing = false;
            danceEveryNumBeats = 1;
        }
    }

    public function dance():Void {
        if (skipDance) return;
        if (idleDancing) {
            dancedLeft = !dancedLeft;
            if (dancedLeft)
                playAnim('danceRight' + animSuffix);
            else
                playAnim('danceLeft' + animSuffix);
        } else if (getAnim('idle') != null)
            playAnim('idle' + animSuffix);
    }

    public inline function getCameraPosition():Array<Float> {
            var midpoint:FlxPoint = getMidpoint();
            var camX:Float = 0;
            var camY:Float = 0;

            camX = midpoint.x + (isPlayer ? -100 : 150) + cameraOffset.x;
            camY = midpoint.y - 100 + cameraOffset.y;

            midpoint.put();
            return [camX, camY];
        }

    // im lazy
    public function getAnim(name:String):FlxAnimation {
        return getAnimation(name);
    }

    override public function playAnim(name:String, force:Bool = false, reversed:Bool = false, frame:Int = 0) {
        super.playAnim(name, force, reversed, frame);

        if (idleDancing) {
            if (name.startsWith('sing'))
                dancedLeft = !PlayState.isEvenBeat;
        }
    }
}