package;

import flixel.system.FlxAssets.FlxGraphicAsset;

class Log extends WrappingSprite
{
	public static inline var TYPE_A = 0;
	public static inline var TYPE_B = 1;
	public static inline var TYPE_C = 2;

	public static inline var TYPE_A_WIDTH = 100;
	public static inline var TYPE_B_WIDTH = 200;
	public static inline var TYPE_C_WIDTH = 150;

	private var blueFroggy:BlueFrog = null;
	private var firstSetX:Bool = false;
	var _moveRight:Bool;
	var _moveLeft:Bool;

	/**
	 * Simple sprite to represent a log. There are 3 types of logs, represented by TYPE_A, _B, and
	 * _C constant.
	 *
	 * @param x start X
	 * @param y start Y
	 * @param type type of car to use. Type_A, _b, _c, and _d are referenced as constants on the class
	 * @param direction the direction the sprite will move in
	 * @param speed the speed in pixels in which the sprite will move on update
	 */
	public function new(x:Float, y:Float, type:Int, dir:Int, speed:Int, blueFrog:BlueFrog)
	{
		var simpleGraphic:FlxGraphicAsset = null;

		switch (type)
		{
			case TYPE_A:
				simpleGraphic = "assets/images/log_short.png";
			case TYPE_B:
				simpleGraphic = "assets/images/log_long.png";

			case TYPE_C:
				simpleGraphic = "assets/images/log_mid.png";
		}

		super(x, y, simpleGraphic, dir, speed);
		_moveRight = true;
		_moveLeft = false;

		if (blueFrog != null)
			blueFroggy = blueFrog;
		else
			blueFroggy = null;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (blueFroggy != null)
		{
			if (!isOnScreen())
				blueFroggy.x = x;
			if (_moveRight)
			{
				blueFroggy.facing = RIGHT;
				blueFroggy.angle = 90;
				blueFroggy.x += 2;
				if (blueFroggy.x > x + width - blueFroggy.width)
				{
					blueFroggy.x = x + width - blueFroggy.width;
					_moveRight = false;
					_moveLeft = true;
				}
			}
			if (_moveLeft)
			{
				blueFroggy.facing = LEFT;
				blueFroggy.angle = -90;
				blueFroggy.x -= 2;
				if (blueFroggy.x < x)
				{
					blueFroggy.x = x;
					_moveLeft = false;
					_moveRight = true;
				}
			}
		}

		// if (blueFroggy != null)
		// {
		// 	if (!firstSetX)
		// 	{
		// 		blueFroggy.facing = RIGHT;
		// 		blueFroggy.angle = 90;
		// 		blueFroggy.x = x + elapsed * 50;
		// 		blueFroggy.y = y + elapsed * 50;
		// 		firstSetX = true;
		// 	}
		// 	else
		// 	{
		// 		if (blueFroggy.x + blueFroggy.width < x + width)
		// 			blueFroggy.x += 1.5;
		// 		else
		// 		{
		// 			blueFroggy.facing = LEFT;
		// 			blueFroggy.angle = -90;
		// 			blueFroggy.x -= 1.5;
		// 		}
		// 	}
		// }

		// testSprite.x = x;
		// testSprite.y = y;
	}
}
