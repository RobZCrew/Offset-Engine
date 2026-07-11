package funkin.states.editors;

import lemonui.elements.TabPanel;
import funkin.system.debug.DebugPopup;

class TestEditorState extends MusicBeatState {
    public var debug:DebugPopup;
    public var tabPanel:TabPanel;
    public var sprite:FlxSprite;

    override public function create():Void {
        super.create();

        tabPanel = new TabPanel(10, 10);
        //tabPanel.x -= 300 - 10;
        tabPanel.addTab('Test Tab');
        tabPanel.addTab('Test Tab 2');
        add(tabPanel);

        sprite = new FlxSprite(10, 10);
        sprite.makeGraphic(100, 100, 0xFF00FF00);
        add(sprite);
        tabPanel.addToTab(0, sprite);

        debug = new DebugPopup();
        add(debug);
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        if (FlxG.keys.justPressed.BACKSPACE) {
            debug.showPopup("You can't go back to TitleState due to a crash");
            trace('no');
        }
    }
}