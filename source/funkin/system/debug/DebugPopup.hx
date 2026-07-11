package funkin.system.debug;

class DebugPopup extends FlxGroup {
    public function new() {
        super();
    }

    public function showPopup(text:String) {
        var text:FlxText = new FlxText(10, (members.length * 16) + 5, FlxG.width, text);
        text.setFormat(Paths.font('vcr.ttf'), 16, 0xAAFFFF00, 'left');
        add(text);

        FlxTween.color(text, 1, 0xAAFFFF00, 0xFFFFFFFF, {ease: FlxEase.quadInOut, onComplete: function(_) {
            FlxTween.tween(text, {alpha: 0}, 1.2, {ease: FlxEase.quadInOut, startDelay: 1, onComplete: function(_) {
                remove(text, true);
                text.destroy();
                updatePositions();
            }});
        }});
        FlxG.sound.play(Paths.sound('cancelMenu'), 0.7);
    }

    private function updatePositions() {
        var i:Int = 0;
        for (member in members) {
            if (member == null) continue;

            var txt:FlxText = cast member;
            txt.y = (i * 16) + 5;
            i++;
        }
    }
}