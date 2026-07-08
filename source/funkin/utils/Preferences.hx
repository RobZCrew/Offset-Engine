package funkin.utils;

import flixel.input.keyboard.FlxKey;
import flixel.input.gamepad.FlxGamepadInputID;

class Preferences {
    /** Gameplay Options */
    public static var downscroll:Bool = false;
    public static var shaders:Bool = true;
    public static var antialiasing:Bool = true;

    /** Miscellaneous */
    public static var freeplayBeats:Bool = true;

    /** Hided Options (for save stuff) */
    #if MODS_ALLOWED
    public static var currentMod:String = null;
    #end

    /** Controls */
    public static var keyBinds:Map<String, Array<FlxKey>> = [
        'note_up' => [W, UP],
        'note_left' => [A, LEFT],
        'note_down' => [S, DOWN],
	      	'note_right'	 => [D, RIGHT],

        'ui_up' => [W, UP],
        'ui_left' => [A, LEFT],
        'ui_down' => [S, DOWN],
        'ui_right' => [D, RIGHT],

        'accept' => [SPACE, ENTER],
        'back' => [BACKSPACE, ESCAPE],
        'pause' => [ENTER, ESCAPE],
        'reset' => [R],

        'volume_mute' 	=> [ZERO],
        'volume_up' => [NUMPADPLUS, PLUS],
        'volume_down' 	=> [NUMPADMINUS, MINUS],

        'debug_1' => [SEVEN],
        'debug_2' => [EIGHT]
    ];

    public static var gamepadBinds:Map<String, Array<FlxGamepadInputID>> = [
        'note_up' => [DPAD_UP, Y],
        'note_left' => [DPAD_LEFT, X],
        'note_down' => [DPAD_DOWN, A],
	      	'note_right'	 => [DPAD_RIGHT, B],

        'ui_up' => [DPAD_UP, LEFT_STICK_DIGITAL_UP],
        'ui_left' => [DPAD_LEFT, LEFT_STICK_DIGITAL_LEFT],
        'ui_down' => [DPAD_DOWN, LEFT_STICK_DIGITAL_DOWN],
        'ui_right' => [DPAD_RIGHT, LEFT_STICK_DIGITAL_RIGHT],

        'accept' => [A, START],
        'back' => [B],
        'pause' => [START],
        'reset' => [BACK]
    ];

    /** Internal trackers for util things */
    // nothing for now

    public static function load():Void {
        if (FlxG.save.data.downscroll != null)
            downscroll = FlxG.save.data.downscroll;
        if (FlxG.save.data.shaders != null)
            shaders = FlxG.save.data.shaders;
        if (FlxG.save.data.antialiasing != null)
            antialiasing = FlxG.save.data.antialiasing;

        #if MODS_ALLOWED
        if (FlxG.save.data.currentMod != null)
            Mods.setCurrentMod(FlxG.save.data.currentMod);
        #end

        if (FlxG.save.data.keyboard != null)
            keyBinds = FlxG.save.data.keyboard;
        if (FlxG.save.data.gamepad != null)
            gamepadBinds = FlxG.save.data.gamepad;
    }

    public static function save():Void {
        FlxG.save.data.downscroll = downscroll;
        FlxG.save.data.shaders = shaders;
        FlxG.save.data.antialiasing = antialiasing;

        #if MODS_ALLOWED
        FlxG.save.data.currentMod = currentMod;
        #end

        FlxG.save.data.keyboard = keyBinds;
        FlxG.save.data.gamepad = gamepadBinds;

        FlxG.save.flush();

        trace('Options: Settings sucessfully saved!');
    }
}