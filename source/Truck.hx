package;

import flixel.FlxSprite;

class Truck extends WrappingSprite
{
	var testSprite:FlxSprite;

	/**
	 * This is a simple sprite which represents the Truck.
	 *
	 * @param X start X
	 * @param Y start Y
	 * @param dir direction the sprite will move in
	 * @param speed speed in pixels the sprite will move on update
	 */
	public function new(x:Float, y:Float, direction:Int, velocity:Int, rectangle:FlxSprite)
	{
		super(x, y, "assets/images/truck_sprite0.png", direction, velocity);
		testSprite = rectangle;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (testSprite != null)
		{
			testSprite.x = x;
			testSprite.y = y;
		}
	}
}
