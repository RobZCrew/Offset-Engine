package funkin.utils;

import flixel.system.FlxAssets.FlxShader;
import openfl.filters.ShaderFilter;

@:access(flixel.FlxCamera)
class CameraUtil {
    public static function addShaderToCamera(shader:FlxShader, ?camera:FlxCamera) {
        if (camera == null) camera = FlxG.camera;
        var filter:ShaderFilter = new ShaderFilter(shader);
        if (camera.filters == null) camera.filters =  [];
        camera.filters.push(filter);
    }

    public static function removeShaderToCamera(shader:FlxShader, ?camera:FlxCamera):Bool {
        if (camera == null) camera = FlxG.camera;
        if (camera.filters == null) return false;

        for (i in camera.filters) {
            if (i is ShaderFilter) {
                var filter:ShaderFilter = cast i;
                if (filter.shader == shader) {
                    camera.filters.remove(i);
                    return true;
                }
            }
        }

        return false;
    }
}