package funkin.data.animation;

typedef AnimationData = {
    var ?type:AnimationType;
    var anim:String;
    var name:String;
    var fps:Int;
    var loop:Bool;
    var indices:Array<Int>;
    var offsets:Array<Float>;
};