package funkin.backend.utils;

class ReflectUtil {
    public static function get(obj:Dynamic, field:String):Dynamic {
        return Reflect.field(obj, field);
    }

    public static function set(obj:Dynamic, field:String, value:Dynamic):Void {
        Reflect.setField(obj, field, value);
    }

    public static function call(obj:Dynamic, func:String, args:Array<Dynamic>):Dynamic {
        var f = Reflect.field(obj, func);
        if (f == null) return null;
        return Reflect.callMethod(obj, f, args);
    }
}