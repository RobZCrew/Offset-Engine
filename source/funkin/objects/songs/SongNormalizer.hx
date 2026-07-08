package funkin.objects.songs;

class SongNormalizer {
    public static function fromPsych(raw:Dynamic):SongData {
        var noteEvents = normalizePsychNoteEvents(raw.song.notes);
        var psychEvents = normalizePsychEvents(raw.song.events, raw.song);

        return {
            meta: normalizePsychMeta(raw.song),
            notes: normalizePsychStrumLines(raw.song),
            events: noteEvents.concat(psychEvents)
        };
    }

    public static function fromCodename(raw:Dynamic, metaRaw:Dynamic):SongData {
        return {
            meta: normalizeCodenameMeta(raw, metaRaw),
            notes: normalizeCodenameStrumLines(raw.strumLines, raw),
            events: normalizeCodenameEvents(raw.events, raw, metaRaw)
        };
    }

    // PSYCH NORMALIZER
    static function normalizePsychMeta(raw:Dynamic):SongMetaData {
        return {
            song: raw.song,
            needsVoices: raw.needsVoices ?? true,
            bpm: raw.bpm,
            speed: raw.speed,

            stage: raw.stage ?? "stage",

            generatedBy: "RobZ Engine - Chart Normalizer"
        };
    }

    static function normalizePsychStrumLines(raw:Dynamic):Array<SongStrumLines> {
        var dadStrum:Array<SongNote> = [];
        var bfStrum:Array<SongNote> = [];
        var gfStrum:Array<SongNote> = [];

        for (section in raw.notes) {
            var mustHit:Bool = section.mustHitSection;
            var gfSection:Null<Bool> = section.gfSection;

            for (n in section.sectionNotes) {
                var l:Int = Std.int(n[1]) % 4;

                var note:ChartNote = {
                    t: n[0],
                    l: l,
                    len: n[2],
                    type: n[3]
                };

                if (gfSection || note.type == 'GF Sing') {
                    note.type = '';
                    gfStrum.push(note);
                } else if (mustHit) {
                    bfStrum.push(note);
                } else {
                    dadStrum.push(note);
                }
            }
        }

        return [
            {
                notes: dadStrum,
                strumVisible: true,
                position: DAD,
                type: OPPONENT,
                vocalsSuffix: '',
                characters: [raw.player2]
            },
            {
                notes: bfStrum,
                strumVisible: true,
                position: BF,
                type: PLAYER,
                vocalsSuffix: '',
                characters: [raw.player1]
            },
            {
                notes: gfStrum,
                strumVisible: gfStrum.length > 0,
                position: GF,
                type: ADDITIONAL,
                vocalsSuffix: '',
                characters: [raw.gfVersion ?? 'gf']
            }
        ];
    }

    static function normalizePsychNoteEvents(sections:Array<Dynamic>):Array<ChartEvent> {
        var result:Array<ChartEvent> = [];

        var lastMustHit:Null<Bool> = null;
        var lastAltAnim:Null<Bool> = null;
        var lastChar:Null<String> = null; // for lastAltAnim

        for (section in sections) {
            var mustHit:Bool = section.mustHitSection;
            var altAnim:Bool = section.altAnim;

            if (section.sectionNotes.length == 0)
                continue;

            var t:Float = section.sectionNotes[0][0];

            if (lastMustHit == null || mustHit != lastMustHit) {
                result.push({
                    t: t,
                    type: "Camera Follow",
                    v: [mustHit ? "boyfriend" : "dad"]
                });

                lastMustHit = mustHit;
            }

            if (lastAltAnim == null || altAnim != lastAltAnim) {
                result.push({
                    t: t,
                    type: "Alt Anim",
                    v: [lastChar ?? (mustHit ? "boyfriend" : "dad")]
                });

                lastAltAnim = altAnim;
                lastChar = mustHit ? "boyfriend" : "dad";
            }
        }

        return result;
    }

    static function normalizePsychEvents(psychEvents:Array<Dynamic>, raw:Dynamic):Array<ChartEvent> {
        var result:Array<ChartEvent> = [];

        if (psychEvents == null || raw == null)
            return result;

        var curSpeed:Float = raw.speed;

        for (eventBlock in psychEvents) {
            var time:Float = eventBlock[0];
            var list:Array<Dynamic> = eventBlock[1];

            for (e in list) {
                var type:String = e[0];
                var v:Array<Dynamic> = [];

                switch(type) {
                    case 'Change Scroll Speed':
                       var mult:Float = Std.parseFloat(e[1]);
                       if (Math.isNaN(mult)) mult = 1;

                       curSpeed *= mult;
                       v.push(curSpeed);

                    case 'Change Character':
                       v = [normalizeChar(e[1]), e[2]];

                    case 'Play Animation':
                       v = [normalizeChar(e[2]), e[1]];

                    default:
                       v = [
                           e.length > 1 ? e[1] : null,
                           e.length > 2 ? e[2] : null
                       ];
                }

                result.push({
                    t: time,
                    type: type,
                    v: v
                });
            }
        }

        return result;
    }

    // Helper for psych events normalizer
    static inline function normalizeChar(char:String):String {
       return switch(char) {
           case 'bf' | 'boyfriend' | '0': 'boyfriend';
           case 'dad' | '1': 'dad';
           case 'gf' | 'girlfriend' | '2': 'gf';
           default: char;
       }
    }

    // CODENAME NORMALIZER
    static function normalizeCodenameMeta(raw:Dynamic, metaRaw:Dynamic):SongMetaData {
        return {
            song: metaRaw.displayName ?? metaRaw.name,
            needsVoices: metaRaw.needsVoices ?? true,
            bpm: metaRaw.bpm ?? 150,
            speed: raw.scrollSpeed ?? raw.speed ?? 1,

            stage: raw.stage ?? "stage",

            generatedBy: "RobZ Engine - Chart Normalizer"
        }
    }

    static function normalizeCodenameStrumLines(strumLines:Array<Dynamic>, raw:Dynamic):Array<SongStrumLine> {
        var result:Array<SongStrumLine> = [];

        if (strumLines == null)
            return result;

        for (strum in strumLines) {
            result.push({
                notes: normalizeCodenameNotes(strum, raw),
                strumVisible: strum.visible,
                position: getPositionFromString(strum.position),
                type: getTypeFromString(strum.type),
                vocalsSuffix: strum.vocalsSuffix ?? '',
                characters: strum.characters
            });
        }

        return result;
    }

    static function normalizeCodenameNotes(strumLine:Dynamic, raw:Dynamic):Array<SongNote> {
        var result:Array<SongNote> = [];

        if (strumLine == null)
            return result;

        var noteTypes:Array<String> = raw.noteTypes.copy();

        if (noteTypes.length <= 0 || noteTypes[0] != '')
            noteTypes.insert(0, '');

        var notes:Array<Dynamic> = strumLine.notes ?? [];
        for (n in notes) {
            var note:SongNote = {
                t: n.time,
                l: Std.int(n.id) % 4,
                len: n.sLen ?? 0,
                type: noteTypes[n.type]
            };
            result.push(note);
        }

        return result;
    }

    static function normalizeCodenameEvents(events:Array<Dynamic>, raw:Dynamic, metaRaw:Dynamic):Array<SongEvent> {
        var result:Array<SongEvent> = [];

        if (events == null || raw == null || metaRaw == null)
            return result;

        var curSpeed:Float = raw.scrollSpeed ?? raw.speed;

        for (e in events) {
            var t:Float = e.time;
            var type:String = e.name;
            var v:Array<Dynamic> = [];

            switch(type) {
                case 'Camera Movement':
                    type = 'Camera Follow';
                    v.push(getActorFromIndex(e.params[0]));

                case 'Alt Animation Toggle':
                    type = 'Alt Anim';
                    v.push(getActorFromIndex(e.params[2]));

                case 'Scroll Speed Change':
                    var isMultipler:Bool = cast e.params[5] ?? false;

                    if (isMultipler)
                        curSpeed *= e.params[1];
                    else
                        curSpeed = e.params[1];

                    type = 'Change Scroll Speed';
                    v.push(curSpeed);

                case 'Play Animation':
                    v = [getActorFromIndex(e.params[0]), e.params[1]];

                default:
                    v = e.params ?? [];
            }

            result.push({
                t: t,
                type: type,
                v: v
            });
        }

        return result;
    }

    // Helpers for codename strumlines normalizer
    static inline function getPositionFromString(str:String):StrumLinePosition {
        return switch(str) {
            case 'dad': DAD;
            case 'boyfriend': BF;
            case 'girlfriend': GF;
            default: DAD;
        }
    }

    static inline getTypeFromString(i:String):StrumLineType {
        return switch(i) {
            case 0: OPPONENT;
            case 1: PLAYER;
            case 2: ADDITIONAL;
            default: OPPONENT;
        }
    }

    // Helper for codename events normalizer
    static inline function getActorFromIndex(i:Int):String {
        return switch(i) {
            case 0: 'dad';
            case 1: 'boyfriend';
            case 2: 'gf';
            default: 'dad';
        }
    }
}