package funkin.backend.utils;

import flixel.system.FlxAssets.FlxShader;
import openfl.filters.ShaderFilter;

// Allows the script to access to private stuff of FlxCamera
@:access(flixel.FlxCamera)
class CameraUtil {
    // Newer versions only have this (i hate you flixel)
    public static function insertFlxCamera(index:Int, camera:FlxCamera, defDraw:Bool = false) {
        var cameras = [
            for (i in FlxG.cameras.list) {
                cam: i,
                defaultDraw: FlxG.cameras.defaults.contains(i)
            }
        ];

        for (i in cameras) FlxG.cameras.remove(i.cam, false);

        index = Std.int(FlxMath.bound(index, 0, cameras.length));
        cameras.insert(index, {cam: camera, defaultDraw: defDraw});

        for (i in cameras) FlxG.cameras.add(i.cam, i.defaultDraw);
    }

    // I hate you flixel part 2
    public static function addShader(shader:FlxShader, ?camera:FlxCamera) {
        if (camera == null) camera = FlxG.camera;
        var filter:ShaderFilter = new ShaderFilter(shader);
        if (camera._filters == null) camera._filters = [];
        camera._filters.push(filter);
    }

    public static function removeShader(shader:FlxShader, ?camera:FlxCamera):Bool {
        if (camera == null) camera = FlxG.camera;
        if (camera._filters == null) return false;

        for (i in camera._filters) {
            if (i is ShaderFilter) {
                var filter:ShaderFilter = cast i;
                if (filter.shader == shader) {
                    camera._filters.remove(i);
                    return true;
                }
            }
        }

        return false;
    }
}