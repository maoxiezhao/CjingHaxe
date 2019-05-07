package game.entity;

import h2d.col.Point;
import hxd.clipper.Rect;
import Std;
import game.GameMap;

class Camera extends Entity
{
    private var mTarget:Entity;
    private var mMoveSmooth:Bool = false;
    private var mMoveSpeed:Float = 6;
    private var mScreenWidth:Int = 0;
    private var mScreenHeight:Int = 0;
    private var mDragMarginRect:Rect;
    private var mDebugDrawMarginRect:Bool = false;

    public function new(?screenWidht:Int = 800, ?screenheight = 600)
    {
        super("Camera", EntityType_Camera);

        mScreenWidth = screenWidht;
        mScreenHeight = screenheight;
    }

    public function SetDragmarginRect(rect:Rect)
    {
        mDragMarginRect = rect;
    }

    public function TraceTarget(target:Entity, ?immediate = false)
    {
        if (target == mTarget) {
            return;
        }

        mTarget = target;

        if (mTarget != null) {
            var targetPos = target.GetCenterPos();
            SetPosition(targetPos.x, targetPos.y);
        }
    }

    public function GetLeftTopPostion()
    {
        var pos = GetPosition();
        return new Point(pos.x - mScreenWidth/2, pos.y - mScreenHeight/2);
    }

    public function SetLeftTopPosition(pos:Point)
    {
        SetPosition(pos.x + mScreenWidth/2, pos.y + mScreenHeight/2);
    }

    private function AdaptCamera()
    {
        var currentMap = this.GetCurrentMap();
        if (currentMap != null)
        {
            var AdaptSizeAxis = function(viewSize:Int, mapSize:Int, camPos:Int)
            {
                if (mapSize < viewSize) {
                    return (mapSize - viewSize) * 0.5;
                }
                else {
                    return Math.min((mapSize - viewSize), Math.max(camPos, 0));
                }
            }
            
            var camLeftTopPos = GetLeftTopPostion();
            var newCamLeftTopPos = new Point();

            newCamLeftTopPos.x = AdaptSizeAxis(mScreenWidth, currentMap.mMapWidth, Std.int(camLeftTopPos.x));
            newCamLeftTopPos.y = AdaptSizeAxis(mScreenHeight, currentMap.mMapHeight, Std.int(camLeftTopPos.y));

            SetLeftTopPosition(newCamLeftTopPos);
        }
    }

    override function Update(dt:Float)
    {
        super.Update(dt);
        
        trace(mPos.x, mPos.y);

        if (mTarget != null)
        {
            var targetPos = mTarget.GetCenterPos();
            if (targetPos.x - mPos.x >= mDragMarginRect.right) {
                SetPositionX(targetPos.x - mDragMarginRect.right);
            }
            else if(mPos.x - targetPos.x >= mDragMarginRect.left) {
                SetPositionX(targetPos.x + mDragMarginRect.left);
            }

            AdaptCamera();
        }

        var currentMap = this.GetCurrentMap();
        if (currentMap != null)
        {
            var scroller = currentMap.GetScroller();
            scroller.x = mScreenWidth / 2 - mPos.x;
            scroller.y = mScreenHeight / 2 - mPos.y;
        }
    }
}