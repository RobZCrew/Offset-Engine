package funkin.objects.game.stage;

import sys.FileSystem;
import sys.io.File;
import lime.utils.Assets;
import funkin.data.animation.TypedAnimationData;

typedef StageData = {
    var directory:String;
    var defaultZoom:Float;

    var bfPosition:Array<Float>;
    var dadPosition:Array<Float>;
    var gfPosition:Array<Float>;

    var bfCamPosition:Array<Float>;
    var dadCamPosition:Array<Float>;
    var gfCamPosition:Array<Float>;

    var _editor_meta:StageEditorMeta;

    var objects:Array<StageObject>;
};

// This seems like psych engine chart, maybe it will be changed later...
// Quick Update: i did it lol
typedef StageEditorMeta = {
    var boyfriend:String;
    var dad:String;
    var girlfriend:String;
};

typedef StageObject = {
    var position:Array<Float>;
    var type:ObjectType;
    var layer:Int;
    var image:String;
    var name:String;
    var scale:Array<Float>;
    var scrollFactor:Array<Float>;
    var ?camera:String;
    var ?animations:Array<TypedAnimationData>;
};

enum abstract ObjectType(String) from String to String {
    var NORMAL = 'normal';
    var SPARROW = 'sparrow';
    var ATLAS = 'atlas';
}

// THANK YOU AJDESTROYER FOR THIS IDEA!!!!
class StageBuilder {
    var json:StageData;

    public var curStage:String = 'stage';
    public var defaultZoom:Float = 1.05;
    public var directory:String = '';

    public var layers:Map<Int, FlxTypedGroup<FunkinSprite>>;
    public var objects:Map<String, FunkinSprite>;

    public var bfPosition:Array<Float> = [770, 100];
    public var dadPosition:Array<Float> = [100, 100];
    public var gfPosition:Array<Float> = [400, 130];

    public var bfCamPosition:Array<Float> = [0, 0];
    public var dadCamPosition:Array<Float> = [0, 0];
    public var gfCamPosition:Array<Float> = [0, 0];

    public function new() {
        layers = new Map<Int, FlxTypedGroup<FunkinSprite>>();
        objects = new Map<String, FunkinSprite>();
    }

    public function dummy():StageData {
        return {
            directory: '',
            defaultZoom: 1.05,

            bfPosition: [770, 100],
            dadPosition: [100, 100],
            gfPosition: [400, 130],

            _editor_meta: {
                boyfriend: 'bf',
                dad: 'dad',
                girlfriend: 'gf'
            },

            objects: []
        };
    }

    public function getStageFile(stage:String):StageData {
        try {
            var path:String = Paths.json('stages/$stage');
            #if MODS_ALLOWED
            if (FileSystem.exists(path))
                return cast haxe.Json.parse(File.getContent(path));
            #else
            if (Assets.exists(path))
                return cast haxe.Json.parse(Assets.getText(path));
            #end
        }
        return dummy();
    }

    public function buildStage(stageName:String) {
        curStage = stageName;

        json = getStageFile(stageName)

        defaultZoom = json.defaultZoom;
        directory = json.directory;

        if (!directory.endsWith('/'))
            directory += '/';

        bfPosition = json.bfPosition;
        dadPosition = json.dadPosition;
        gfPosition = json.gfPosition;

        bfCamPosition = json.bfCamPosition;
        dadCamPosition = json.dadCamPosition;
        gfCamPosition = json.gfCamPosition;

        buildObjects();

        switch(stageName) {
            case 'philly': phillyScript();
            default: // nothing
        }
    }

    private function buildObjects() {
        for (data in json.objects) {
            var spr = new FunkinSprite(data.position[0], data.position[1], Paths.image(directory + data.image), cast(data.type, SpriteType));
            spr.scale.set(data.scale[0], data.scale[1]);
            spr.scrollFactor.set(data.scale[0], data.scale[1]);
            spr.camera = data.camera ?? FlxG.camera;
            spr.ID = data.layer;

            if (data.animations != null && data.animations.length > 0) {
                for (anim in data.animations) {
                    if (anim.indices != null && anim.indices.length > 0)
                        spr.addAnimByIndices(anim.anim, anim.name, anim.indices, anim.fps, anim.loop);
                    else
                        spr.addAnim(anim.anim, anim.name, anim.fps, anim.loop);

                    if (spr.isAnimateAtlas && anim.type == FRAMELABEL) {
                        if (anim.indices != null && anim.indices.length > 0)
                            spr.addAnimByFrameLabelIndices(anim.anim, anim.name, anim.indices, anim.fps, anim.loop);
                       else
                            spr.addAnimByFrameLabel(anim.anim, anim.name, anim.fps, anim.loop);
                    }

                    if (anim.offsets != null && anim.offsets.length > 0)
                        addOffset(anim.anim, anim.offsets[0], anim.offsets[1]);
                    }
                }
            }

            if (!objects.exists(data.name))
                objects.set(data.name, spr);

            addToLayer(data.layer, spr);
        }
    }

    public function addToLayer(layerIndex:Int, sprite:FunkinSprite) {
        if (!layers.exists(data.layer))
            layers.set(data.layer, new FlxTypedGroup<FunkinSprite>());

        layers.get(data.layer).add(spr);
    }

    public function addLayersToState(state:PlayState) {
        var sortedKeys:Array<Int> = [];
        for (key in layers.keys()) {
            sortedKeys.push(key);
        }
        sortedKeys.sort(function(a:Int, b:Int):Int { return a - b; });

        for (key in sortedKeys) {
            state.insert(key, layers.get(key));
        }
    }
}