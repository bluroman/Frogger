package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;

/**
 * Class declaration for the blue frog class
 */
class BlueFrog extends FlxSprite
{
	/**
	 * A simple timer for deciding when to shoot
	 */
	private var _shotClock:Float;

	/**
	 * Saves the starting horizontal position (for movement logic)
	 */
	private var _originalX:Int;

	// private var _log:Log;
	var _moveRight:Bool;
	var _moveLeft:Bool;

	/**
	 * This is the constructor for the blue froggy.
	 * We are going to set up the basic values and then create a simple animation.
	 */
	public function new(X:Float, Y:Float, Color:Int)
	{
		// Initialize sprite object
		super(X, Y);
		// Load this animated graphic file
		loadGraphic("assets/images/frog2_sprites.png", true, 40, 40);
		// Setting the color tints the plain white alien graphic
		color = Color;
		// _originalX = Std.int(log.x);
		// _log = log;
		// resetShotClock();
		// x = _log.x;
		// y = _log.y;
		_moveRight = true;
		_moveLeft = false;

		// Time to create a simple animation! "alien.png" has 3 frames of animation in it.
		// We want to play them in the order 1, 2, 3, 1 (but of course this stuff is 0-index).
		// To avoid a weird, annoying appearance the framerate is randomized a little bit
		// to a value between 6 and 10 (6+4) frames per second.
		this.animation.add("Default", [0, 1], 10, true);

		// Now that the animation is set up, it's very easy to play it back!
		this.animation.play("Default");

		// Everybody move to the right!
		// velocity.x = 10;
	}

	/**
	 * Basic game loop is BACK y'all
	 */
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		// if (!_log.isOnScreen())
		// 	x = _log.x;
		// // x = _log.x;
		// // y = _log.y;
		// if (_moveRight)
		// {
		// 	facing = RIGHT;
		// 	angle = 90;
		// 	x += 3;
		// 	if (x > _log.x + _log.width - width)
		// 	{
		// 		x = _log.x + _log.width - width;
		// 		_moveRight = false;
		// 		_moveLeft = true;
		// 	}
		// }
		// if (_moveLeft)
		// {
		// 	facing = LEFT;
		// 	angle = -90;
		// 	x -= 1;
		// 	if (x < _log.x)
		// 	{
		// 		x = _log.x;
		// 		_moveLeft = false;
		// 		_moveRight = true;
		// 	}
		// }

		//        if (x < _log.x)
		//            x = _log.x;
		//        else
		//            x += 3;
		//
		//        if ( x > _log.x + _log.width - width)
		//            x = _log.x + _log.width - width;
		//        else
		//            x -= 3;

		// x += (_log.facing == FlxObject.LEFT) ? -_log.speed : _log.speed;
		// If alien has moved too far to the left, reverse direction and increase speed!
		//        if (x < _originalX - 8)
		//        {
		//            x = _originalX - 8;
		//            velocity.x = -velocity.x;
		//            //velocity.y++;
		//        }
		//
		//        // If alien has moved too far to the right, reverse direction
		//        if (x > _originalX + 8)
		//        {
		//            x = _originalX + 8;
		//            velocity.x = -velocity.x;
		//        }

		// Then do some bullet shooting logic
		//        if (y > FlxG.height * 0.35)
		//        {
		//            // Only count down if on the bottom two-thirds of the screen
		//            _shotClock -= elapsed;
		//        }
		//
		//        if (_shotClock <= 0)
		//        {
		//            // We counted down to zero, so it's time to shoot a bullet!
		//            resetShotClock();
		//            var playState:PlayState = cast FlxG.state;
		//            var bullet = playState.alienBullets.recycle();
		//            bullet.reset(x + width / 2 - bullet.width / 2, y);
		//            bullet.velocity.y = 65;
		//        }
	}

	/**
	 * This function just resets our bullet logic timer to a random value between 1 and 11
	 */
	//    private function resetShotClock():Void
	//    {
	//        _shotClock = 1 + FlxG.random.float() * 10;
	//    }
}
