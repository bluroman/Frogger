package;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.util.FlxDirectionFlags;

class LogGroup extends FlxTypedSpriteGroup<FlxSprite>
{
	var log1_1:Log;
	var log1_2:Log;
	var log1_3:Log;
	var log2_1:Log;
	var log2_2:Log;
	var log3_1:Log;
	var log3_2:Log;
	var log3_3:Log;
	var blueFrog:BlueFrog;

	public function new(Row:Int, actorSpeed:Int)
	{
		super();
		blueFrog = new BlueFrog(100, 100, 0xffffff);

		log1_1 = new Log(0, calculateRow(Row), Log.TYPE_C, FlxDirectionFlags.RIGHT, actorSpeed, blueFrog);
		log1_2 = new Log(Log.TYPE_C_WIDTH + 77, calculateRow(Row), Log.TYPE_C, FlxDirectionFlags.RIGHT, actorSpeed, blueFrog);
		log1_3 = new Log((Log.TYPE_C_WIDTH + 77) * 2, calculateRow(Row), Log.TYPE_C, FlxDirectionFlags.RIGHT, actorSpeed, blueFrog);

		log2_1 = new Log(30, calculateRow(Row + 2), Log.TYPE_B, FlxDirectionFlags.RIGHT, actorSpeed * 2, blueFrog);
		log2_2 = new Log(Log.TYPE_B_WIDTH + 130, calculateRow(Row + 2), Log.TYPE_B, FlxDirectionFlags.RIGHT, actorSpeed * 2, blueFrog);

		log3_1 = new Log(0, calculateRow(Row + 3), Log.TYPE_A, FlxDirectionFlags.RIGHT, actorSpeed, blueFrog);
		log3_2 = new Log(Log.TYPE_A_WIDTH + 77, calculateRow(Row + 3), Log.TYPE_A, FlxDirectionFlags.RIGHT, actorSpeed, blueFrog);
		log3_3 = new Log((Log.TYPE_A_WIDTH + 77) * 2, calculateRow(Row + 3), Log.TYPE_A, FlxDirectionFlags.RIGHT, actorSpeed, blueFrog);

		add(log1_1);
		add(log1_2);
		add(log1_3);
		add(log2_1);
		add(log2_2);
		add(log3_1);
		add(log3_2);
		add(log3_3);
		add(blueFrog);

		//        blueFrog = new BlueFrog(100, 100, 0xffffff,cast(logGroup.getFirstAlive(), Log));
		//        logGroup.add(blueFrog);
		//        logGroup.add(new Log(0, calculateRow(3), Log.TYPE_C, FlxObject.RIGHT, actorSpeed));
		//        logGroup.add(new Log(Log.TYPE_C_WIDTH + 77, calculateRow(3), Log.TYPE_C, FlxObject.RIGHT, actorSpeed));
		//        //logGroup.add(new Log((Log.TYPE_C_WIDTH + 77) * 2, calculateRow(3), Log.TYPE_C, FlxObject.RIGHT, actorSpeed, this));
		//        logGroup.add(new Log(30, calculateRow(5), Log.TYPE_B, FlxObject.RIGHT, actorSpeed* 2));
		//        logGroup.add(new Log(Log.TYPE_B_WIDTH + 130, calculateRow(5), Log.TYPE_B, FlxObject.RIGHT, actorSpeed* 2));
		//
		//        logGroup.add(new Log(0, calculateRow(6), Log.TYPE_A, FlxObject.RIGHT, actorSpeed));
		//        logGroup.add(new Log(Log.TYPE_A_WIDTH + 77, calculateRow(6), Log.TYPE_A, FlxObject.RIGHT, actorSpeed));
		//        logGroup.add(new Log((Log.TYPE_A_WIDTH + 77) * 2, calculateRow(6), Log.TYPE_A, FlxObject.RIGHT, actorSpeed));
		//        blueFrog = new BlueFrog(100, 100, 0xffffff,cast(logGroup.getFirstAlive(), Log));
		//        logGroup.add(blueFrog);
		//        alligator = new Alligator((Log.TYPE_C_WIDTH + 77) * 2, calculateRow(3), FlxObject.RIGHT, actorSpeed);
		//        logGroup.add(alligator);
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
