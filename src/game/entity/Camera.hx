package game.entity;

import h2d.col.Point;
import hxd.clipper.Rect;
import Std;
import game.GameMap;
import game.component.AccelMovement;

// TODO
// 如果开启moveSmooth，则镜头移到停止的位置应该再加一个偏移
// 移动的手感也需要再调整，而不是直接设置一个固定的速度
class Camera extends Entity
{
    private var mTarget:Entity;
    private var mMoveSmoothEnable:Bool = false;
    private var mMoveSpeed:Float = 256;
    private var mMovement:AccelMovement;
    private var mScreenWidth:Int = 0;
    private var mScreenHeight:Int = 0;
    private var mDragMarginRect:Rect;
    private var mDebugDrawMarginRect:Bool = false;

    public function new(?screenWidht:Int = 800, ?screenheight = 600)
    {
        super("Camera", EntityType_Camera);

        mScreenWidth = screenWidht;
        mScreenHeight = screenheight;

        var components = GetComponents();
        mMovement = new AccelMovement("PlayerMove");
        mMovement.SetGravityEnable(false);
        mMovement.SetCheckCollisionEnable(false);
        mMovement.SetCheckOnFloorEnable(false);
        components.Add(mMovement);
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
        
        mMovement.SetSpeedX(0);

        if (mTarget != null)
        {
            var targetPos = mTarget.GetCenterPos();
            if (targetPos.x - mPos.x >= mDragMarginRect.right) {
                if (mMoveSmoothEnable) {
                    mMovement.SetSpeedX(mMoveSpeed);
                }
                else {
                    SetPositionX(targetPos.x - mDragMarginRect.right);
                }
            }
            else if(mPos.x - targetPos.x >= mDragMarginRect.left) {
                if (mMoveSmoothEnable) {
                    mMovement.SetSpeedX(-mMoveSpeed);
                }
                else {
                    SetPositionX(targetPos.x + mDragMarginRect.left);
                }
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

    public function SetUpdateSmoothEnable(enable)
    {
        mMoveSmoothEnable = enable;
    }
}