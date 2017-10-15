package ;
import flixel.FlxG;
import PlayState;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
class BackgroundGroup extends FlxTypedSpriteGroup<FlxSprite>{
    public var waterSprite:FlxSprite;
    public var waterSprite1:FlxSprite;
    var bottomGround:FlxSprite;
    var shoreSprite:FlxSprite;
    var topGround:FlxSprite;
    var shoreSprite1:FlxSprite;
    var shoreSprite2:FlxSprite;
    var shoreSprite3:FlxSprite;
    public function new()
    {
        super();
        shoreSprite2 = new FlxSprite(0, calculateRow(-5), "assets/images/shore_sprite.png");
        shoreSprite1 = new FlxSprite(0, calculateRow(1), "assets/images/shore_sprite.png");
        waterSprite = new FlxSprite(0, calculateRow(2), "assets/images/water_background1.png");
        bottomGround = new FlxSprite(0, calculateRow(14), "assets/images/bottom_ground.png");
        shoreSprite = new FlxSprite(0, calculateRow(8), "assets/images/shore_sprite.png");
        topGround = new FlxSprite(0, -FlxG.height + calculateRow(1) + 19, "assets/images/top_ground1.png");
        shoreSprite3 = shoreSprite2.clone();
        shoreSprite3.y = calculateRow(-12);
        waterSprite1 = waterSprite.clone();
        waterSprite1.x = 0;
        waterSprite1.y = calculateRow(-11);
        add(shoreSprite3);
        add(waterSprite1);
        add(shoreSprite2);
        add(shoreSprite1);
        add(waterSprite);
        add(bottomGround);
        add(shoreSprite);
        add(topGround);
        //add(new FlxSprite(0, calculateRow(1) + 19 + 20, AssetPaths.water_background1__png));

        //add(new FlxSprite(0, calculateRow(14), AssetPaths.bottom_ground__png));
        //add(new FlxSprite(0, calculateRow(8), AssetPaths.shore_sprite__png));
        //add(new FlxSprite(0, calculateRow(1) + 19, AssetPaths.top_ground1__png));
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
