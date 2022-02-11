package ;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
class Car1Group extends FlxTypedSpriteGroup<FlxSprite>
{
    //var truck1:Truck;
    //var truck2:Truck;
    var road:FlxSprite;
    var car1_1:Car1;
    var car1_2:Car1;
    var car2_1:Car1;
    var car2_2:Car1;
    var car3_1:Car1;
    var car3_2:Car1;
    var car3_3:Car1;
    var car4_1:Car1;
    var car4_2:Car1;
    var car4_3:Car1;
    var car5_1:Car1;
    var car5_2:Car1;
    public function new(X:Float, Y:Float, actorSpeed:Int)
    {
        super();
        //truck1 = new Truck(0, Y, FlxObject.LEFT, actorSpeed);
        //truck2 = new Truck(270, Y, FlxObject.LEFT, actorSpeed);
        road = new FlxSprite(X, Y, "assets/images/road1.png");
        car1_1 = new Car1(0, Y + PlayState.TILE_SIZE, Car1.TYPE_C, FlxObject.RIGHT, actorSpeed* 2);
        car1_2 = new Car1(270, Y + PlayState.TILE_SIZE, Car1.TYPE_C, FlxObject.RIGHT, actorSpeed* 2);

        car2_1 = new Car1(0, Y + PlayState.TILE_SIZE * 2, Car1.TYPE_D, FlxObject.LEFT, actorSpeed);
        car2_2 = new Car1(270, Y + PlayState.TILE_SIZE * 2, Car1.TYPE_D, FlxObject.LEFT, actorSpeed);

        car3_1 = new Car1(0, Y + PlayState.TILE_SIZE * 3, Car1.TYPE_B, FlxObject.RIGHT, actorSpeed);
        car3_2 = new Car1((Car1.SPRITE_WIDTH + 138) * 1, Y + PlayState.TILE_SIZE * 3, Car1.TYPE_B, FlxObject.RIGHT, actorSpeed);
        car3_3 = new Car1((Car1.SPRITE_WIDTH + 138) * 2, Y + PlayState.TILE_SIZE * 3, Car1.TYPE_B, FlxObject.RIGHT, actorSpeed);
        car4_1 = new Car1(0, Y + PlayState.TILE_SIZE * 4, Car1.TYPE_A, FlxObject.LEFT, actorSpeed);
        car4_2 = new Car1((Car1.SPRITE_WIDTH + 138) * 1, Y + PlayState.TILE_SIZE * 4, Car1.TYPE_A, FlxObject.LEFT, actorSpeed);
        car4_3 = new Car1((Car1.SPRITE_WIDTH + 138) * 2, Y + PlayState.TILE_SIZE * 4, Car1.TYPE_A, FlxObject.LEFT, actorSpeed);
        car5_1 = new Car1(0, Y, Car1.TYPE_E, FlxObject.LEFT, actorSpeed);
        car5_2 = new Car1(270, Y, Car1.TYPE_E, FlxObject.LEFT, actorSpeed);

        //add(truck1);
        //add(truck2);
        add(road);
        add(car1_1);
        add(car1_2);
        add(car2_1);
        add(car2_2);
        add(car3_1);
        add(car3_2);
        add(car3_3);
        add(car4_1);
        add(car4_2);
        add(car4_3);
        add(car5_1);
        add(car5_2);
//        carGroup.add(new Truck(0, calculateRow(9), FlxObject.LEFT, actorSpeed));
//        carGroup.add(new Truck(270, calculateRow(9), FlxObject.LEFT, actorSpeed));
//
//        carGroup.add(new Car1(0, calculateRow(10), Car.TYPE_C, FlxObject.RIGHT, actorSpeed* 2));
//        carGroup.add(new Car(270, calculateRow(10), Car.TYPE_C, FlxObject.RIGHT, actorSpeed* 2));
//
//        carGroup.add(new Car(0, calculateRow(11), Car.TYPE_D, FlxObject.LEFT, actorSpeed));
//        carGroup.add(new Car(270, calculateRow(11), Car.TYPE_D, FlxObject.LEFT, actorSpeed));
//
//
//        carGroup.add(new Car(0, calculateRow(12), Car.TYPE_B, FlxObject.RIGHT, actorSpeed));
//        carGroup.add(new Car((Car.SPRITE_WIDTH + 138) * 1, calculateRow(12), Car.TYPE_B, FlxObject.RIGHT, actorSpeed));
//        carGroup.add(new Car((Car.SPRITE_WIDTH + 138) * 2, calculateRow(12), Car.TYPE_B, FlxObject.RIGHT, actorSpeed));
//
//        carGroup.add(new Car(0, calculateRow(13), Car.TYPE_A, FlxObject.LEFT, actorSpeed));
//        carGroup.add(new Car((Car.SPRITE_WIDTH + 138) * 1, calculateRow(13), Car.TYPE_A, FlxObject.LEFT, actorSpeed));
//        carGroup.add(new Car((Car.SPRITE_WIDTH + 138) * 2, calculateRow(13), Car.TYPE_A, FlxObject.LEFT, actorSpeed));
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
