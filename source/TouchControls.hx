package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

class TouchControls extends FlxTypedSpriteGroup<FlxSprite>
{
	/*private var spriteButtons[0]:FlxSprite;
		private var spriteButtons[1]:FlxSprite;
		private var spriteButtons[2]:FlxSprite;
		private var spriteButtons[3]:FlxSprite; */
	var ButtonsUp:FlxSprite;
	var ButtonsDown:FlxSprite;
	var ButtonsRight:FlxSprite;
	var ButtonsLeft:FlxSprite;
	private var spriteButtons = [];
	var tmpBool:Bool;
	var ButtonsTest:FlxButton;

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
		// spriteButtons = new Array();
		// spriteButtons = new Array();

		// spriteButtons[0] = new FlxSprite(x, y)
		ButtonsUp = new FlxSprite(0, 0);
		// ButtonsUp.color = 0x999999;
		// ButtonsUp.makeGraphic(100, 100);
		ButtonsUp.loadGraphic("assets/images/touchUp.png", 100, 100);
		add(ButtonsUp);
		// txt = new FlxText(0, 30, 100, "UP").setFormat(null, 20, 0xffffff, "center");
		// add(txt);

		ButtonsDown = new FlxSprite(100, 0);
		// ButtonsDown.color = 0x999999;
		// ButtonsDown.makeGraphic(100, 100);
		ButtonsDown.loadGraphic("assets/images/touchDown.png", 100, 100);
		add(ButtonsDown);
		// txt = new FlxText(ButtonsDown.x, 30, 100, "DOWN").setFormat(null, 20, 0xffffff, "center");
		// add(txt);

		ButtonsLeft = new FlxSprite(480 - 200, 0);
		// ButtonsLeft.color = 0x999999;
		// ButtonsLeft.makeGraphic(100, 100);
		ButtonsLeft.loadGraphic("assets/images/touchLeft.png", 100, 100);
		add(ButtonsLeft);
		// txt = new FlxText(ButtonsLeft.x, 30, 100, "LEFT").setFormat(null, 20, 0xffffff, "center");
		// add(txt);

		ButtonsRight = new FlxSprite(480 - 100, 0);
		// ButtonsRight.color = 0x999999;
		// ButtonsRight.makeGraphic(100, 100);
		ButtonsRight.loadGraphic("assets/images/touchRight.png", 100, 100);
		add(ButtonsRight);
		// txt = new FlxText(ButtonsRight.x, 30, 100, "RIGHT").setFormat(null, 20, 0xffffff, "center");
		// add(txt);
		#if TEST
		ButtonsTest = new FlxButton(200, 0, "Test", testLevel);
		ButtonsTest.loadGraphic(AssetPaths.button01__png, 100, 50);
		// ButtonsTest.screenCenter();
		ButtonsTest.onUp.sound = FlxG.sound.load("Click");
		ButtonsTest.label.setFormat(null, 15, FlxColor.WHITE, "center");
		add(ButtonsTest);
		#end
		// HUD elements shouldn't move with the camera
		forEach(function(spr:FlxSprite)
		{
			spr.scrollFactor.set(0, 0);
		});
	}

	function testLevel():Void
	{
		trace("Current Speed: " + Reg.PS.actorSpeed);
		Reg.PS.levelUp();
	}

	public function justPressed(buttonIndex:UInt):Bool
	{
		tmpBool = false;
		var pressedButton:FlxObject = null;
		switch (buttonIndex)
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
		// var pt:FlxPoint = new FlxPoint(FlxG.mouse.x, FlxG.mouse.y);
		#if FLX_MOUSE
		tmpBool = FlxG.mouse.justPressed && pressedButton.overlapsPoint(FlxG.mouse.getScreenPosition());
		#end
		#if FLX_TOUCH
		for (touch in FlxG.touches.list)
		{
			// if (touch.pressed)
			{
				trace("Touch X: " + touch.x + " Touch Y: " + touch.y);
				trace("Screen X: " + touch.screenX + " Screen Y: " + touch.screenY);
				trace("Pressed Button X: " + pressedButton.x + " Width: " + pressedButton.width);
				trace("Pressed Button Y: " + pressedButton.y + " Height: " + pressedButton.height);
				// if (touch.overlaps(pressedButton))
				if (pressedButton.overlapsPoint(touch.getScreenPosition()))
				{
					tmpBool = true;
					trace("############TRUE############");
				}

				// if (pressedButton.x < touch.x && touch.x < pressedButton.x + pressedButton.width)
				// {
				// 	if (pressedButton.y < touch.screenY && touch.screenY < pressedButton.y + pressedButton.height)
				// 	{
				// 		tmpBool = true;
				// 		trace("############TRUE############");
				// 	}
				// }
			}
		}
		#end
		// return FlxG.mouse.justPressed();
		return tmpBool;
	}

	public function justReleased(buttonIndex:UInt):Bool
	{
		tmpBool = false;
		var pressedButton:FlxObject = null;
		switch (buttonIndex)
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
		#if FLX_MOUSE
		tmpBool = FlxG.mouse.justReleased && pressedButton.overlapsPoint(FlxG.mouse.getScreenPosition());
		#end
		#if FLX_TOUCH
		for (touch in FlxG.touches.list)
		{
			if (touch.justReleased && touch.overlaps(pressedButton))
				tmpBool = true;
		}
		#end
		return tmpBool;
	}

	override public function update(elapsed:Float):Void
	{
		#if FLX_MOUSE
		if (FlxG.mouse.justPressed)
		{
			if (ButtonsUp.overlapsPoint(FlxG.mouse.getScreenPosition()))
			{
				ButtonsUp.color = 0xff0000;
			}
			else if (ButtonsDown.overlapsPoint(FlxG.mouse.getScreenPosition()))
			{
				ButtonsDown.color = 0xff0000;
			}
			else if (ButtonsLeft.overlapsPoint(FlxG.mouse.getScreenPosition()))
			{
				ButtonsLeft.color = 0xff0000;
			}
			else if (ButtonsRight.overlapsPoint(FlxG.mouse.getScreenPosition()))
			{
				ButtonsRight.color = 0xff0000;
			}
		}
		else if (FlxG.mouse.justReleased)
		{
			ButtonsUp.color = 0xffffff;
			ButtonsDown.color = 0xffffff;
			ButtonsLeft.color = 0xffffff;
			ButtonsRight.color = 0xffffff;
		}
		#end
		#if FLX_TOUCH
		for (touch in FlxG.touches.list)
		{
			// if (FlxG.mouse.justPressed)
			if (touch.pressed)
			{
				// if (ButtonsUp.overlapsPoint(FlxG.mouse.getPosition()))
				if (touch.overlaps(ButtonsUp))
				{
					ButtonsUp.color = 0xff0000;
				} // else if (ButtonsDown.overlapsPoint(FlxG.mouse.getPosition()))
				else if (touch.overlaps(ButtonsDown))
				{
					ButtonsDown.color = 0xff0000;
				} // else if (ButtonsLeft.overlapsPoint(FlxG.mouse.getPosition()))
				else if (touch.overlaps(ButtonsLeft))
				{
					ButtonsLeft.color = 0xff0000;
				} // else if (ButtonsRight.overlapsPoint(FlxG.mouse.getPosition()))
				else if (touch.overlaps(ButtonsRight))
				{
					ButtonsRight.color = 0xff0000;
				}
			}
			else if (touch.justReleased)
			{
				ButtonsUp.color = 0xffffff;
				ButtonsDown.color = 0xffffff;
				ButtonsLeft.color = 0xffffff;
				ButtonsRight.color = 0xffffff;
			}
		}
		#end
		super.update(elapsed); // uncommenting this breaks it. dont know why.
	}
}
