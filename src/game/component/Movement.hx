package game.component;

import h2d.col.Point;
import h3d.mat.Data.Face;
import game.Component;
import game.entity.Entity;

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
    private var mNextMoveYTIme:UInt = 0;
    private var mDurationY:UInt = 0;

    private var mPosition:Point;

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

        if (moveX == true)
        {
            if (CheckCollision(new Point(mDirectionX, 0)) == true)
            {
                Translate(new Point(mDirectionX, 0));
            }
            mNextMoveXTime = now + mDurationX;
        }
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

    }

    public function CheckCollision(position:Point):Bool
    {
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
}