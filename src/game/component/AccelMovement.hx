package game.component;

import h2d.col.Point;
import helper.System;

class AccelMovement extends Movement
{
    private var mMaxSpeedX:Float = 256;
    private var mMaxUpSpeedY:Float = 256;
    private var mMaxDownSpeedY:Float = -320;

    private var mSpeedXAccel:Float = 0;
    private var mSpeedYAccel:Float = 0;
    private var mAccelDirectionX:Float = 0;
    private var mAccelDirectionY:Float = 0;

    static public var gGravityAccel:Float = 800;
    static public var gMaxUpdateDuration:UInt = 16;

    public function new(name:String)
    {
        super(name);
    }

    override public function Update(dt:Float)
    {
        UpdateSpeed(dt);

        super.Update(dt);
    }

    public function UpdateSpeed(dt:Float)
    {
        var updateX = mAccelDirectionX != 0;
        if (updateX)
        {
            var speedX = GetSpeedX() + mSpeedXAccel * dt;
            if (Math.abs(speedX) >= mMaxSpeedX) {
                speedX = (speedX > 0) ? mMaxSpeedX : -mMaxSpeedX;
            }
            SetSpeedX(speedX);
        }

        var updateY = mAccelDirectionY != 0;
        if (updateY)
        {
            var speedY = GetSpeedY() + mSpeedYAccel * dt;
            if (speedY > mMaxUpSpeedY || speedY < mMaxDownSpeedY) {
                speedY = (speedY > 0) ? mMaxUpSpeedY : mMaxDownSpeedY;
            }
            SetSpeedY(speedY);
        }
    }

    public function SetSpeedXAccel(accel:Float)
    {
        if (Math.abs(mSpeedXAccel - accel) < 1e-5) {
            return;
        }

        mSpeedXAccel = accel;

        if (accel == 0)
        {
            mAccelDirectionX = 0;
        }
        else 
        {
            if (accel > 0)
            {
                mAccelDirectionX = 1;
            }
            else 
            {
                mAccelDirectionX = -1;
            }
        }
    }

    public function SetSpeedYAccel(accel:Float)
    {
        if (Math.abs(mSpeedYAccel - accel) < 1e-5) {
            return;
        }

        mSpeedYAccel = accel;

        if (accel == 0)
        {
            mAccelDirectionY = 0;
        }
        else 
        {
            if (accel > 0)
            {
                mAccelDirectionY = 1;
            }
            else 
            {
                mAccelDirectionY = -1;
            }
        }
    }

    public function SetGravityEnable(enable)
    {
        if (enable) {
            SetSpeedYAccel(gGravityAccel);
        }
        else {
            SetSpeedYAccel(0);
        }
    }
}