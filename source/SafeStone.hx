package ;
class SafeStone extends TimerSprite
{

    public static inline var SPRITE_WIDTH = 40;
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
    public function new(x:Float, y:Float, delay:Int = 300, startTime:Int = 300, dir:Int = 0x10, speed:Int = 0)
    {
        super(x, y, null, delay, startTime, dir, speed);

        loadGraphic("assets/images/lava_safe_stone1.png", true, SPRITE_WIDTH, SPRITE_HEIGHT);

        animation.add("idle", [0, 1, 2], 3, true);
        animation.add("hide", [3, 4, 5], 3, false);
        animation.add("show", [5, 4, 3, 0], 3, false);
    }

    /**
         * Checks to see what frame the turtle is on and can be used to see if turtle is underwater or not.
         * @return if frog is totally underwater it will return false, if not true
         */
    override public function get_isActive():Bool
    {
        return (animation.frameIndex == 5) ? false : true;
    }

    /**
         * Makes turtle appear out of water.
         */
    override function onActivate():Void
    {
        super.onActivate();
        animation.play("show");
    }

    /**
         * Makes turtle go underwater
         */
    override function onDeactivate():Void
    {
        super.onDeactivate();
        animation.play("hide");
    }
    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
        if(animation.frameIndex == 0)
            animation.play("idle");

    }

}
