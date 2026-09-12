package funkin.options;

class NoteOffsetState extends MusicBeatState {
    public var camHUD:FlxCamera;

    public var boyfriend:FlxSprite;
    public var gf:FlxSprite;

    override function create() {
        camHUD = new FlxCamera();
        FlxG.cameras.add(camHUD);
    }
}