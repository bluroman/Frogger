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
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFieldType;
import openfl.text.TextFormatAlign;
import openfl.text.TextFieldAutoSize;
import openfl.Lib;
import flixel.system.scaleModes.FillScaleMode;

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
    private var _background:FlxSprite;

    override public function create():Void
    {
        super.create();
        if(FlxG.sound.music != null && FlxG.sound.music.playing )
            FlxG.sound.music.stop();
        //if (FlxG.sound.music == null) // don't restart the music if it's alredy playing
        //{
            FlxG.sound.playMusic("Menu", 1, true);
        //}
        #if desktop
        FlxG.mouse.visible = true;
        #end
        FlxG.scaleMode = new FillScaleMode();
        #if ADS
        AdMob.enableTestingAds();
        AdMob.onInterstitialEvent = onInterstitialEvent;
        AdMob.initAndroid("ca-app-pub-6964194614288140/7785218114", "ca-app-pub-6964194614288140/8331302582", GravityMode.BOTTOM);
        AdMob.initIOS("ca-app-pub-6964194614288140/7785218114", "ca-app-pub-6964194614288140/8331302582", GravityMode.BOTTOM);
        #end
        FlxG.state.bgColor = 0x000000;

        _background = new FlxSprite(0, 80);
        _background.loadGraphic(AssetPaths.arcade_froggy2__png);
        add(_background);

        timer = new FlxTimer().start(1.0, myCallback, 1);

        _title = new FlxSprite(0, -200);
        _title.loadGraphic(AssetPaths.frogger_title__png);
        _title.x = (FlxG.width * .5) - (_title.width * .5);
        _title.moves = true;
        _title.velocity.y = TEXT_SPEED;
        add(_title);
        //openflTextFieldTest();

        //add(new FlxText(20, FlxG.height - 30, FlxG.width - 40, "Original Frogger graphics and images by Konami. \nThis was created only for demonstration purposes").setFormat(null, 8, 0xffffffff, "center"));
    }
    function onInterstitialEvent(event:String)
    {
        trace("The interstitial is " + event);
    }
    function openflTextFieldTest()
    {
        trace("MenuState display width: " + Lib.current.stage.stageWidth + " display height: " + Lib.current.stage.stageHeight);
        var oflScaleX = Lib.current.stage.stageWidth / FlxG.width;
        var oflScaleY = Lib.current.stage.stageHeight / FlxG.height;
        var testField:TextField = new TextField();
        var testFormat:TextFormat = new TextFormat();

        testFormat.font = startLabel.font;
        testFormat.align = TextFormatAlign.CENTER;
        testFormat.size = 30;
        testFormat.color = 0xffffff;

        testField.defaultTextFormat = testFormat;
        testField.embedFonts = true;
        //textfield.defaultTextFormat = new TextFormat(fontName, 32 * oflScaleY, 0xffffff, TextFormatAlign.CENTER);
        testField.type = TextFieldType.INPUT;
        
        testField.background = true;
        testField.backgroundColor = 0xff0000ff;
        testField.width = 300;
        testField.height = 80;

        testField.x = Lib.current.stage.stageWidth / 2.0 - testField.width / 2.0;
        testField.y = Lib.current.stage.stageHeight / 2.0 - testField.height / 2.0;
        //testField.x = 471;
        //testField.y = 1064;
        //testField.border = true;
        //testField.borderColor = 0xff000000;

        testField.maxChars = 5;

        FlxG.addChildBelowMouse(testField);
        FlxG.stage.__dismissSoftKeyboard();
        trace("TextField x:" + testField.x + " y:" + testField.y);
    }
    private function myCallback(Timer:FlxTimer):Void
    {
        startLabel = new FlxText(0, 200, FlxG.width, "START").setFormat(null, 18, 0xffffffff, "center");
        pressLabel = new FlxText(0, 400, FlxG.width, "PRESS ANYWHERE TO START").setFormat(null, 18, 0xd33bd1, "center");
        add(startLabel);
        add(pressLabel);
        //openflTextFieldTest();
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
        FlxG.sound.music.stop();

    }
}