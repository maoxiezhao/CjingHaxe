package helper;

import hxd.Timer;

class System
{
    // TODO.int -> UInt 
    static public function Now():UInt
    {
        return Std.int(Timer.lastTimeStamp * 1000);
    }
}