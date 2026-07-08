package funkin.objects.notes;

class SplashGroup extends FlxTypedGroup<Splash> {
    public function new() {
        super();

        // Precreate 10 splashes
        for (i in 0...10)
            add(new NoteSplash());
    }

    public function spawn(dir:Int, x:Float, y:Float):Void {
        var splash = getAvailable();

        if (splash == null) {
            splash = new NoteSplash();
            add(splash);
        }

        splash.playSplash(dir, x, y);
    }

    function getAvailable():NoteSplash {
        for (s in members)
            if (s != null && s.finished)
                return s;

        return null;
    }
}