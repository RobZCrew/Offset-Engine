package funkin.system;

import flixel.FlxGame;
import openfl.Lib;
import openfl.display.Sprite;
import lemonui.Constants as LemonUIConstants;
import funkin.system.debug.PerformanceOverlay;

class Main extends Sprite {
    public static var version:String = '0.1.0';

    public function new() {
        super();

        addChild(new FlxGame(1280, 720, funkin.states.InitialState, 60, 60, true, false));

        #if !mobile
        FlxG.mouse.useSystemCursor = true;
        addChild(new PerformanceOverlay());
        #end

        FlxG.save.bind('funkin', 'offsetengine');
        Preferences.load();

        Controls.instance = new Controls();

        LemonUIConstants.FONT_REGULAR = Paths.font('Inconsolata-Medium.ttf');
        LemonUIConstants.FONT_BOLD = Paths.font('Inconsolata-Bold.ttf');
    }
}