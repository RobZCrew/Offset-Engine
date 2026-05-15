package funkin.game;

import flixel.addons.transition.FlxTransitionableState;
import flixel.input.keyboard.FlxKey;

class PauseSubState extends MusicBeatSubstate
{
	var grpMenuShit:FlxTypedGroup<Alphabet>;

	var menuItems:Array<String> = ['Resume', 'Restart Song', 'Options', 'Exit to menu'];
	var curSelected:Int = 0;

	var pauseMusic:FlxSound;

	@:allow(funkin.play.components.CutsceneHandler)
	@:allow(funkin.play.PlayState)
	private static var _onCutscene:Bool = false;

	public function new()
	{
		super();

		if (_onCutscene)
					menuItems = ['Resume', 'Restart Cutscene', 'Skip Cutscene', 'Options', 'Exit to menu'];

		pauseMusic = new FlxSound().loadEmbedded(Paths.music('breakfast'), true, true);
		pauseMusic.volume = 0;
		pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

		FlxG.sound.list.add(pauseMusic);

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0.6;
		bg.scrollFactor.set();
		add(bg);

		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);

		for (i in 0...menuItems.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpMenuShit.add(songText);
		}

		changeSelection();

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	override function update(elapsed:Float)
	{
		if (pauseMusic.volume < 0.5)
			pauseMusic.volume += 0.01 * elapsed;

		super.update(elapsed);

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;
		var accepted = controls.ACCEPT;

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		if (accepted)
		{
			var daSelected:String = menuItems[curSelected];

			if (!_onCutscene) {
			 switch (daSelected)
			 {
				 case "Resume":
					 close();
				 case "Restart Song":
					 MusicBeatState.resetState();
				 case "Options":
					 MusicBeatState.switchState(new options.OptionsMenu());
				 case "Exit to menu":
					 if (PlayState.isStoryMode)
					  MusicBeatState.switchState(new funkin.menus.StoryModeState());
					 else
					  MusicBeatState.switchState(new funkin.menus.FreeplayState());
			 }
 		 } else {
			 switch (daSelected)
			 {
				 case "Resume":
					 close();
				 case "Restart Cutscene":
					 MusicBeatState.resetState(); // for now
			  	case "Skip Cutscene":
					 PlayState.instance.swagCutscene.video.finished = true;
				 case "Options":
					 MusicBeatState.switchState(new options.OptionsMenu());
				 case "Exit to menu":
					 if (PlayState.isStoryMode)
					  MusicBeatState.switchState(new funkin.menus.StoryModeState());
					 else
					  MusicBeatState.switchState(new funkin.menus.FreeplayState());
			 }
				_onCutscene = false;
			}
		}
	}

	override function destroy()
	{
		pauseMusic.destroy();

		super.destroy();
	}

	function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpMenuShit.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}
