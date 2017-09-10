package ;
import flixel.FlxObject;
import flixel.FlxObject;
import flixel.FlxG;
import openfl.geom.Point;
import flixel.FlxSprite;
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

    public var touchControls:TouchControls;

    //TODO this should probably extend Wrapping Sprite and override the off screen logic
    /**
         * The Frog represents the main player's character. This class contains all of the move, animation,
         * and some special collision logic for the Frog.
         *
         * @param X start X
         * @param Y start Y
         */
    public function new(X:Float, Y:Float, parentState:PlayState)
    {
        super(X, Y);

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
        loadGraphic(AssetPaths.frog1_sprites__png, true, 40, 40);

        animation.add("idle" + FlxObject.UP, [0], 0, false);
        animation.add("idle" + FlxObject.RIGHT, [2], 0, false);
        animation.add("idle" + FlxObject.DOWN, [4], 0, false);
        animation.add("idle" + FlxObject.LEFT, [6], 0, false);
        animation.add("walk" + FlxObject.UP, [0,1], 15, true);
        animation.add("walk" + FlxObject.RIGHT, [2,3], 15, true);
        animation.add("walk" + FlxObject.DOWN, [4,5], 15, true);
        animation.add("walk" + FlxObject.LEFT, [6,7], 15, true);
        animation.add("die_water", [8, 9, 10, 11], 3, false);
        animation.add("die_road", [12, 13, 14, 15], 3, false);

            // Set facing direction
        //facing = FlxObject.UP;
        set_facing(FlxObject.UP);

            // Save an instance of the PlayState to help with collision detection and movement
        state = parentState;
    }

    /**
         * This manage what direction the frog is facing. It also alters the bounding box around the sprite.
         *
         * @param value
         */
    override public function set_facing(value:UInt):Int
    {
        super.facing = value;

        if (value == FlxObject.UP || value == FlxObject.DOWN)
        {
            width = 32;
            height = 25;
            offset.x = 4;
            offset.y = 6;
        }
        else
        {
            width = 25;
            height = 32;
            offset.x = 6;
            offset.y = 4;
        }
        return value;
    }

    /**
         * The main Frog update loop. This handles keyboard movement, collision and flagging id moving.
         */
    override public function update(elapsed:Float):Void
    {

            // Test to see if the frog is dead and at the last death frame
        //if(state.gameState == GameStates.COLLISION)
        //    trace("Frame:" + animation.frameIndex);
        if (state.gameState == GameStates.COLLISION && ((animation.frameIndex == 11) || (animation.frameIndex ==15)))
        {
            // Flag game state that death animation is over and game can perform a restart
            state.gameState = GameStates.DEATH_OVER;
        }
        else if (state.gameState == GameStates.PLAYING)
        {
            // Test to see if TargetX and Y are equil. If so, Frog is free to move.
            if (x == targetX && y == targetY)
            {
                // Checks to see what key was just pressed and sets the target X or Y to the new position
                // along with what direction to face
                if ((FlxG.keys.justPressed.LEFT || (touchControls != null && touchControls.justPressed(2))) && x > 0)
                {
                    targetX = x - maxMoveX;
                    set_facing(FlxObject.LEFT);
                    //facing = FlxObject.LEFT;
                }
                else if ((FlxG.keys.justPressed.RIGHT || (touchControls != null && touchControls.justPressed(3))) && x < FlxG.width - frameWidth)
                {
                    targetX = x + maxMoveX;
                    set_facing(FlxObject.RIGHT);
                    //facing = FlxObject.RIGHT;
                }
                else if ((FlxG.keys.justPressed.UP || (touchControls != null && touchControls.justPressed(0))) && y > frameHeight)
                {
                    targetY = y - maxMoveY;
                    set_facing(FlxObject.UP);
                    //facing = FlxObject.UP;
                }
                else if ((FlxG.keys.justPressed.DOWN || (touchControls != null && touchControls.justPressed(1))) && y < 560)
                {
                    targetY = y + maxMoveY;
                    set_facing(FlxObject.DOWN);
                    //facing = FlxObject.DOWN;
                }

                    // See if we are moving
                if (x != targetX || y != targetY)
                {
                    //Looks like we are moving so play sound, flag isMoving and add to score.
                    //FlxG.play(GameAssets.FroggerHopSound);
                    FlxG.sound.play("Hop");

                    // Once this flag is set, the frog will not take keyboard input until it has reacged it's target
                    isMoving = true;

                    // Add to score for moving
                    //state._score += ScoreValues.STEP;
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
                if (facing == FlxObject.LEFT)
                {
                    x -= moveX;
                }
                else if (facing == FlxObject.RIGHT)
                {
                    x += moveX;
                }
                else if (facing == FlxObject.UP)
                {
                    y -= moveY;
                }
                else if (facing == FlxObject.DOWN)
                {
                    y += moveY;
                }

                // Play the walking animation
                animation.play("walk" + facing);

            }
            else
            {
                // nothing is happening so go back to idle animation
                animation.play("idle" + facing);
            }

        }

            //Default object physics update
        super.update(elapsed);
    }

    /**
         * Simply plays the death animation
         */
    public function death(isWater:Bool):Void
    {
        //TODO this should probably contain the logic for playing the death sound. Will need to know if it water or car
        if(isWater)
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
        set_facing(FlxObject.UP);
        //facing = FlxObject.UP;
        animation.play("idle" + facing);
        if (!visible) visible = true;

    }

    /**
         * This handles moving the Frog in the same direction as any instance it is resting on.
         *
         * @param speed the speed in pixels the Frog should move
         * @param facing the direction the frog will float in
         */
    public function float(speed:Int, facing:UInt):Void
    {
        if (isMoving != true)
        {
            x += (facing == FlxObject.RIGHT) ? speed : -speed;
            targetX = x;
            isMoving = true;
        }
    }
}
