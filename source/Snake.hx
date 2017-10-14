package ;
import flixel.FlxG;
import flixel.system.FlxSound;
import flixel.FlxObject;
class Snake extends WrappingSprite
{
    public static inline var SPRITE_WIDTH = 80;
    public static inline var SPRITE_HEIGHT = 80;
    var _sndSnake:FlxSound;

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

        loadGraphic(AssetPaths.snake__png, true, SPRITE_WIDTH, SPRITE_HEIGHT);
        angle = -90;

        animation.add("idle", [0, 1, 2, 3, 4, 5], 3, true);

        animation.play("idle");
        if(direction == FlxObject.LEFT)
        {
            offset.x = 0;
            offset.y = 24;
            width = 32;
            height = 32;
        }
        else if(direction == FlxObject.RIGHT)
        {
            offset.x = 48;
            offset.y = 24;
            width = 32;
            height = 32;
        }
        _sndSnake = FlxG.sound.load("Snake",.4);
        _sndSnake.proximity(x,y,FlxG.camera.target, FlxG.width *.4);
    }
    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
        _sndSnake.setPosition(x + frameWidth / 2, y + height);
        _sndSnake.play();
    }
}