package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.sound.FlxSound;

class Car1 extends WrappingSprite
{
	public static inline var SPRITE_WIDTH = 80;
	public static inline var SPRITE_HEIGHT = 40;

	public static inline var TYPE_A = 0;
	public static inline var TYPE_B = 1;
	public static inline var TYPE_C = 2;
	public static inline var TYPE_D = 3;
	public static inline var TYPE_E = 4;

	var originalSpeed:Float = 0;
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
	public function new(x:Float, y:Float, type:Int, direction:Int, speed:Float)
	{
		super(x, y, null, direction, speed);

		loadGraphic("assets/images/car_sprite_new.png", true, SPRITE_WIDTH, SPRITE_HEIGHT);

		// frame = type;
		setFacingFlip(LEFT, true, false);
		setFacingFlip(RIGHT, false, false);

		facing = direction;
		originalSpeed = speed;
		_type = type;

		animation.add("0", [TYPE_A], 0, false);
		animation.add("1", [TYPE_B], 0, false);
		animation.add("2", [TYPE_C], 0, false);
		animation.add("3", [TYPE_D], 0, false);
		animation.add("4", [TYPE_E], 0, false);

		animation.play(Std.string(type));
		_sndCar = FlxG.sound.load("Car" + _type, .4);
		_sndCar.proximity(x, y, FlxG.camera.target, FlxG.width * .4);
		// _sndCar = null;
		// _sndCar = FlxG.sound.load("Car" + _type);
	}

	override public function update(elapsed:Float):Void
	{
		if (!speedUp)
		{
			if (Reg.PS.player.y == y)
			{
				originalSpeed = speed;
				speed += 1;
				speedUp = true;
				_sndCar.setPosition(x + frameWidth / 2, y + height);
				_sndCar.play();
			}
		}
		else
		{
			speed = originalSpeed;
			speedUp = false;
		}

		super.update(elapsed);
	}
}
