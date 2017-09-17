package ;
class Alligator extends WrappingSprite{
    public static inline var SPRITE_WIDTH = 130;
    public static inline var SPRITE_HEIGHT = 40;

    /**
         * This is a simple sprite which represents Snake.
         *
         * @param X start X
         * @param Y start Y
         * @param dir direction the sprite will move in
         * @param speed speed in pixels the sprite will move on update
         */
    public function new(x:Float, y:Float, direction:UInt, speed:Int, parentState:PlayState)
    {
        super(x, y, null, direction, speed, parentState);

        loadGraphic(AssetPaths.alligator1_sprites__png, true, SPRITE_WIDTH, SPRITE_HEIGHT);

        animation.add("idle", [0, 1], 1, true);

        animation.play("idle");
    }
}
