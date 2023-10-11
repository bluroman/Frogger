package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxDirectionFlags;
import haxe.io.Input;
import openfl.geom.Point;

class Frog extends FlxSprite
{
	private var startPosition:Point;
	private var moveX:Int;
	private var maxMoveX:Int;
	private var maxMoveY:Int;
	private var targetX:Float;
	private var targetY:Float;
	private var animationFrames:Int = 8;
	private var moveY:Int;
	private var state:PlayState;

	public var isMoving:Bool;

	// public var touchControls:TouchControls;
	// TODO this should probably extend Wrapping Sprite and override the off screen logic

	/**
	 * The Frog represents the main player's character. This class contains all of the move, animation,
	 * and some special collision logic for the Frog.
	 *
	 * @param X start X
	 * @param Y start Y
	 */
	public function new(X:Float, Y:Float)
	{
		super(X, Y);

		// touchControls = null;

		// Save the starting position to be used later when restarting
		startPosition = new Point(X, Y);

		// Calculate amount of pixels to move each turn
		moveX = 5;
		moveY = 5;
		maxMoveX = moveX * animationFrames;
		maxMoveY = moveY * animationFrames;

		// Set frog's target x,y to start position so he can move
		targetX = X;
		targetY = Y;

		// Set up sprite graphics and animations
		loadGraphic("assets/images/frog_sprite_new5.png", true, 40, 40);
		// loadRotatedGraphic(AssetPaths.frog_sprite_new__png, 4, 0);

		// animation.add("idle" + FlxObject.UP, [0], 0, false, true, false);
		// animation.add("idle" + FlxObject.RIGHT, [0], 0, false);
		animation.add("idle" + FlxDirectionFlags.DOWN, [0], 0, false);
		animation.add("idle" + FlxDirectionFlags.LEFT, [2], 0, false);
		animation.add("walk" + FlxDirectionFlags.DOWN, [0, 1], 15, true);
		animation.add("walk" + FlxDirectionFlags.LEFT, [2, 3], 15, true);
		animation.add("idle" + FlxDirectionFlags.UP, [0], 0, false, false, true);
		animation.add("idle" + FlxDirectionFlags.RIGHT, [2], 0, false, true, false);
		animation.add("walk" + FlxDirectionFlags.UP, [0, 1], 15, true, false, true);
		animation.add("walk" + FlxDirectionFlags.RIGHT, [2, 3], 15, true, true, false);
		// animation.add("idle" + FlxObject.LEFT, [0], 0, false);
		// animation.add("walk" + FlxObject.UP, [0,1], 15, true);
		// animation.add("walk" + FlxObject.RIGHT, [2,3], 15, true);
		// animation.add("walk", [1, 2, 3, 3,  4, 4, 4, 5,5,  2, 1], 15, true);
		// animation.add("walk" + FlxObject.LEFT, [6,7], 15, true);
		animation.add("die_water", [5, 6, 7, 8, 9, 4, 4], 3, false);
		animation.add("die_road", [10, 10, 10, 4], 3, false);
		// offset.set(20, 20);

		// Set facing direction
		// facing = FlxObject.UP;
		// angle = 180;
		set_facing(UP);
		animation.play("idle" + facing);
		// width = 38;
		// height = 26;
		// centerOffsets();

		// Save an instance of the PlayState to help with collision detection and movement
		state = Reg.PS;
	}

	/**
	 * This manage what direction the frog is facing. It also alters the bounding box around the sprite.
	 *
	 * @param value
	 */
	override public function set_facing(value:Int):Int
	{
		super.facing = value;

		// if (value == FlxDirectionFlags.UP || value == FlxDirectionFlags.DOWN)
		// {
		// 	width = 38;
		// 	height = 26;
		// 	// centerOffsets(true);
		// 	// centerOffsets();
		// 	// setGraphicSize(38, 26);
		// 	// updateHitbox();
		// 	// offset.set(20, 20);
		// 	// offset.x = 1;
		// 	// offset.y = 7;
		// 	// if (value == FlxObject.UP)
		// 	//    angle = 180;
		// 	// else
		// 	//    angle = 0;
		// }
		// else
		// {
		// 	// if(value == FlxObject.LEFT)
		// 	//   angle = 90;
		// 	// else
		// 	//    angle = 270;
		// 	width = 26;
		// 	height = 38;
		// 	// centerOffsets(true);
		// 	// centerOffsets();
		// 	// setGraphicSize(26, 38);
		// 	// updateHitbox();
		// 	// offset.set(20, 20);
		// 	// offset.x = 7;
		// 	// offset.y = 1;
		// }
		return value;
	}

	/**
	 * The main Frog update loop. This handles keyboard movement, collision and flagging id moving.
	 */
	override public function update(elapsed:Float):Void
	{
		// Test to see if the frog is dead and at the last death frame
		// if(state.gameState == GameStates.COLLISION)
		//    trace("Frame:" + animation.frameIndex);
		if (state.gameState == GameStates.COLLISION)
		{
			if (animation.curAnim.name == "die_water" || animation.curAnim.name == "die_road")
			{
				if (animation.curAnim.finished)
					state.gameState = GameStates.DEATH_OVER;
			}
			// Flag game state that death animation is over and game can perform a restart
			// state.gameState = GameStates.DEATH_OVER;
		}
		else if (state.gameState == GameStates.PLAYING)
		{
			// Test to see if TargetX and Y are equil. If so, Frog is free to move.
			if (x == targetX && y == targetY)
			{
				// Checks to see what key was just pressed and sets the target X or Y to the new position
				// along with what direction to face
				// #if desktop
				// if ((FlxG.keys.justPressed.LEFT || (touchControls != null && touchControls.justPressed(2))) && x > 0)
				// #end
				// #if mobile
				// if (((touchControls != null && touchControls.justPressed(2))) && x > 0)
				if (Input.on.LEFT && x > 0)
					// #end
				{
					targetX = x - maxMoveX;
					set_facing(FlxDirectionFlags.LEFT);
					// facing = FlxObject.LEFT;
				}
					// #if desktop
					// else if ((FlxG.keys.justPressed.RIGHT || (touchControls != null && touchControls.justPressed(3)))
					//	&& x < FlxG.width - frameWidth)
					// #end
					// #if mobile
				// else if (((touchControls != null && touchControls.justPressed(3))) && x < FlxG.width - frameWidth)
				else if (Input.on.RIGHT && x < FlxG.width - frameWidth)
					// #end
				{
					targetX = x + maxMoveX;
					set_facing(FlxDirectionFlags.RIGHT);
					// facing = FlxObject.RIGHT;
				}
					// #if desktop
					// else if ((FlxG.keys.justPressed.UP || (touchControls != null && touchControls.justPressed(0))) /*&& y > frameHeight*/)
					// #end
					// #if mobile
				// else if (((touchControls != null && touchControls.justPressed(0))) && y > frameHeight)
				else if (Input.on.UP && y > frameHeight)
					// #end
				{
					targetY = y - maxMoveY;
					set_facing(FlxDirectionFlags.UP);
					// facing = FlxObject.UP;
				}
					// #if desktop
					// else if ((FlxG.keys.justPressed.DOWN || (touchControls != null && touchControls.justPressed(1))) && y < 1360)
					// #end
					// #if mobile
				// else if (((touchControls != null && touchControls.justPressed(1))) && y < 1360)
				else if (Input.on.DOWN && y < 1360)
					// #end
				{
					targetY = y + maxMoveY;
					set_facing(FlxDirectionFlags.DOWN);
					// facing = FlxObject.DOWN;
				}

				// See if we are moving
				if (x != targetX || y != targetY)
				{
					// Looks like we are moving so play sound, flag isMoving and add to score.
					// FlxG.play(GameAssets.FroggerHopSound);
					FlxG.sound.play("Hop");

					// Once this flag is set, the frog will not take keyboard input until it has reacged it's target
					isMoving = true;

					// Add to score for moving
					// state._score += ScoreValues.STEP;
					Reg.score += ScoreValues.STEP;
				}
				else
				{
					// Nope, we are not moving so flag isMoving and show Idle.
					isMoving = false;
				}
			}

			// If isMoving is true we are going to update the actual position.
			if (isMoving == true)
			{
				if (facing == FlxDirectionFlags.LEFT)
				{
					x -= moveX;
				}
				else if (facing == FlxDirectionFlags.RIGHT)
				{
					x += moveX;
				}
				else if (facing == FlxDirectionFlags.UP)
				{
					y -= moveY;
				}
				else if (facing == FlxDirectionFlags.DOWN)
				{
					y += moveY;
				}

				// Play the walking animation
				// trace("walking animation");
				// trace("frame height:" + + " width:" + frameWidth);
				animation.play("walk" + facing);
			}
			else
			{
				// nothing is happening so go back to idle animation
				animation.play("idle" + facing);
			}
		}

		// Default object physics update
		super.update(elapsed);
	}

	/**
	 * Simply plays the death animation
	 */
	public function death(isWater:Bool):Void
	{
		// TODO this should probably contain the logic for playing the death sound. Will need to know if it water or car
		angle = 0;
		if (isWater)
			animation.play("die_water");
		else
			animation.play("die_road");
	}

	/**
	 * This resets core values of the Frog instance.
	 */
	public function restart():Void
	{
		isMoving = false;
		x = startPosition.x;
		y = startPosition.y;
		targetX = startPosition.x;
		targetY = startPosition.y;
		set_facing(FlxDirectionFlags.UP);
		// facing = FlxObject.UP;
		animation.play("idle" + facing);
		if (!visible)
			visible = true;
	}

	/**
	 * This handles moving the Frog in the same direction as any instance it is resting on.
	 *
	 * @param speed the speed in pixels the Frog should move
	 * @param facing the direction the frog will float in
	 */
	public function float(speed:Float, facing:Int):Void
	{
		if (isMoving != true)
		{
			x += (facing == FlxDirectionFlags.RIGHT) ? speed : -speed;
			targetX = x;
			isMoving = true;
		}
	}
}
