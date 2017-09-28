package ;
import flixel.FlxObject;
import flixel.math.FlxPoint;
class Alligator extends WrappingSprite{
    public static inline var SPRITE_WIDTH = 120;
    public static inline var SPRITE_HEIGHT = 40;

    /**
         * This is a simple sprite which represents Snake.
         *
         * @param X start X
         * @param Y start Y
         * @param dir direction the sprite will move in
         * @param speed speed in pixels the sprite will move on update
         */
    public function new(x:Float, y:Float, direction:UInt, speed:Int)
    {
        super(x, y, null, direction, speed);

        loadGraphic(AssetPaths.crocodile__png, true, SPRITE_WIDTH, SPRITE_HEIGHT);

        setFacingFlip(FlxObject.LEFT, false, false);
        setFacingFlip(FlxObject.RIGHT, true, false);

        facing = direction;

        animation.add("idle", [0, 0, 0, 0, 1, 1], 2, true);

        animation.play("idle");
        //set_width(150);
        //scale = new FlxPoint(150.0/130.0, 1.0);
        //updateHitbox();
    }
}
