package helper;

import hxd.Math;
import hxd.Rand;

class IDGenerater
{
    public static var mRand:hxd.Rand = new Rand(1000);
    static public function GenerateID()
    {
        return mRand.random(0x3FFFFFFF);
    }
}

class BaseObject
{
    private var mHashKey:UInt = 0;
    public function new()
    {
        mHashKey = IDGenerater.GenerateID();
    }

    public function GetHashKey()
    {
        return mHashKey;
    }
}