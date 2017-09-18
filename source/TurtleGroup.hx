package ;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
class TurtleGroup extends FlxTypedSpriteGroup<FlxSprite>
{
    var turtlesA1:TurtlesA;
    var turtlesA2:TurtlesA;
    var turtlesA3:TurtlesA;
    var turtlesB1:TurtlesB;
    var turtlesB2:TurtlesB;
    var turtlesB3:TurtlesB;

    public function new(actorSpeed:Int)
    {
        super();
        turtlesA1 = new TurtlesA(0, calculateRow(4), -1, -1, FlxObject.LEFT, actorSpeed);
        turtlesA2 = new TurtlesA((TurtlesA.SPRITE_WIDTH + 123) * 1, calculateRow(4), TurtlesA.DEFAULT_TIME, 200, FlxObject.LEFT, actorSpeed);
        turtlesA3 = new TurtlesA((TurtlesA.SPRITE_WIDTH + 123) * 2, calculateRow(4), -1, -1, FlxObject.LEFT, actorSpeed);

        turtlesB1 = new TurtlesB(0, calculateRow(7), TurtlesA.DEFAULT_TIME, 0, FlxObject.LEFT, actorSpeed);
        turtlesB2 = new TurtlesB((TurtlesB.SPRITE_WIDTH + 95) * 1, calculateRow(7), -1, -1, FlxObject.LEFT, actorSpeed);
        turtlesB3 = new TurtlesB((TurtlesB.SPRITE_WIDTH + 95) * 2, calculateRow(7), -1, -1, FlxObject.LEFT, actorSpeed);

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
