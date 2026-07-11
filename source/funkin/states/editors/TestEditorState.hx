package funkin.states.editors;

import lemonui.elements.TabPanel;

class TestEditorState extends MusicBeatState {
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
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        if (FlxG.keys.justPressed.BACKSPACE) {
            FlxG.switchState(new funkin.states.TitleState());
            trace('switching to title state');
        }
    }
}