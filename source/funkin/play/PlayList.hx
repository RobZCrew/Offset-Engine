package funkin.play;

class PlayList {
    public static var isStoryMode:Bool = false;
    public static var campaignScore:Int = 0;

    public static function reset() {
        isStoryMode = false;
        campaignScore = 0;
    }
}