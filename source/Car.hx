package ;
class Car extends WrappingSprite
{
    public static inline var SPRITE_WIDTH = 40;
    public static inline var SPRITE_HEIGHT = 40;

    public static inline var TYPE_A = 0;
    public static inline var TYPE_B = 1;
    public static inline var TYPE_C = 2;
    public static inline var TYPE_D = 3;

    /**
         * Simple sprite to represent a car. There are 4 types of cars, represented by TYPE_A, _B,
         * _C, and _D constant.
         *
         * @param x start X
         * @param y start Y
         * @param type type of car to use. Type_A, _b, _c, and _d are referenced as constants on the class
         * @param direction the direction the sprite will move in
         * @param speed the speed in pixels in which the sprite will move on update
         */
    public function new(x:Float, y:Float, type:Int, direction:Int, speed:Int)
    {
        super(x, y, null, direction, speed);

        loadGraphic(AssetPaths.car_sprites__png, true, SPRITE_WIDTH, SPRITE_HEIGHT);

        //frame = type;

        animation.add("0", [TYPE_A], 0, false);
        animation.add("1", [TYPE_B], 0, false);
        animation.add("2", [TYPE_C], 0, false);
        animation.add("3", [TYPE_D], 0, false);

        animation.play(Std.string(type));
    }
}
