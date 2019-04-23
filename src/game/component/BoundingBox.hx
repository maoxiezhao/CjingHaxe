package game.component;

import hxd.Timer;
import h2d.col.Bounds;
// base movement component
// TODO: use third part library
class BoundingBox extends Component
{
    public var mBound:h2d.col.Bounds;
    public var mDx:Int;
    public var mDy:Int;

    public function new(name:String, dx:Int, dy:Int, width:Int, height:Int)
    {
        super(name, ComponentType_BoundingBox);
        mDx = dx;
        mDy = dy;
        mBound = Bounds.fromValues(dx, dy, width, height);
    }

    override public function Update(dt:Float)
    {
        if (mCurrentEntity != null)
        {
            var entityPos = mCurrentEntity.GetPosition();
            mBound.x = entityPos.x + mDx;
            mBound.y = entityPos.y + mDy;
        }
    }
}