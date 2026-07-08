package funkin.ui;

import flixel.FlxSubState;
import funkin.objects.scripts.HScript;
import funkin.utils.ScriptingUtil;

class ScriptableSubState extends MusicBeatSubstate {
    public var script(default, null):HScript;
    public var scriptName(default, null):String;

    private static var folder(default, null):Null<String> = ScriptingUtil.getFolder('substates');

    // Create / Update
    override function create() {
        loadScript();

        var result = callScript('onCreate');

        if (isFuncBlocked(result))
            return;
            
        super.create();

        callScript('onCreatePost');
    }

    override function update(elapsed:Float) {
        var result = callScript('onUpdate', [elapsed]);

        if (isFuncBlocked(result))
            return;

        super.update(elapsed);

        callScript('onUpdatePost', [elapsed]);
    }

    // Step / Beat
    override function stepHit() {
        callScript('onStepHit');
        super.stepHit();
    }

    override function beatHit() {
        callScript('onBeatHit');
        super.beatHit();
    }

    // Destroy / Draw
    override function destroy() {
        var result = callScript('onDestroy');

        if (script != null)
            script.destroy();

        if (!isFuncBlocked(result))
            super.destroy();
    }

    override function draw() {
        var result = callScript('onDraw');

        if (isFuncBlocked(result))
            return;
        
        super.draw();
    }

    // Substate
    override function close() {
        var result = callScript('onClose');

        if (isFuncBlocked(result))
            return;

        super.close();
    }

    // Helpers
    private function loadScript() {
        scriptName = ScriptingUtil.getClassName(this, true);

        if ((scriptName == null || scriptName.length == 0) || script != null)
            return;

        if (folder == null || folder.length == 0)
            return;
        
        var path = Paths.getPath(folder + scriptName + '.hx', TEXT);

        if (!FileSystem.exists(path) || FileSystem.isDirectory(path))
            return;
        
        script = new HScript(null, path, {
            state: this,
            curStep: this.curStep,
            curBeat: this.curBeat
        });
    }

    private function callScript(func:String, ?args:Array<Dynamic>):Dynamic {
        if (script == null) return null;
        if (args == null) args = [];

        try {
            return script.call(func, args);
        } catch(e:haxe.Exception) {
            FlxG.log.warn('Error calling function $func in script $scriptName: $e');
        }

        return null;
    }

    private function isFuncBlocked(result:Dynamic):Bool {
        return false;
    }
}