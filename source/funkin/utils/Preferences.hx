package funkin.utils;

import flixel.input.keyboard.FlxKey;
import flixel.input.gamepad.FlxGamepadInputID;

class Preferences {
    public static var flashing:Bool = true;
	public static var downscroll:Bool = false;
    public static var keyBinds:Map<String, Array<FlxKey>> = [
		//Key Bind, Name for ControlsSubState
		'note_up'		=> [W, UP],
		'note_left'		=> [A, LEFT],
		'note_down'		=> [S, DOWN],
		'note_right'	=> [D, RIGHT],
		
		'ui_up'			=> [W, UP],
		'ui_left'		=> [A, LEFT],
		'ui_down'		=> [S, DOWN],
		'ui_right'		=> [D, RIGHT],
		
		'accept'		=> [SPACE, ENTER],
		'back'			=> [BACKSPACE, ESCAPE],
		'pause'			=> [ENTER, ESCAPE],
		'reset'			=> [R],
		
		'volume_mute'	=> [ZERO],
		'volume_up'		=> [NUMPADPLUS, PLUS],
		'volume_down'	=> [NUMPADMINUS, MINUS],
		
		'debug_1'		=> [SEVEN],
		'debug_2'		=> [EIGHT]
	];
    public static var gamepadBinds:Map<String, Array<FlxGamepadInputID>> = [
		'note_up'		=> [DPAD_UP, Y],
		'note_left'		=> [DPAD_LEFT, X],
		'note_down'		=> [DPAD_DOWN, A],
		'note_right'	=> [DPAD_RIGHT, B],
		
		'ui_up'			=> [DPAD_UP, LEFT_STICK_DIGITAL_UP],
		'ui_left'		=> [DPAD_LEFT, LEFT_STICK_DIGITAL_LEFT],
		'ui_down'		=> [DPAD_DOWN, LEFT_STICK_DIGITAL_DOWN],
		'ui_right'		=> [DPAD_RIGHT, LEFT_STICK_DIGITAL_RIGHT],
		
		'accept'		=> [A, START],
		'back'			=> [B],
		'pause'			=> [START],
		'reset'			=> [BACK]
	];

	public static function save() {
		if (FlxG.save.data.flashing) FlxG.save.data.flashing = flashing;
		if (FlxG.save.data.downscroll) FlxG.save.data.downscroll = downscroll;
		if (FlxG.save.data.keyBinds) FlxG.save.data.keyBinds = keyBinds;
		if (FlxG.save.data.gamepadBinds) FlxG.save.data.gamepadBinds = gamepadBinds;
		FlxG.save.flush();
	}

	public static function load() {
		if (FlxG.save.data.flashing != null) flashing = FlxG.save.data.flashing;
		if (FlxG.save.data.downscroll != null) downscroll = FlxG.save.data.downscroll;
		if (FlxG.save.data.keyBinds != null) keyBinds = FlxG.save.data.keyBinds;
		if (FlxG.save.data.gamepadBinds != null) gamepadBinds = FlxG.save.data.gamepadBinds;
	}
}