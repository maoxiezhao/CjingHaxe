package helper;

import h2d.col.Point;
import hxd.Timer;

class System
{
    static public var mScreenSize:Point = new h2d.col.Point();

    // TODO.int -> UInt 
    static public function Now():UInt
    {
        return Std.int(Timer.lastTimeStamp * 1000);
    }

    static public function GetScreenSize():Point
    {
        return mScreenSize;
    }
}