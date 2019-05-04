package game.component;

import h2d.col.Point;
import helper.System;

class AccelMovement extends Movement
{
    private var mMaxSpeedX:Float = 256;
    private var mMaxSpeedY:Float = 256;

    // the unit is pixel/s
    private var mSpeedXAccel:Float = 0;
    private var mSpeedYAccel:Float = 0;
    private var mAccelDirectionX:Float = 0;
    private var mAccelDirectionY:Float = 0;

    private var mNextUpdateSpeedXTime:UInt = 0;
    private var mDurationUpdateSpeedX:UInt = 0;
    private var mNextUpdateSpeedYTime:UInt = 0;
    private var mDurationUpdateSpeedY:UInt = 0;

    static public var gGravityAccel:Float = 352;
    static public var gMaxUpdateDuration:UInt = 8;

    public function new(name:String)
    {
        super(name);
    }

    override public function Update(dt:Float)
    {
        UpdateSpeed();

        super.Update(dt);
    }

    public function UpdateSpeed()
    {
        var now = System.Now();
        var updateX = mAccelDirectionX != 0 && now >= mNextUpdateSpeedXTime;
        var updateY = mAccelDirectionY != 0 && now >= mNextUpdateSpeedYTime;

        while (updateX || updateY)
        {
            if (updateX)
            {
                var speedX = GetSpeedX() + mAccelDirectionX;
                if (Math.abs(speedX) >= mMaxSpeedX) {
                    speedX = (speedX > 0) ? mMaxSpeedX : -mMaxSpeedX;
                }
                SetSpeedX(speedX);

                mNextUpdateSpeedXTime += mDurationUpdateSpeedX;
            }

            if (updateY)
            {
                var speedY = GetSpeedY() + mAccelDirectionY;
                if (Math.abs(speedY) >= mMaxSpeedY) {
                    speedY = (speedY > 0) ? mMaxSpeedY : -mMaxSpeedY;
                }
                SetSpeedY(speedY);

                mNextUpdateSpeedYTime += mDurationUpdateSpeedY;
            }

            updateX = mAccelDirectionX != 0 && now >= mNextUpdateSpeedXTime;
            updateY = mAccelDirectionY != 0 && now >= mNextUpdateSpeedYTime;
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
            mDurationUpdateSpeedX = 0;
            mAccelDirectionX = 0;
        }
        else 
        {
            if (accel > 0)
            {
                mDurationUpdateSpeedX = Math.floor(1000.0 / accel);
                mAccelDirectionX = 1;
            }
            else 
            {
                mDurationUpdateSpeedX = Math.floor(1000.0 / -accel);
                mAccelDirectionX = -1;
            }

            // 对与加速度而言无需保证每次更新1单位速度
            if (mDurationUpdateSpeedX < gMaxUpdateDuration)
            {
                mAccelDirectionX *= (gMaxUpdateDuration / mDurationUpdateSpeedX);
                mDurationUpdateSpeedX = gMaxUpdateDuration;
            }

            mNextUpdateSpeedXTime = System.Now() + mDurationUpdateSpeedX;
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
            mDurationUpdateSpeedY = 0;
            mAccelDirectionY = 0;
        }
        else 
        {
            if (accel > 0)
            {
                mDurationUpdateSpeedY = Math.floor(1000.0 / accel);
                mAccelDirectionY = 1;
            }
            else 
            {
                mDurationUpdateSpeedY = Math.floor(1000.0 / -accel);
                mAccelDirectionY = -1;
            }

            if (mDurationUpdateSpeedY < gMaxUpdateDuration)
            {
                mAccelDirectionY *= (gMaxUpdateDuration / mDurationUpdateSpeedY);
                mDurationUpdateSpeedY = gMaxUpdateDuration;
            }

            mNextUpdateSpeedYTime = System.Now() + mDurationUpdateSpeedY;
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