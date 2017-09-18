package ;
import PlayState;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
class BackgroundGroup extends FlxTypedSpriteGroup<FlxSprite>{
    var waterSprite:FlxSprite;
    var bottomGround:FlxSprite;
    var shoreSprite:FlxSprite;
    var topGround:FlxSprite;
    public function new()
    {
        super();
        waterSprite = new FlxSprite(0, calculateRow(1) + 19 + 20, AssetPaths.water_background1__png);
        bottomGround = new FlxSprite(0, calculateRow(14), AssetPaths.bottom_ground__png);
        shoreSprite = new FlxSprite(0, calculateRow(8), AssetPaths.shore_sprite__png);
        topGround = new FlxSprite(0, calculateRow(1) + 19, AssetPaths.top_ground1__png);
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
