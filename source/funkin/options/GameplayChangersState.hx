package funkin.options;

class GameplayChangersState extends CategoryState {
    override function create() {
        super.create();
        options = [
            {
                name: 'Downscroll',
                option: 'downscroll',
                description: 'If checked, the notes will scroll down',
                type: BOOL,
                defaultValue: false
            }
        ];
    }
}