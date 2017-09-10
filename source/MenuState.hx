package ;
import flixel.util.FlxSave;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxTimer;

/**
 * ...
 * @author David Bell
 */
class MenuState extends BaseState
{
    public static inline var TEXT_SPEED:Float = 300;

    // Augh, so many text objects. I should make arrays.
    //private var _text1:FlxText;
    //private var _text2:FlxText;
    private var _text3:FlxText;
    private var _text4:FlxText;
    private var _text5:FlxText;

    private var _pointer:FlxSprite;
    private var _title:FlxSprite;

    // This will indicate what the pointer is pointing at
    private var _option:Option = PLAY;
    private var timer:FlxTimer;
    //private var scoreTxt:FlxText;
    //private var _gameSave:FlxSave;

    //private var _highScore:Int = 0;
    //private var _score:Int = 0;

    override public function create():Void
    {
        super.create();
        #if mobile
        FlxG.mouse.visible = false;
        #end
        FlxG.state.bgColor = 0x000000;

        timer = new FlxTimer().start(1.0, myCallback, 1);

        _title = new FlxSprite(0, -200);
        _title.loadGraphic(AssetPaths.frogger_title__png);
        _title.x = (FlxG.width * .5) - (_title.width * .5);
        _title.moves = true;
        _title.velocity.y = TEXT_SPEED;
        add(_title);

        add(new FlxText(20, FlxG.height - 30, FlxG.width - 40, "Original Frogger graphics and images by Konami. \nThis was created only for demonstration purposes").setFormat(null, 8, 0xffffffff, "center"));

        // Set up the menu options
//        _text3 = new FlxText(FlxG.width * 2 / 3, FlxG.height * 2 / 3, 0, "Play");
//        _text4 = new FlxText(FlxG.width * 2 / 3, FlxG.height * 2 / 3 + 30, 0, "Visit NIWID");
//        _text5 = new FlxText(FlxG.width * 2 / 3, FlxG.height * 2 / 3 + 60, 0, "Visit haxeflixel.com");
//        _text3.color = _text4.color = _text5.color = 0xAAFFFF00;
//        _text3.size = _text4.size = _text5.size = 16;
//        _text3.antialiasing = _text4.antialiasing = _text5.antialiasing = true;
//        add(_text3);
//        add(_text4);
//        add(_text5);
//
//        _pointer = new FlxSprite();
//        _pointer.loadGraphic("assets/art/pointer.png");
//        _pointer.x = _text3.x - _pointer.width - 10;
//        add(_pointer);
    }
    private function myCallback(Timer:FlxTimer):Void
    {
        add(new FlxText(0, 200, FlxG.width, "START").setFormat(null, 18, 0xffffffff, "center"));
        add(new FlxText(0, 400, FlxG.width, "PRESS ANYWHERE TO START").setFormat(null, 18, 0xd33bd1, "center"));

        //var activateText:FlxText = add(new FlxText(0, 400, FlxG.width, "PRESS ENTER TO START").setFormat(null, 18, 0xd33bd1, "center")) as FlxText;

        //activateText.text = "PRESS ANYWHERE TO START";

    }

    override public function update(elapsed:Float):Void
    {
        if (FlxG.mouse.wheel != 0)
        {
            FlxG.camera.zoom += (FlxG.mouse.wheel / 10);
        }
        if (_title.y > 100)
            _title.velocity.y = 0;

        // this is the goofus way to do it. An array would be way better
//        _pointer.y = switch (_option)
//        {
//            case PLAY: _text3.y;
//            case BLOG: _text4.y;
//            case FLIXEL: _text5.y;
//        }
//
//        if (FlxG.keys.justPressed.UP)
//            modifySelectedOption(-1);
//        if (FlxG.keys.justPressed.DOWN)
//            modifySelectedOption(1);
//
//        if (FlxG.keys.anyJustPressed([SPACE, ENTER, C]))
//        {
//            switch (_option)
//            {
//                case PLAY:
//                    FlxG.cameras.fade(0xff969867, 1, false, startGame);
//                    //FlxG.sound.play("Theme");
//                    //FlxG.sound.play("assets/sounds/coin" + Reg.SoundExtension, 1, false);
//                case BLOG:
//                    //_gameSave.data.highScore = 100;
//                    //_gameSave.flush();
//                    FlxG.openURL("http://chipacabra.blogspot.com");
//                case FLIXEL:
//                    FlxG.openURL("http://haxeflixel.com");
//            }
//        }
        #if FLX_TOUCH
        if (FlxG.touches.justStarted().length > 0 && timer.finished)
        #elseif FLX_MOUSE
        if (FlxG.mouse.justPressed && timer.finished)
        #end
        {
            FlxG.cameras.fade(0xff969867, 1, false, startGame);
        }

        super.update(elapsed);
    }

    private function modifySelectedOption(modifier:Int):Void
    {
        var options = Option.getConstructors();
        var index = options.indexOf(Std.string(_option)) + modifier;
        _option = Option.createByIndex(FlxMath.wrap(index, 0, options.length - 1));

        //FlxG.sound.play("assets/sounds/menu" + Reg.SoundExtension, 1, false);
    }

    private function startGame():Void
    {
        FlxG.switchState(new PlayState());

    }
}
enum Option
{
    PLAY;
    BLOG;
    FLIXEL;
}