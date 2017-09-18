package ;
import flixel.group.FlxGroup.FlxTypedGroup;
class HomeBaseGroup extends FlxTypedGroup<Home>{
    var home1:Home;
    var home2:Home;
    var home3:Home;
    var home4:Home;
    var home5:Home;
    public function new()
    {
        super();
        home1 = new Home(28, 59 + 22, 200, 200,10);
        home2 = new Home(28 + 96, 59 + 22, 200, 200,10);
        home3 = new Home(28 + 96 * 2, 59 + 22, 200, 200, 10);
        home4 = new Home(28 + 96 * 3, 59 + 22, 200, 200, 10);
        home5 = new Home(28 + 96 * 4, 59 + 22, 200, 200, 10);
        add(home1);
        add(home2);
        add(home3);
        add(home4);
        add(home5);
    }
}
