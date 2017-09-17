package ;
import flixel.util.FlxSave;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxTimer;
import extension.admob.AdMob;
import extension.admob.GravityMode;

/**
 * ...
 * @author David Bell
 */
class MenuState extends BaseState
{
    public static inline var TEXT_SPEED:Float = 300;

    private var startLabel:FlxText;
    private var pressLabel:FlxText;

    private var _title:FlxSprite;
    private var timer:FlxTimer;

    override public function create():Void
    {
        super.create();
        #if desktop
        FlxG.mouse.visible = true;
        #end
        #if ADS
        AdMob.enableTestingAds();
        AdMob.onInterstitialEvent = onInterstitialEvent;
        AdMob.initAndroid("ca-app-pub-6964194614288140/7785218114", "ca-app-pub-6964194614288140/8331302582", GravityMode.BOTTOM);
        AdMob.initIOS("ca-app-pub-6964194614288140/7785218114", "ca-app-pub-6964194614288140/8331302582", GravityMode.BOTTOM);
        #end
        FlxG.state.bgColor = 0x000000;

        timer = new FlxTimer().start(1.0, myCallback, 1);

        _title = new FlxSprite(0, -200);
        _title.loadGraphic(AssetPaths.frogger_title__png);
        _title.x = (FlxG.width * .5) - (_title.width * .5);
        _title.moves = true;
        _title.velocity.y = TEXT_SPEED;
        add(_title);

        //add(new FlxText(20, FlxG.height - 30, FlxG.width - 40, "Original Frogger graphics and images by Konami. \nThis was created only for demonstration purposes").setFormat(null, 8, 0xffffffff, "center"));
    }
    function onInterstitialEvent(event:String)
    {
        trace("The interstitial is " + event);
    }
    private function myCallback(Timer:FlxTimer):Void
    {
        startLabel = new FlxText(0, 200, FlxG.width, "START").setFormat(null, 18, 0xffffffff, "center");
        pressLabel = new FlxText(0, 400, FlxG.width, "PRESS ANYWHERE TO START").setFormat(null, 18, 0xd33bd1, "center");
        add(startLabel);
        add(pressLabel);
    #if ADS
        AdMob.showBanner();
    #end
    }

    override public function update(elapsed:Float):Void
    {
        #if desktop
        if (FlxG.mouse.wheel != 0)
        {
            FlxG.camera.zoom += (FlxG.mouse.wheel / 10);
        }
        #end
        if (_title.y > 100)
            _title.velocity.y = 0;

        #if FLX_TOUCH
        if (FlxG.touches.justStarted().length > 0 && timer.finished)
        #elseif FLX_MOUSE
        if (FlxG.mouse.justPressed && timer.finished)
        #end
        {
            Reg.level = 0;
            levelTxt.text = Std.string(Reg.level);
            FlxG.cameras.fade(0xff969867, 1, false, startGame);
        }

        super.update(elapsed);
    }

    private function startGame():Void
    {
        FlxG.switchState(new PlayState());

    }
}