package funkin.play.stage;

// THANK YOU AJDESTROYER FOR THIS IDEA!!!!
class StageBuilder {
    public var curStage = 'stage';
    public var defaultZoom = 1.05;

    public var layers:Map<Int, FlxTypedGroup<FlxSprite>>;

    public var bfPosition = [770, 100];
    public var dadPosition = [100, 100];
    public var gfPosition = [400, 130];

    public function new() {
        layers = new Map<Int, FlxTypedGroup<FlxSprite>>();
    }

    public function buildStage(stageName:String) {
        curStage = stageName;
    }
}