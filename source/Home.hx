package ;
import flixel.math.FlxRandom;
class Home extends TimerSprite
{

    public static inline var SPRITE_WIDTH = 64;
    public static inline var SPRITE_HEIGHT = 64;
    public static inline var BONUS = 0;
    public static inline var NO_BONUS = 1;
    public static inline var SUCCESS = 2;
    public static inline var EMPTY = 3;
    public var mode:UInt;
    public var odds:UInt;
    var rand:FlxRandom = new FlxRandom();

    /**
         * Home represents the sprite the player lands on to score points and help complete a level.
         * The home has 4 states Empty, Success, No Bonus, and Bonus
         *
         * @param x start X
         * @param y start Y
         * @param delay This represents the amount of time before toggling active/deactivate
         * @param startTime where the timer should start. Pass in -1 to disable the timer.
         * @param odds the randomness that one of the 3 states will be reached (empty, bonus, or no bonus)
         */
    public function new(x:Float, y:Float, delay:Int = 400, startTime:Int = 400, odds:Int = 10)
    {
        super(x, y, null, delay, startTime, 0, 0);

        this.odds = odds;

        loadGraphic("assets/images/home64.png", true, SPRITE_WIDTH, SPRITE_HEIGHT);
        animation.add("empty", [3], 0, false);
        animation.add("bonus", [1], 0, false);
        animation.add("noBonus", [0], 0, false);
        animation.add("success", [2], 0, false);

        animation.play("empty");

    }

    override function onDeactivate():Void
    {
        super.onDeactivate();
        setMode(EMPTY, "empty");
    }

    /**
         * On active draw a random number based on the odds and see what state should be shown.
         */
    override function onActivate():Void
    {
        super.onActivate();


        //var id:UInt = Math.random() * odds;
        var id:UInt = rand.int(0, odds);
        //trace("id:" + id);

        switch (id)
        {
            case(BONUS):
                setMode(BONUS, "bonus");
            case(NO_BONUS):
                setMode(NO_BONUS, "noBonus");
            default:
                setMode(EMPTY, "empty");
        }
    }

    /**
         * Show success state
         */
    public function success():Void
    {
        trace("I am Home");
        animation.play("success");
        this.mode = SUCCESS;
        //this.state._score += ScoreValues.REACH_HOME;
        Reg.score += ScoreValues.REACH_HOME;
        //FlxG.score += ScoreValues.REACH_HOME;
        timer = -1;
    }

    /**
         * Reset the sprite to the empty state and restart the timer.
         */
    public function empty():Void
    {
        setMode(EMPTY, "empty");
        timer = hideTimer;
    }

    /**
         * private method to set the state of the sprite.
         *
         * @param mode what mode should the sprite be in Empty, Bonus, No Bonus or Success
         * @param animationSet What animation set should it use to display the state
         */
    function setMode(mode:Int, animationSet:String):Void
    {
        //TODO This should be consolidated to use the same mode int
        this.mode = mode;
        animation.play(animationSet);
    }

}
