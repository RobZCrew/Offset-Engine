package funkin.objects.songs;

import haxe.Json;
import lime.utils.Assets;

typedef SongData = {
    var meta:SongMetaData;
    var events:Array<SongEvent>
    var strumLines:Array<SongStrumLine>;
};

typedef SongMetaData = {
    var song:String;
    var bpm:Float;
    var needsVoices:Bool;
    var speed:Float;
    var validScore:Bool;
};

typedef SongEvent = {
    var t:Float;
    var type:String;
    var v:Array<Dynamic>;
};

typedef SongStrumLine = {
    var notes:Array<SongNote>;
    var strumVisible:Bool;
    var position:StrumLinePosition;
    var type:StrumLineType;
    var vocalsSuffix:String;
    var characters:Array<String>;
};

typedef SongNote = {
    var t:Float;
    var l:Int;
    var len:Float;
    var ?type:String;
}

enum abstract StrumLinePosition(String) from String to String {
    var DAD = "dad";
    var BF = "bf";
    var GF = "gf";
}

enum abstract StrumLineType(Int) from Int to Int {
    var OPPONENT = 0;
    var PLAYER = 1;
    var ADDITIONAL = 2;
}

class Song {
    public var meta:SongMetaData;
    public var strumLines:Array<SongStrumLine>;

    public function new(chart:SongData) {
        meta = chart.meta;
        strumLines = chart.strumLines;
    }

    public function getCharacterTypeFromStrumline(index:Int):StrumlineType {
        if (strumlines[index] != null) {
            return strumlines[index].type;
        }
    }

    public static function loadFromJson(song:String, ?folder:String = '', ?parent:String = ''):Song {
        var raw:String = Assets.getText(Paths.getPath('$parent/$folder/$song.json', TEXT, null, true)).trim();

        while (!raw.endsWith("}")) {
            raw = raw.substr(0, raw.length - 1);
        }

        var chart:Dynamic = Json.parse(raw);

        if (chart.song != null) {
            return new Song(SongNormalizer.fromPsych(chart));
        } else if (chart.codenameChart != null) {
            return new Song(SongNormalizer.fromCodename(chart, Json.parse(Assets.getText(Paths.getPath('$parent/$folder/meta.json', TEXT, null, true)))));
        } else {
            return new Song(chart);
        }
    }
}