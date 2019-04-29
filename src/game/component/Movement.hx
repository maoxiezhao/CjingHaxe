package game.component;

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
    
    private var mNextMoveXTime:UInt = 0;
    private var mDurationX:UInt = 0;
    private var mNextMoveYTime:UInt = 0;
    private var mDurationY:UInt = 0;

    private var mPosition:Point;
    private var mUpdateSmooth:Bool = false;

    public function new(name:String)
    {
        super(name, ComponentType_Movement);
    }

    override public function AddedImpl()
    {
        mPosition = mCurrentEntity.GetPosition();
    }

    override public function Update(dt:Float)
    {
        var now = System.Now();
        var moveX = mDirectionX != 0 && now >= mNextMoveXTime;
        var moveY = mDirectionY != 0 && now >= mNextMoveYTime;

        while (moveX || moveY)
        {
            if (mUpdateSmooth == true) {
                UpdateXYSmooth(now, moveX, moveY);
            }
            else {
                UpdateXY(now, moveX, moveY);
            }
            
            moveX = mDirectionX != 0 && now >= mNextMoveXTime;
            moveY = mDirectionY != 0 && now >= mNextMoveYTime;
        }
    }

    public function UpdateXY(now:UInt, moveX:Bool, moveY:Bool)
    {
        var oldPos = mPosition.clone();
        if (moveX)
        {
            if (moveY)
            {
                if (CheckCollision(new Point(mDirectionX, mDirectionY)) == true) {
                    Translate(new Point(mDirectionX, mDirectionY));
                }
                mNextMoveXTime = mNextMoveXTime + mDurationX;
                mNextMoveYTime = mNextMoveYTime + mDurationY;
            }
            else 
            {
                if (CheckCollision(new Point(mDirectionX, 0)) == true) {
                    Translate(new Point(mDirectionX, 0));
                }
                mNextMoveXTime = mNextMoveXTime + mDurationX;
            }
        }
        else 
        {
            if (CheckCollision(new Point(0, mDirectionY)) == true) {
                Translate(new Point(0, mDirectionY));
            }
            mNextMoveYTime = mNextMoveYTime + mDurationY;
        }

        if ((moveX || moveY) && oldPos == mPosition) {
            NotifyReachedObstacle(moveX, moveY, 
                new Point(mPosition.x - oldPos.x, mPosition.y - oldPos.y));
        }
    }

    public function UpdateXYSmooth(now:UInt, moveX:Bool, moveY:Bool)
    {
        var oldPos = mPosition.clone();
        if (moveX)
        {
            if (moveY)
            {
                if (mNextMoveXTime <= mNextMoveYTime) 
                {
                    UpdateXSmooth();
                    if (now >= mNextMoveYTime) {
                        UpdateYSmooth();
                    }
                }
                else 
                {
                    UpdateYSmooth();
                    if (now >= mNextMoveXTime) {
                        UpdateXSmooth();
                    }
                }
            }
            else 
            {
                UpdateXSmooth();
            }
        }
        else 
        {
            UpdateYSmooth();
        }

        if ((moveX || moveY) && oldPos == mPosition) {
            NotifyReachedObstacle(moveX, moveY, 
                new Point(mPosition.x - oldPos.x, mPosition.y - oldPos.y));
        }
    }

    private function UpdateXSmooth()
    {
        if (mDirectionX != 0)
        {

            if (CheckCollision(new Point(mDirectionX, 0)) == true) {
                Translate(new Point(mDirectionX, 0));
            }
            else 
            {
                // can't move x, try give a y offset
                if (mDirectionY == 0)
                {
                    
                } 
            }
            mNextMoveXTime = mNextMoveXTime + mDurationX;
        }
    }

    private function UpdateYSmooth()
    {

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
            mDurationX = 0;
            mDirectionX = 0;
        }
        else 
        {
            if (speed > 0)
            {
                mDurationX = Math.floor(1000.0 / speed);
                mDirectionX = 1;
            }
            else 
            {
                mDurationX = Math.floor(1000.0 / -speed);
                mDirectionX = -1;
            }

            mNextMoveXTime = System.Now() + mDurationX;
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
            mDurationY = 0;
            mDirectionY = 0;
        }
        else 
        {
            if (speed > 0)
            {
                mDurationY = Math.floor(1000.0 / speed);
                mDirectionY = 1;
            }
            else 
            {
                mDurationY = Math.floor(1000.0 / -speed);
                mDirectionY = -1;
            }

            mNextMoveYTime = System.Now() + mDurationY;
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

    public function NotifyReachedObstacle(moveX:Bool, moveY:Bool, offset:Point)
    {
        mCurrentEntity.NotifyEntityEvent(EntityEvent_ObstacleReached);
    }
}