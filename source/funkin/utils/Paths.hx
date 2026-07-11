package funkin.utils;

import flixel.graphics.frames.FlxAtlasFrames;
import openfl.utils.AssetType;
import openfl.utils.Assets as OpenFlAssets;
import lime.utils.Assets;

// Modified Paths with some new features - RobZ
class Paths {
    public static inline var SOUND_EXT = #if web "mp3" #else "ogg" #end;
    public static inline var VIDEO_EXT = "mp4";

    static var currentLevel:String;

    public static function setCurrentLevel(name:String) {
        currentLevel = name.toLowerCase();
    }

    static function getPath(file:String, type:AssetType, ?ignoreMods:Bool = false) {
        // i dont need this thanks but not thanks - RobZ
        /*if (library != null)
            return getLibraryPath(file, library);

        if (currentLevel != null) {
            var levelPath = getLibraryPathForce(file, currentLevel);
            if (OpenFlAssets.exists(levelPath, type))
                return levelPath;
        }*/

        return getPreloadPath(file, ignoreMods);
    }

    /*public static function getLibraryPath(file:String, library = "preload") {
        return if (library == "preload" || library == "default") getPreloadPath(file); else getLibraryPathForce(file, library);
    }

    static inline function getLibraryPathForce(file:String, library:String) {
        return '$library:assets/$library/$file';
    }*/

    static inline function getPreloadPath(file:String, ?ignoreMods:Bool = false) {
        /*#if MODS_ALLOWED
        if (!ignoreMods && Mods.hasMod()) {
            var modPath = Mods.getPath(file);
            if (modPath != null)
                return modPath
        }
        #end*/

        return 'assets/$file';
    }

    public static inline function file(file:String, type:AssetType = TEXT, ?ignoreMods:Bool = false) {
        return getPath(file, type, ignoreMods);
    }

    public static inline function txt(key:String) {
        return getPath('data/$key.txt', TEXT);
    }

    public static inline function xml(key:String) {
        return getPath('data/$key.xml', TEXT);
    }

    public static inline function json(key:String) {
        return getPath('data/$key.json', TEXT);
    }

    public static inline function flag(key:String) {
        return getPath('shaders/$key.flag', TEXT);
    }

    public static inline function vert(key:String) {
        return getPath('shaders/$key.vert', TEXT);
    }

    public static function video(key:String) {
        /*#if MODS_ALLOWED
        if (Mods.hasMod()) {
            var modPath = Mods.getPath('videos/$key.$VIDEO_EXT');
            if (modPath != null)
                return modPath;
        }
        #end*/

        return 'assets/videos/$key.$VIDEO_EXT';
    }

    public static inline function sound(key:String) {
        return getPath('sounds/$key.$SOUND_EXT', SOUND);
    }

    public static inline function soundRandom(key:String, min:Int, max:Int) {
        return sound(key + FlxG.random.int(min, max));
    }

    public static inline function music(key:String) {
        return getPath('music/$key.$SOUND_EXT', MUSIC);
    }

    public static inline function voices(song:String, ?suffix:String = '') {
        return getPath('songs/' + song.toLowerCase() + '/Voices' + suffix + '.' + SOUND_EXT, SOUND);
    }

    public static inline function inst(song:String) {
        return getPath('songs/${song.toLowerCase()}/Inst.$SOUND_EXT', SOUND);
    }

    public static inline function image(key:String) {
        return getPath('images/$key.png', IMAGE);
    }

    public static function font(key:String) {
        /*#if MODS_ALLOWED
        if (Mods.hasMod()) {
            var modPath = Mods.getPath('fonts/$key');
            if (modPath != null)
                return modPath;
        }
        #end*/

        return 'assets/fonts/$key';
    }

    public static function getText(path:String, ?library:String, ?ignoreMods:Bool = false):String {
        var file:String = file(path, TEXT, ignoreMods);

        /*#if MODS_ALLOWED
        if (FileSystem.exists(file))
            return File.getContent(file);
        #end*/

        if (OpenFlAssets.exists(file, TEXT))
            return Assets.getText(file);

        return null;
    }

    public static inline function getSparrowAtlas(key:String) {
        return FlxAtlasFrames.fromSparrow(image(key), file('images/$key.xml', TEXT));
    }

    public static inline function getPackerAtlas(key:String) {
        return FlxAtlasFrames.fromSpriteSheetPacker(image(key), file('images/$key.txt', TEXT));
    }

    public static inline function getAtlas(key:String):FlxAnimateFrames {
        return FlxAnimateFrames.fromAnimate(image(key));
    }
}