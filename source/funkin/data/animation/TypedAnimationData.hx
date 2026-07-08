package funkin.data.animation;

typedef TypedAnimationData = {
    var ?type:AnimationType;
    var anim:String;
    var name:String;
    var fps:Int;
    var loop:Bool;
    var indices:Array<Int>;
    var offsets:Array<Float>;
};

enum abstract AnimationType(String) from String to String {
    var SYMBOL = "symbol";
    var FRAMELABEL = "framelabel";
}