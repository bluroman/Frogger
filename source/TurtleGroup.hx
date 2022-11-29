package;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.util.FlxDirectionFlags;

class TurtleGroup extends FlxTypedSpriteGroup<FlxSprite>
{
	var turtlesA1:TurtlesA;
	var turtlesA2:TurtlesA;
	var turtlesA3:TurtlesA;
	var turtlesB1:TurtlesB;
	var turtlesB2:TurtlesB;
	var turtlesB3:TurtlesB;
	var turtlesA11:TurtlesA;
	var turtlesA21:TurtlesA;
	var turtlesA31:TurtlesA;

	public function new(Row:Int, actorSpeed:Int)
	{
		super();
		turtlesA11 = new TurtlesA(0, calculateRow(Row), -1, -1, FlxDirectionFlags.LEFT, actorSpeed);
		turtlesA21 = new TurtlesA((TurtlesA.SPRITE_WIDTH + 100) * 1, calculateRow(Row), TurtlesA.DEFAULT_TIME, 250, FlxDirectionFlags.LEFT, actorSpeed);
		turtlesA31 = new TurtlesA((TurtlesA.SPRITE_WIDTH + 100) * 2, calculateRow(Row), -1, -1, FlxDirectionFlags.LEFT, actorSpeed);

		turtlesA1 = new TurtlesA(0, calculateRow(Row + 2), -1, -1, FlxDirectionFlags.LEFT, actorSpeed);
		turtlesA2 = new TurtlesA((TurtlesA.SPRITE_WIDTH + 123) * 1, calculateRow(Row + 2), TurtlesA.DEFAULT_TIME, 200, FlxDirectionFlags.LEFT, actorSpeed);
		turtlesA3 = new TurtlesA((TurtlesA.SPRITE_WIDTH + 123) * 2, calculateRow(Row + 2), -1, -1, FlxDirectionFlags.LEFT, actorSpeed);

		turtlesB1 = new TurtlesB(0, calculateRow(Row + 5), TurtlesA.DEFAULT_TIME, 0, FlxDirectionFlags.LEFT, actorSpeed);
		turtlesB2 = new TurtlesB((TurtlesB.SPRITE_WIDTH + 95) * 1, calculateRow(Row + 5), -1, -1, FlxDirectionFlags.LEFT, actorSpeed);
		turtlesB3 = new TurtlesB((TurtlesB.SPRITE_WIDTH + 95) * 2, calculateRow(Row + 5), -1, -1, FlxDirectionFlags.LEFT, actorSpeed);

		add(turtlesA11);
		add(turtlesA21);
		add(turtlesA31);
		add(turtlesA1);
		add(turtlesA2);
		add(turtlesA3);
		add(turtlesB1);
		add(turtlesB2);
		add(turtlesB3);
		//        turtleGroup.add(new TurtlesA(0, calculateRow(4), -1, -1, FlxObject.LEFT, actorSpeed));
		//        turtleGroup.add(new TurtlesA((TurtlesA.SPRITE_WIDTH + 123) * 1, calculateRow(4), TurtlesA.DEFAULT_TIME, 200, FlxObject.LEFT, actorSpeed));
		//        turtleGroup.add(new TurtlesA((TurtlesA.SPRITE_WIDTH + 123) * 2, calculateRow(4), -1, -1, FlxObject.LEFT, actorSpeed));
		//
		//
		//
		//        turtleGroup.add(new TurtlesB(0, calculateRow(7), TurtlesA.DEFAULT_TIME, 0, FlxObject.LEFT, actorSpeed));
		//        turtleGroup.add(new TurtlesB((TurtlesB.SPRITE_WIDTH + 95) * 1, calculateRow(7), -1, -1, FlxObject.LEFT, actorSpeed));
		//        turtleGroup.add(new TurtlesB((TurtlesB.SPRITE_WIDTH + 95) * 2, calculateRow(7), -1, -1, FlxObject.LEFT, actorSpeed));
	}

	public function calculateColumn(value:Int):Int
	{
		return value * PlayState.TILE_SIZE;
	}

	public function calculateRow(value:Int):Int
	{
		return calculateColumn(value);
	}
}
