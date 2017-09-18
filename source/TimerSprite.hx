package ;
import flixel.FlxG;
import flixel.system.FlxAssets.FlxGraphicAsset;
class TimerSprite extends WrappingSprite
{

    public static inline var DEFAULT_TIME = 400;

    var timer:Int;
    var hideTimer:Int;
    var _active:Bool = true;

        /**
         * The TimerSprite allows you to change states from active to inactive based on an internal timer.
         * This is useful for sprites that need to hide/show themselves at certain intervals. If you want
         * to disable the internal timer, simply pass in -1 for the start time.
         *
         * @param x start x
         * @param y start y
         * @param SimpleGraphic used for sprites that don't need to show an animation
         * @param delay this represents the delay between switching states
         * @param startTime this is the time in which the timer starts. Use -1 to disable.
         * @param dir This represents the direction the sprite will be facing
         * @param speed This is the speed in pixels the sprite will move on update
         */
    public function new(x:Float, y:Float, ?SimpleGraphic:FlxGraphicAsset = null, delay:Int = 400, startTime:Int = 400, dir:Int = 1, speed:Int = 1)
    {

        super(x, y, SimpleGraphic, dir, speed);

        this.hideTimer = delay;
        timer = startTime;
    }

        /**
         * This updates the internal timer and triggers toggle when equal to 0
         */
    override public function update(elapsed:Float):Void
    {

        if (state.gameState == GameStates.PLAYING)
        {
            if (timer > 0)
            {
                timer -= 1;
                //trace("timer:"+ timer + " elapsed:" + elapsed);
            }

            if (timer == 0)
            {
                toggle();
            }
        }

        super.update(elapsed);

    }

        /**
         * Getter returns if the instance is active or not.
         *
         * @return a boolean, true is active and false is inactive
         */
    public function get_isActive():Bool
    {
        return _active;
    }

        /**
         * This is a simple toggle between active and deactivated states.
         */
    function toggle():Void
    {
        if (!get_isActive())
        {
            onActivate();
        }
        else
        {
            onDeactivate();
        }

        timer = hideTimer;
    }

        /**
         *  Toggles the _activate variable signaling that it is no longer active.
         */
    function onDeactivate():Void
    {
        _active = false;
    }

        /**
         * Toggles the _activate variable signaling that it is now active.
         */
    function onActivate():Void
    {
        _active = true;
    }

}
