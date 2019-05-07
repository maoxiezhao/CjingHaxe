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
    
    private var mDebugEnable:Bool = false;
    private var mDebugDrawable:h2d.Graphics;

    public function new(name:String, dx:Int, dy:Int, width:Int, height:Int)
    {
        super(name, ComponentType_BoundingBox);
        mDx = dx;
        mDy = dy;
        mBound = Bounds.fromValues(dx, dy, width, height);

        mDebugDrawable = new h2d.Graphics();
    }

    override public function Update(dt:Float)
    {
        // set bounding box pos in Entity:SetPosition
        // because movement will update some times in once frame
        //if (mCurrentEntity != null)
        //{
            // var entityPos = mCurrentEntity.GetPosition();
            // mBound.x = entityPos.x + mDx;
            // mBound.y = entityPos.y + mDy;
        //}
    }

    override private function AddedImpl()
    {
        if (mDebugEnable) 
        {
            var object = mCurrentEntity.mBaseObject;
            object.addChild(mDebugDrawable);
        }

        var eventManagement = mCurrentEntity.mEventManagement;
        eventManagement.Add(EntityEvent_PositionChanged, NotifyEntityPositionChanged);

        NotifyEntityPositionChanged();
    }

    override private function RemovedImpl() 
    {
        if (mDebugEnable) {
            mDebugDrawable.remove();
        }

         var eventManagement = mCurrentEntity.mEventManagement;
        eventManagement.Remove(EntityEvent_PositionChanged, NotifyEntityPositionChanged);
    }

    public function NotifyEntityPositionChanged()
    {
        if (mCurrentEntity != null)
        {
            var entityPos = mCurrentEntity.GetPosition();
            mBound.x = entityPos.x + mDx;
            mBound.y = entityPos.y + mDy;
        }
    }

    // must set before add into entity
    public function SetDebugEnable(debug)
    {
        mDebugEnable = debug;

        mDebugDrawable.x = mDx;
        mDebugDrawable.y = mDy;
        mDebugDrawable.beginFill(0xFFFFFF);
        mDebugDrawable.drawRect(0, 0, mBound.width, mBound.height);
    }
}