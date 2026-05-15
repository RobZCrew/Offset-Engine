package funkin.editors;

import lemonui.elements.TabPanel;

// LEMONUI IS EPIC!!!!
// Testing LemonUI btw
class TestEditor extends MusicBeatState {
    public var panel:TabPanel;
    public var sprite:FlxSprite;

    override function create() {
        super.create();

        panel = new TabPanel(FlxG.width, 10);
        panel.x -= 300 - 10;
        panel.addTab('testTab');
        add(panel);

        sprite = new FlxSprite().loadGraphic(Paths.image('num0'));
        add(sprite);
        panel.addToTab(0, sprite);
    }
}