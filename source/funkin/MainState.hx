package;

/**
 * Main bootstrap state
 * Redirects the game to the desired initial state
 *
 * @author RobZ
 */
class MainState extends FlxState {
    public static var initialized(default, null):Bool = false;
    private static var _initialState:Class<FlxState>;

    /**
     * Initializes the MainState with a custom initial state
     * Must be called before the state is created
     */
    public static function init(initialState:Class<FlxState>):Void {
        if (initialized) return;

        _initialState = initialState;
        initialized = true;
    }

    override public function create():Void {
        super.create();

        if (_initialState == null) {
            throw "MainState was not initialized with an initialState";
        }

        FlxG.switchState(cast Type.createInstance(_initialState, []));
    }
}