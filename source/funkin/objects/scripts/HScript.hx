package funkin.objects.scripts;

import hscript.Interp;
import hscript.Parser;

#if sys
import sys.FileSystem;
import sys.io.File;
#end

class HScript {
    public var interp:Interp;
    public var parser:Parser;

    public function new(path:String, customVariables:Any) {
        interp = new Interp();

        parser = new Parser();
        parser.allowTypes = true;
        parser.allowMetadata = true;
    }
}