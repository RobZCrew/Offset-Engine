package funkin.system.interfaces;

interface IBeatReceiver {
    public function stepHit(curStep:Int):Void;
    public function beatHit(curBeat:Int):Void;
}