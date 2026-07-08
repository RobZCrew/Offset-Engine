package funkin.utils;

class ScriptingUtil {
    private static var folders:Map<String, String> = [
        'default' => 'scripts',
        'state' => 'data/states',
        'substate' => 'data/substates'
    ];
    private static var customFolders:Map<String, String> = [];

    // Helpers
    public static function getFolder(type:String = 'default'):Null<String> {
        if (folders.exists(type))
            return folders.get(type) + '/';

        return null;
    }

    // "Unexcepted keyword: class" i hate you sometimes haxe...
    public static function getClassName(c:Dynamic, ?split:Bool = false):String {
        var name = Type.getClassName(Type.getClass(c));

        if (!split)
            return name;
        else
            return name.split('.').pop();
    }

    // HScript Helpers
    public static function setCustomFolder(name:String, value:String):Bool {
        if (!customFolders.exists(name)) {
            customFolders.set(name, value);
            return true;
        }

        return false;
    }

    public static function getCustomFolder(name:String):Null<String> {
        if (customFolders.exists(name)) {
            var customFolder = customFolders.get(name);

            if (!customFolder.endsWith('/'))
                return customFolder + '/';
            else
                return customFolder;
        }

        return null;
    }
}