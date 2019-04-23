package helper;

import hxd.Timer;
import Std;

class CoolDownTimer
{
    public var mFlagDurationsMap:Map<String, UInt>;
    public var mRemovedFlagDurations:Array<String>;
    public var mSuspensed:Bool = false;

    public function new()
    {
        mFlagDurationsMap = new Map();
        mRemovedFlagDurations = new Array();
    }

    public function Dispose()
    {
        mFlagDurationsMap = null;
    }

    public function Update(dt:Float)
    {
        if (mSuspensed == true) {
            return;
        }

        var currentTime = Std.int(Timer.lastTimeStamp * 1000);
        for (key => expirationTime in mFlagDurationsMap)
        {
            if (currentTime >= expirationTime) {
                mRemovedFlagDurations.push(key);
            }
        }

        if (mRemovedFlagDurations.length > 0) 
        {
            for(removedFlag in mRemovedFlagDurations) {
                mFlagDurationsMap.remove(removedFlag);
            }
            mRemovedFlagDurations.resize(0);    // emmmm, need to do
        }
    }

    public function SetDuration(flag:String, duration:UInt)
    {
        var expirationTime = Std.int(Timer.lastTimeStamp * 1000) + duration;
        mFlagDurationsMap.set(flag, expirationTime);
    }

    public function IsFinished(flag:String)
    {
        return mFlagDurationsMap.exists(flag);
    }
}