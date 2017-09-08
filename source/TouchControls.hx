package ;
import flixel.FlxObject;
import flixel.math.FlxPoint;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.FlxState;
import flixel.group.FlxGroup;
class TouchControls extends FlxTypedSpriteGroup<FlxSprite>
{
    /*private var spriteButtons[0]:FlxSprite;
         private var spriteButtons[1]:FlxSprite;
         private var spriteButtons[2]:FlxSprite;
         private var spriteButtons[3]:FlxSprite;*/
    var ButtonsUp:FlxSprite;
    var ButtonsDown:FlxSprite;
    var ButtonsRight:FlxSprite;
    var ButtonsLeft:FlxSprite;
    private var spriteButtons = [];
    var tmpBool:Bool;

    /**
         * Touch controls are special buttons that allow virtual input for the game on devices without a keyboard.
         *
         * @param target Where should the controls be added onto
         * @param x x position to display the controls
         * @param y y position to display the controls
         * @param padding space between each button
         */
    public function new(target:FlxState, x:Int, y:Int, padding:Int)
    {
        super(this.x, this.y);

        this.x = x;
        this.y = y;

        var txt:FlxText;
        //spriteButtons = new Array();
        //spriteButtons = new Array();

            //spriteButtons[0] = new FlxSprite(x, y)
        ButtonsUp = new FlxSprite(0, 0);
        ButtonsUp.color = 0x999999;
        ButtonsUp.makeGraphic(100, 100);
        add(ButtonsUp);
        //spriteButtons.push(ButtonsUp);
        txt = new FlxText(0, 30, 100, "UP").setFormat(null, 20, 0xffffff, "center");
        add(txt);

        ButtonsDown = new FlxSprite(ButtonsUp.width + padding, 0);
        ButtonsDown.color = 0x999999;
        ButtonsDown.makeGraphic(100, 100);
        add(ButtonsDown);
        //spriteButtons.push(ButtonsDown);
        txt = new FlxText(ButtonsDown.x, 30, 100, "DOWN").setFormat(null, 20, 0xffffff, "center");
        add(txt);

        ButtonsLeft = new FlxSprite(ButtonsDown.x + ButtonsDown.width + padding, 0);
        ButtonsLeft.color = 0x999999;
        ButtonsLeft.makeGraphic(100, 100);
        add(ButtonsLeft);
        //spriteButtons.push(ButtonsLeft);
        txt = new FlxText(ButtonsLeft.x, 30, 100, "LEFT").setFormat(null, 20, 0xffffff, "center");
        add(txt);

        ButtonsRight = new FlxSprite(ButtonsLeft.x + ButtonsLeft.width + padding, 0);
        ButtonsRight.color = 0x999999;
        ButtonsRight.makeGraphic(100, 100);
        add(ButtonsRight);
        //spriteButtons.push(ButtonsRight);
        txt = new FlxText(ButtonsRight.x, 30, 100, "RIGHT").setFormat(null, 20, 0xffffff, "center");
        add(txt);


    }

    public function justPressed(buttonIndex:UInt):Bool
    {
        tmpBool = false;
        var pressedButton:FlxObject = null;
        switch(buttonIndex)
        {
            case 0:
                pressedButton = ButtonsUp;
            case 1:
                pressedButton = ButtonsDown;
            case 2:
                pressedButton = ButtonsLeft;
            case 3:
                pressedButton = ButtonsRight;
        }
        //var pt:FlxPoint = new FlxPoint(FlxG.mouse.x, FlxG.mouse.y);
        tmpBool = FlxG.mouse.justPressed && pressedButton.overlapsPoint(FlxG.mouse.getPosition());
        //return FlxG.mouse.justPressed();
        return tmpBool;
    }

    public function justReleased(buttonIndex:UInt):Bool
    {
        var pressedButton:FlxObject = null;
        switch(buttonIndex)
        {
            case 0:
                pressedButton = ButtonsUp;
            case 1:
                pressedButton = ButtonsDown;
            case 2:
                pressedButton = ButtonsLeft;
            case 3:
                pressedButton = ButtonsRight;
        }
        return FlxG.mouse.justReleased && pressedButton.overlapsPoint(FlxG.mouse.getPosition());
    }

    override public function update(elapsed:Float):Void
    {

        if (FlxG.mouse.justPressed)
        {
            if (ButtonsUp.overlapsPoint(FlxG.mouse.getPosition()))
            {
                ButtonsUp.color = 0xff0000;
            } else if (ButtonsDown.overlapsPoint(FlxG.mouse.getPosition()))
            {
                ButtonsDown.color = 0xff0000;
            } else if (ButtonsLeft.overlapsPoint(FlxG.mouse.getPosition()))
            {
                ButtonsLeft.color = 0xff0000;
            } else if (ButtonsRight.overlapsPoint(FlxG.mouse.getPosition()))
            {
                ButtonsRight.color = 0xff0000;
            }


        }
        else if (FlxG.mouse.justReleased)
        {
            ButtonsUp.color = 0x999999;
            ButtonsDown.color = 0x999999;
            ButtonsLeft.color = 0x999999;
            ButtonsRight.color = 0x999999;
        }

        super.update(elapsed); //uncommenting this breaks it. dont know why.

    }
}
