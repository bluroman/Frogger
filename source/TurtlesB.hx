package ;
class TurtlesB extends TurtlesA
{

    public static inline var SPRITE_WIDTH = 171;
    public static inline var SPRITE_HEIGHT = 40;
    public static inline var DEFAULT_TIME = 300;

    /**
         * This represents the Turtles the player can land on.
         *
         * @param x start X
         * @param y start Y
         * @param delay This represents the amount of time before toggling active/deactivate
         * @param startTime where the timer should start. Pass in -1 to disable the timer.
         * @param speed speed in pixels the turtle will move in
         */
    public function new(x:Float, y:Float, hideTimer:Int = 300, startTime:Int = 300, dir:Int = 0x10, velocity:Int = 40)
    {
        super(x, y, hideTimer, startTime, dir, velocity);

        loadGraphic("assets/images/turtle3_sprite.png", true, SPRITE_WIDTH, SPRITE_HEIGHT);
        animation.add("idle", [0, 1, 2], 3, true);
        animation.add("hide", [3, 4, 5, 6], 3, false);
        animation.add("show", [6, 5, 4, 3, 0], 3, false);

        animation.play("idle");
    }
    override public function get_isActive():Bool
    {
        return (animation.frameIndex == 6) ? false : true;
    }
}
