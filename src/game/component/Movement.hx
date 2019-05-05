package game.component;

import hxd.Math;
import h2d.col.Point;
import h3d.mat.Data.Face;
import game.Component;
import game.entity.Entity;
import game.component.BoundingBox;
import helper.System;

// base movement component
// TODO
// 1.when speed>60 p/s, need to lerp
class Movement extends Component
{
    private var mSpeedX:Float = 0;
    private var mSpeedY:Float = 0;
    private var mDirectionX:Int = 0;
    private var mDirectionY:Int = 0;
    private var mAccumulatedYSteps:Float = 0;
    private var mAccumulatedXSteps:Float = 0;

    private var mPosition:Point;
    private var mUpdateSmooth:Bool = false;
    private var mIsOnFloor:Bool = false;
    private var mCheckOnFloorEnable:Bool = false;

    public function new(name:String)
    {
        super(name, ComponentType_Movement);
    }

    override private function AddedImpl()
    {
        mPosition = mCurrentEntity.GetPosition();
    }

    override public function Update(dt:Float)
    {
        var oldPos = mPosition.clone();
        var tryMovingX = UpdateXSmooth(dt);
        var tryMovingY = UpdateYSmooth(dt);

        var moveX = mDirectionX != 0 && tryMovingX;
        var moveY = mDirectionY != 0 && tryMovingY;
        if ((moveX || moveY) && oldPos.x == mPosition.x && oldPos.y == mPosition.y)
        {
            NotifyReachedObstacle(
                moveX, moveY, 
                mDirectionX, mDirectionY,
                new Point(
                    mPosition.x - oldPos.x, 
                    mPosition.y - oldPos.y)
            );
        }

        if (mCheckOnFloorEnable) {
            CheckIsOnFloor();
        }
    }

    private function UpdateXSmooth(dt:Float)
    {
        var xMovingLength = mSpeedX * dt;
        var xMovingSteps = Math.ceil(Math.abs(xMovingLength));
        var xMovingPerStep = xMovingLength / xMovingSteps;

        var tryMoving = false;
        while(xMovingSteps > 0)
        {
            mAccumulatedXSteps = mAccumulatedXSteps + xMovingPerStep;
            while(mAccumulatedXSteps > 1 || mAccumulatedXSteps < 0) 
            {
                tryMoving = true;
                mAccumulatedXSteps = mAccumulatedXSteps - mDirectionX;

                if (CheckCollision(new Point(mDirectionX, 0)) == true) 
                {
                    xMovingSteps = 0;
                    mAccumulatedXSteps = 0;
                }
                else 
                {
                    Translate(new Point(mDirectionX, 0));
                }
            }
            xMovingSteps--;
        }

        return tryMoving;
    }

    private function UpdateYSmooth(dt:Float)
    {
        var yMovingLength = mSpeedY * dt;
        var yMovingSteps = Math.ceil(Math.abs(yMovingLength));
        var yMovingPerStep = yMovingLength / yMovingSteps;

        var tryMoving = false;
        while(yMovingSteps > 0)
        {
            mAccumulatedYSteps = mAccumulatedYSteps + yMovingPerStep;
            while(mAccumulatedYSteps > 1 || mAccumulatedYSteps < -1) 
            {
                tryMoving = true;
                mAccumulatedYSteps = mAccumulatedYSteps - mDirectionY;
                if (CheckCollision(new Point(0, mDirectionY)) == true) 
                {
                    yMovingSteps = 0;
                    mAccumulatedYSteps = 0;
                }
                else 
                {
                    Translate(new Point(0, mDirectionY));
                }
            }       
            yMovingSteps--;
        }

        return tryMoving;
    }

    override public function Dispose()
    {

    }

    public function SetSpeed(speedX:Float, speedY:Float)
    {
        SetSpeedX(speedX);
        SetSpeedY(speedY);
    }

    public function SetSpeedX(speed:Float)
    {
        if (Math.abs(mSpeedX - speed) < 1e-5) {
            return;
        }
        if (Math.abs(speed) < 1e-5) {
            speed = 0;
        }

        mSpeedX = speed;

        if (speed == 0)
        {
            mDirectionX = 0;
        }
        else 
        {
            if (speed > 0)
            {
                mDirectionX = 1;
            }
            else 
            {
                mDirectionX = -1;
            }
        }
    }

    public function SetSpeedY(speed:Float)
    {
      if (Math.abs(mSpeedY - speed) < 1e-5) {
            return;
        }
        if (Math.abs(speed) < 1e-5) {
            speed = 0;
        }

        mSpeedY = speed;

        if (speed == 0)
        {
            mDirectionY = 0;
        }
        else 
        {
            if (speed > 0)
            {
                mDirectionY = 1;
            }
            else 
            {
                mDirectionY = -1;
            }
        }
    }

    // TODO: optimize
    public function CheckCollision(offset:Point):Bool
    {
        var currentMap = mCurrentEntity.GetCurrentMap();
        if (currentMap != null)
        {
            var boundingBoxs = mCurrentEntity.GetComponents().GetComponentsByType(ComponentType_BoundingBox);
            if (boundingBoxs.length > 0)
            {
                var boundingBox:BoundingBox = cast(boundingBoxs[0], BoundingBox);
                var bound = boundingBox.mBound.clone();
                bound.x += offset.x;
                bound.y += offset.y;

                return currentMap.CheckCollision(bound, offset, mCurrentEntity);
            }
        }

        return true;
    }

    public function Translate(offset:Point)
    {
        SetPosition(new Point(
            offset.x + mPosition.x,
            offset.y + mPosition.y));
    }

    public function SetPosition(pos:Point)
    {
        if (mCurrentEntity != null)
        {
            mCurrentEntity.SetPosition(pos.x, pos.y);
        }
        mPosition = pos;
    }

    public function NotifyReachedObstacle(moveX:Bool, moveY:Bool, directionX:Int, directionY:Int, offset:Point)
    {
        mCurrentEntity.NotifyEntityEvent(EntityEvent_ObstacleReached);
        if (moveY && offset.y == 0)
        {

            SetSpeedY(0);
        }
    }

    private function CheckIsOnFloor()
    {
        mIsOnFloor = CheckCollision(new Point(0, 1));
    }

    public function SetCheckOnFloorEnable(enable)
    {
        mCheckOnFloorEnable = enable;

        if (enable == false) {
            mIsOnFloor = false;
        }
    }

    public function SetUpdateSmooth(smooth)
    {
        mUpdateSmooth = smooth;
    }

    public function GetSpeedX() { return mSpeedX;}
    public function GetSpeedY() { return mSpeedY;}
    public function IsOnFloor() { return mIsOnFloor;}
}