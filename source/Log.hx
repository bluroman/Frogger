package ;
import flixel.system.FlxAssets.FlxGraphicAsset;
class Log extends WrappingSprite
{
    public static inline var TYPE_A = 0;
    public static inline var TYPE_B = 1;
    public static inline var TYPE_C = 2;

    public static inline var TYPE_A_WIDTH = 95;
    public static inline var TYPE_B_WIDTH = 196;
    public static inline var TYPE_C_WIDTH = 127;

    /**
         * Simple sprite to represent a log. There are 3 types of logs, represented by TYPE_A, _B, and
         * _C constant.
         *
         * @param x start X
         * @param y start Y
         * @param type type of car to use. Type_A, _b, _c, and _d are referenced as constants on the class
         * @param direction the direction the sprite will move in
         * @param speed the speed in pixels in which the sprite will move on update
         */
    public function new(x:Float, y:Float, type:Int, dir:Int, velocity:Int, parentState:PlayState)
    {

        var simpleGraphic:FlxGraphicAsset = null;

        switch (type)
        {
        case TYPE_A:
            simpleGraphic = AssetPaths.tree_1__png;
        case TYPE_B:
            simpleGraphic = AssetPaths.tree_2__png;
        case TYPE_C:
            simpleGraphic = AssetPaths.tree_3__png;
        }

        super(x, y, simpleGraphic, dir, velocity, parentState);

    }
}
