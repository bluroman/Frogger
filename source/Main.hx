package;

import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public static var tongue:FireTongueEx;

	public function new()
	{
		super();
		// addChild(new FlxGame(768, 1024, MenuState, true));
		addChild(new FlxGame(480, 800, MenuState, true));
	}
}
