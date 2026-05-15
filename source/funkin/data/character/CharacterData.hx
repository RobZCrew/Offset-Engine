package funkin.data.character;

typedef CharacterData = {
    var meta:CharacterMeta;
    var animations:Array<CharacterAnimation>;
};

typedef CharacterMeta = {
    var image:String;
    var scale:Float;
    var singDuration:Float;
    var iconProperties:IconProperties;

    var ?position:Null<Array<Float>>;
    var ?cameraPosition:Null<Array<Int>>;

    var flipX:Bool;
    var antialiasing:Bool;
};

typedef CharacterAnimation = {
    var anim:String;
    var name:String;
    var fps:Int;
    var loop:Bool;
    var indices:Array<Int>;
    var offsets:Array<Int>;
};