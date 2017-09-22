package ;
import flixel.util.FlxColor;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFieldType;
import openfl.text.TextFormatAlign;
import openfl.text.TextFieldAutoSize;
import openfl.Lib;
class Hud extends FlxTypedSpriteGroup<FlxSprite>
{
    public static inline var LIFE_X = 20;
    public static inline var LIFE_Y = 610;
    var timeTxt:FlxText;
    var timerBarBackground:FlxSprite;
    public var timerBar:FlxSprite;
    private var lifeSprites = [];
    var messageBG:FlxSprite;
    var messageText:FlxText;
    var enterUserNameBG:FlxSprite;
    var enterYourName:FlxText;
    public function new()
    {
        super();
        lifeSprites = new Array();
        createLives(3);
        // Black background for message
        messageBG = new FlxSprite((480 * .5) - (150 * .5), calculateRow(8) + 5 );
        messageBG.makeGraphic(150, 30, 0xff000000);
        add(messageBG);

        // Message text
        messageText = new FlxText((480 * .5) - (150 * .5), calculateRow(8) + 5 + 4 , 150, "TIME 99").setFormat(null, 18, 0xffff00, "center");
        //gameMessageGroup.visible = false;
        messageBG.visible = false;
        messageText.visible = false;
        add(messageText);

        enterUserNameBG = new FlxSprite(0, calculateRow(8));
        enterUserNameBG.makeGraphic(480, 40, 0xff000000);
        add(enterUserNameBG);

        enterYourName = new FlxText(0, calculateRow(8) + 4, 240, "ENTER YOUR NAME:").setFormat(null, 18, 0xffff00, "left");
        //enterUserNameGroup.visible = false;
        enterUserNameBG.visible = false;
        enterYourName.visible = false;
        add(enterYourName);
        // Create Time text
        timeTxt = new FlxText(FlxG.width - 70, LIFE_Y, 60, "TIME").setFormat(null, 14, 0xffff00, "right");
        add(timeTxt);

        // Create timer graphic
        //TODO this is hacky and needs to be cleaned up
        timerBarBackground = new FlxSprite(timeTxt.x - Reg.TIMER_BAR_WIDTH + 5, LIFE_Y + 2);
        timerBarBackground.makeGraphic(Reg.TIMER_BAR_WIDTH, 16, 0xff21de00);
        add(timerBarBackground);

        timerBar = new FlxSprite(timerBarBackground.x, timerBarBackground.y);
        timerBar.makeGraphic(1, 16, 0xFF000000);
        timerBar.scrollFactor.x = timerBar.scrollFactor.y = 0;
        timerBar.origin.x = timerBar.origin.y = 0;
        timerBar.scale.x = 0;
        add(timerBar);

        forEach(function(spr:FlxSprite)
        {
            spr.scrollFactor.set(0, 0);
        });
    }
    public function showEnterUserNameField(value:Bool):Void
    {
        enterUserNameBG.visible = value;
        enterYourName.visible = value;
        //displayTextField();
    }
    public function showGameMessage(txt:String):Void
    {
        messageBG.visible = true;
        messageText.visible = true;
        messageText.text = txt;
    }
    public function hideGameMessage():Void
    {
        messageBG.visible = false;
        messageText.visible = false;
    }
    public function calculateColumn(value:Int):Int
    {
        return value * PlayState.TILE_SIZE;
    }
    public function calculateRow(value:Int):Int
    {
        return calculateColumn(value);
    }
    /**
         * This loop creates X number of lives.
         * @param value number of lives to create
         */
    public function createLives(value:Int):Void
    {
        var i:Int;
        for (i in 0...value)
            addLife();
    }
    /**
         * This adds a life sprite to the display and pushes it to teh lifeSprites array.
         * @param value
         */
    public function addLife():Void
    {
        var flxLife:FlxSprite = new FlxSprite(LIFE_X * get_totalLives() + 10, LIFE_Y, AssetPaths.lives__png);
        add(flxLife);
        lifeSprites.push(flxLife);
    }
    public function removeLife():Void
    {
        var id:Int = get_totalLives() - 1;
        var sprite:FlxSprite = lifeSprites[id];
        sprite.kill();
        lifeSprites.splice(id, 1);
    }
    /**
         * A simple getter for Total Lives based on life sprite instances in lifeSprites array.
         * @return
         */
    public function get_totalLives():Int
    {
        return lifeSprites.length;
    }
    public function displayTextField():Void
    {
        //FlxG.addChildBelowMouse(textfield);
        var oflScaleX = Lib.current.stage.stageWidth / FlxG.width;
        var oflScaleY = Lib.current.stage.stageHeight / FlxG.height;
        var textfield = new TextField();
        var textformat = new TextFormat();
        var fontName = messageText.font;

        textformat.font = fontName;
        textformat.align = TextFormatAlign.LEFT;
        textformat.size = 32 * oflScaleY;
        textformat.color = 0xffff00;

        textfield.defaultTextFormat = textformat;

        textfield.embedFonts = true;
        //textfield.defaultTextFormat = new TextFormat(fontName, 32 * oflScaleY, 0xffffff, TextFormatAlign.CENTER);
        textfield.type = TextFieldType.INPUT;
        textfield.x = 240 * oflScaleX;
        textfield.y = calculateRow(8) * oflScaleY;
        textfield.background = true;
        textfield.backgroundColor = 0xff0000ff;
        textfield.width = 240 * oflScaleX;
        textfield.height = 40 * oflScaleY;
        textfield.border = true;
        textfield.borderColor = 0xff000000;

        textfield.maxChars = 9;
        textfield.autoSize = TextFieldAutoSize.LEFT;
        textfield.text = " ";

        //textfield.type = TextFieldType.INPUT;
        //textfield.textColor = 0x000000;
        //textfield.border = true;
        //textfield.borderColor = 0xFFFF00;
        //textfield.background = true;
        //textfield.backgroundColor = 0xFFFFFF;
        //textfield.width = 200;
        //textfield.height = 40;
        //textfield.setTextFormat(new TextFormat(null, 32));
        trace("OpenFl display width: " + Lib.current.stage.stageWidth + " display height: " + Lib.current.stage.stageHeight);

        //Mobile stuff
        #if (android || ios)
        textfield.needsSoftKeyboard = true;
                //This should work in "next" i think, but causes a compiler error legacy
        //textfield.softKeyboardInputAreaOfInterest = new Rectangle(540, 440, 200, 40);
                //This does not have any effect afaik (available on legacy only)
        textfield.moveForSoftKeyboard = true;
        #end

        FlxG.addChildBelowMouse(textfield);
        FlxG.stage.focus = textfield;
        //textfield.setSelection(0, textfield.text.length);
        textfield.visible = true;


        //add(textfield);

        var submitButton = new FlxButton(0, calculateRow(8), "OK", function() {
            //trace("Text is " + inputText.text);
            trace("TextField is " + textfield.text);
            FlxG.removeChild(textfield);
            var scoreState:ScoreState = new ScoreState();
            scoreState.playerData.name = textfield.text;
            scoreState.playerData.score = Reg.score = 1100;
            FlxG.switchState(scoreState);
        });
        submitButton.makeGraphic(Std.int(40.0 * oflScaleX), Std.int(40.0 * oflScaleY), FlxColor.BLACK);
        //submitButton.color = 0x0000ff;
        submitButton.label.color = 0xffffff;
        submitButton.label.setFormat(null, 18, 0xffffff, "center");
        //submitButton.width = 40;
        //submitButton.height = 40;
        //submitButton.setSize(40 * oflScaleY, 40 * oflScaleY);
        submitButton.x = 400 * oflScaleX;
        submitButton.scrollFactor.set();
        //submitButton.y = calculateRow(8);
        add(submitButton);
    }
}
