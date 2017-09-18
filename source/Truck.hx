package ;
class Truck extends WrappingSprite
{


    /**
         * This is a simple sprite which represents the Truck.
         *
         * @param X start X
         * @param Y start Y
         * @param dir direction the sprite will move in
         * @param speed speed in pixels the sprite will move on update
         */
    public function new(x:Float, y:Float, direction:UInt, velocity:Int)
    {
        super(x, y, AssetPaths.truck__png, direction, velocity);
    }
}
