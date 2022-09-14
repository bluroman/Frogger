package;

import flixel.system.FlxAssets.FlxGraphicAsset;

class LogMoving extends WrappingSprite
{
	public static inline var TYPE_A = 0;
	public static inline var TYPE_B = 1;
	public static inline var TYPE_C = 2;

	public static inline var TYPE_A_WIDTH = 100;
	public static inline var TYPE_B_WIDTH = 200;
	public static inline var TYPE_C_WIDTH = 150;

	// private var blueFroggy:BlueFrog;

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
	public function new(x:Float, y:Float, ?SimpleGraphic:FlxGraphicAsset = null, dir:Int, speed:Int)
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

		// blueFroggy = new BlueFrog(0, 0, 0xffffff);
	}
}
