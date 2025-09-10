// package sprites;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;

using flixel.util.FlxSpriteUtil;

class Square extends FlxSprite
{
	private static inline var rectangle_size:Int = 150;
	private static inline var rectangle_corner_radius:Float = 10;

	public var pressed:Bool;

	public function new(x:Int, y:Int)
	{
		// must call super constructor before making graphic
		super(x, y);
		this.x = x;
		this.y = y;

		this.loadGraphic("assets/images/touchUp.png", 100, 100);

		// use chaining to setup the shape graphics
		// this.makeGraphic(rectangle_size, rectangle_size, FlxColor.TRANSPARENT)
		//	.drawRoundRect(0, 0, rectangle_size, rectangle_size, rectangle_corner_radius, rectangle_corner_radius, FlxColor.WHITE, null, null);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		handleInput();

		handleAnimations();
	}

	override public function destroy():Void
	{
		super.destroy();
	}

	private inline function handleInput():Void
	{
		#if FLX_TOUCH
		for (touch in FlxG.touches.list)
		{
			pressed = this.overlapsPoint(touch.getScreenPosition());
		}
		#end
	}

	private inline function handleAnimations():Void
	{
		if (pressed)
		{
			this.set_color(FlxColor.PINK);
		}
		else
		{
			this.set_color(FlxColor.GREEN);
		}
	}
}
