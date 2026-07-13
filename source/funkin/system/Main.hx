package funkin.system;

import flixel.FlxGame;
import openfl.display.Sprite;
import openfl.display.FPS;
import lemonui.Constants as LemonUIConstants;

class Main extends Sprite {
    public function new() {
        super();

        addChild(new FlxGame(1280, 720, funkin.states.TitleState));
        addChild(new FPS(0, 0, 0xFFFFFF));

        Controls.instance = new Controls();

        LemonUIConstants.FONT_REGULAR = Paths.font('vcr.ttf');
        LemonUIConstants.FONT_BOLD = Paths.font('vcr.ttf');
    }
}