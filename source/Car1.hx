package ;
import flixel.system.FlxSound;
import flixel.FlxG;
import flixel.FlxObject;
class Car1 extends WrappingSprite
{
    public static inline var SPRITE_WIDTH = 80;
    public static inline var SPRITE_HEIGHT = 40;

    public static inline var TYPE_A = 0;
    public static inline var TYPE_B = 1;
    public static inline var TYPE_C = 2;
    public static inline var TYPE_D = 3;
    public static inline var TYPE_E = 4;

    var originalSpeed:Int = 0;
    var speedUp:Bool = false;
    var _type:Int = 0;
    var _sndCar:FlxSound;

    /**
         * Simple sprite to represent a car. There are 4 types of cars, represented by TYPE_A, _B,
         * _C, and _D constant.
         *
         * @param x start X
         * @param y start Y
         * @param type type of car to use. Type_A, _b, _c, and _d are referenced as constants on the class
         * @param direction the direction the sprite will move in
         * @param speed the speed in pixels in which the sprite will move on update
         */
    public function new(x:Float, y:Float, type:Int, direction:Int, speed:Int)
    {
        super(x, y, null, direction, speed);

        loadGraphic(AssetPaths.car_sprite_new__png, true, SPRITE_WIDTH, SPRITE_HEIGHT);

        //frame = type;
        setFacingFlip(FlxObject.LEFT, true, false);
        setFacingFlip(FlxObject.RIGHT, false, false);

        facing = direction;
        originalSpeed = speed;
        _type = type;

        animation.add("0", [TYPE_A], 0, false);
        animation.add("1", [TYPE_B], 0, false);
        animation.add("2", [TYPE_C], 0, false);
        animation.add("3", [TYPE_D], 0, false);
        animation.add("4", [TYPE_E], 0, false);

        animation.play(Std.string(type));
        _sndCar = FlxG.sound.load("Car" + _type,.4);
        _sndCar.proximity(x,y,FlxG.camera.target, FlxG.width *.4);
        //_sndCar = null;
        //_sndCar = FlxG.sound.load("Car" + _type);
    }
    override public function update(elapsed:Float):Void
    {

        if(!speedUp && Reg.PS.player.y == y)
        {
            speed += 1;
            speedUp = true;
            _sndCar.setPosition(x + frameWidth / 2, y + height);
            _sndCar.play();
            //if(!Reg.PS.sndCar0.playing)
            //    Reg.PS.sndCar0.play(true);
//            if(FlxG.sound != null)
//            {
//                //if(FlxG.sound.name != "Car"+ _type)
//                    _sndCar = FlxG.sound.play("Car" + _type);
//            }
//                //FlxG.sound.play("Car" + FlxG.random.int(1,5));
        }
        else
        {
            speed = originalSpeed;
            speedUp = false;
            //if(Reg.PS.sndCar0.playing)
            //    Reg.PS.sndCar0.stop();
            //if(_sndCar != null && _sndCar.playing)
            //    _sndCar.stop();
        }

        super.update(elapsed);
    }
}
