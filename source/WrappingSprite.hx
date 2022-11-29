package;

import Car1;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxObject;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

class WrappingSprite extends FlxSprite
{
	var leftBounds:Int;
	var rightBounds:Int;
	var state:PlayState;

	public var speed:Float;

	/**
	 * This is a base class for any sprite that needs to wrap arround the screen when it goes out of
	 * bounds. This kind of sprite watches for when it is off screen the resets it's X position to
	 * the opposite site based on it's direction.
	 *
	 * @param X start X
	 * @param Y start Y
	 * @param SimpleGraphic Use for sprites with no animations
	 * @param dir Direction, supports Right (1) and Left (0)
	 * @param speed how many pixel sprite will move each update.
	 */
	public function new(X:Float = 0, Y:Float = 0, ?SimpleGraphic:FlxGraphicAsset = null, dir:Int, speed:Float = 1)
	{
		super(X, Y, SimpleGraphic);
		this.leftBounds = 0;
		this.rightBounds = FlxG.width;

		this.speed = speed;

		facing = dir;

		state = Reg.PS;
	}

	/**
	 * This update methods analyzes the direction and x position of the instance to see if it should
	 * be repositioned to the opposite side of the screen. If instance is facing right, it will restart
	 * on the left of the screen. The opposite will happen for anything facing left.
	 */
	override public function update(elapsed:Float):Void
	{
		// Make sure the game state is Playing. If not exit out of update since we should be paused.
		if (state.gameState != GameStates.PLAYING)
		{
			return;
		}
		else
		{
			// trace("Update:" + elapsed);
			// Add speed to instance's x based on direction
			x += (facing == LEFT) ? -speed : speed;
			// trace("x:" + x + " facing:" + facing + " speed:" + speed);

			// Check to see if instance is out of bounds. If so, put it on the opposite side of the screen
			if (x > (rightBounds))
			{
				if (facing == RIGHT)
				{
					x = leftBounds - frameWidth;
				}
			}
			else if (x < (leftBounds - frameWidth))
			{
				{
					x = rightBounds + frameWidth;
				}
			}
		}

		// Call update
		super.update(elapsed);
	}
}
