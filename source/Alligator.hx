package ;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.math.FlxPoint;
class Alligator extends WrappingSprite{
    public static inline var SPRITE_WIDTH = 120;
    public static inline var SPRITE_HEIGHT = 40;
    var mouth:FlxSprite;

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
        //mouth = new FlxSprite(x, y);
        //mouth.makeGraphic(52, 40);
        //Reg.PS.add(mouth);

        animation.add("idle", [0, 0, 0, 0, 1, 1], 2, true);

        animation.play("idle");
        if(direction == FlxObject.LEFT)
        {
            offset.x = 52;
            offset.y = 0;
            width = 60;
            height = 40;
        }
        else if(direction == FlxObject.RIGHT)
        {
            offset.x = 8;
            offset.y = 0;
            width = 60;
            height = 40;
        }
        //set_width(150);
        //scale = new FlxPoint(150.0/130.0, 1.0);
        //updateHitbox();
    }
    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
        if(color == 0xff0000 && y != Reg.PS.player.y)
            color = 0xffffff;
        //mouth.x = x;
        //mouth.y = y;

    }
}
