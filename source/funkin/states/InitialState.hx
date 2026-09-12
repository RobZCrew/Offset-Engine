package funkin.states;

import flixel.FlxState;

class InitialState extends FlxState {
    override function create() {
        super.create();
        trace('InitialState: Switching to TitleState');
        FlxG.switchState(new TitleState());
    }
}