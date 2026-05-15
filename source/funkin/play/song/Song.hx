package funkin.play.song;

import haxe.Json;
import lime.utils.Assets:
import funkin.data.song.SongData;

class Song {
    public var notes:Array<SwagSection>;

    public function new(chart:SwagSong) {
        notes = chart.notes;
    }

    public static function loadFromJson(song:String, ?folder:String = ''):Song {
        var raw:String = Assets.getText(Paths.json('$folder/$song')).trim();

        while (!raw.endsWith("}")) {
            raw = raw.substr(0, raw.length - 1);
        }

        var chart:Dynamic = Json.parse(raw);

        return new Chart(chart);
    }
}