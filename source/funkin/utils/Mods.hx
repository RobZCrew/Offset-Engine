package funkin.modding;

import sys.FileSystem;
import sys.io.File;
import haxe.Json;

/**
 * @author RobZ
 */
class Mods {
    public static var currentMod(default, null):String;
    public static var currentModDirectory(default, null):String;

    private static var modJson:ModData;

    /** Returns a list of available mods inside the mods folder. */
    public static function getAvailableMods():Array<String> {
        if (!FileSystem.exists('mods'))
            return [];

        var result:Array<String> = [];

        for (entry in FileSystem.readDirectory('mods')) {
            var fullPath = 'mods/$entry';
            if (FileSystem.isDirectory(fullPath) && FileSystem.exists('$fullPath/mod.json'))
                result.push(entry);
        }

        return result;
    }

    /**
     * Sets the current active mod.
     * Pass null to disable mods.
     */
    public static function setCurrentMod(mod:String):Void {
        if (mod == null) {
            currentMod = null;
            modJson = null;

            Options.currentMod = null;
            Options.save();

            return;
        }

        var fullPath = 'mods/$mod';
        if (FileSystem.exists(fullPath) && FileSystem.isDirectory(fullPath) && FileSystem.exists('$fullPath/mod.json')) {
            currentMod = mod;
            currentModDirectory = fullPath;
            try {
                modJson = Json.parse(File.getContent('$fullPath/mod.json'));
            } catch(e) {
                trace('Mods: Invalid mod.json in "$mod"');
                modJson = null;
            }

            Options.currentMod = mod;
            Options.save();
        } else
            trace('Mods: Mod "$mod" does not exist.');
    }

    /** Returns true if a mod is currently active. */
    public static inline function hasMod():Bool
        return currentMod != null;

    /** Returns current mod's name if it's currently active. */
    public static inline function getModName():String {
        if (!hasMod())
            return null;

        return modJson != null ? modJson.name : currentMod;
    }

    /**
     * Gets a path inside the active mod.
     * Returns null if not found.
     */
    public static function getPath(path:String):String {
        path = StringTools.ltrim(path, '/');

        if (!hasMod())
            return null;

        var fullPath = 'mods/$currentMod/$path';

        if (FileSystem.exists(fullPath))
            return fullPath;

        return null;
    }

    // Helpers
    public static function getSongsList():SongData {
        var result:SongData = {};

        if (!FileSystem.exists('mods') || !FileSystem.exists('mods/data'))
            return result;

        var fullPath = 'mods/$currentMod/data';
        var jsonPath = '$fullPath/songs.json';

        if (!FileSystem.exists(jsonPath))
            return result;

        try {
            result = Json.parse(File.getContent(jsonPath));
        } catch(e:haxe.Exception) {
            trace('Mods: Error getting songs list: $e');
        }

        return result;
    }

    public static function getModList():Array<ModInfo> {
        var result:Array<ModInfo> = [];

        if (!FileSystem.exists('mods'))
            return result;

        for (entry in FileSystem.readDirectory('mods')) {
            var fullPath = 'mods/$entry';
            var jsonPath = '$fullPath/mod.json';

            if (!FileSystem.isDirectory(fullPath) || !FileSystem.exists(jsonPath))
                continue;

            try {
                var data:ModData = Json.parse(File.getContent(jsonPath));

                result.push({
                    folder: entry,
                    name: data.name,
                    desc: data.desc,
                    author: data.author,
                    version: data.version,
                    isActive: entry == currentMod
                });
            } catch(e:haxe.Exception) {
                trace('Mods: Error getting mods list: $e');
            }
        }

        return result;
    }
}

typedef ModInfo = {
    var folder:String;
    var name:String;
    var desc:String;
    var author:String;
    var version:String;
    var isActive:Bool;
};

typedef ModData = {
    var name:String;
    var desc:String;
    var author:String;
    var version:String;
};

typedef SongData = {
    var songs:Array<Dynamic>;
};