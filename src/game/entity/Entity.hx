package game.entity;

import h2d.col.Point;
import h2d.Object;

enum EntityType
{
    EntityType_Unknown;
    EntityType_Hero;
    EntityType_Camera;
}

// base entity class
class Entity
{
    private var mName:String = "";
    public var mPos:Point = new Point(0, 0);
    public var mBaseObject:Object;
    public var mEntityType:EntityType = EntityType_Unknown;
    public var mCurrentMap:GameMap;

    public function new(name:String)
    {
        mName = name;
        mBaseObject = new Object();
        mBaseObject.setPosition(mPos.x, mPos.y);
    }

    public function Update(dt:Float)
    {
        
    }

    public function GetName()
    {
        return mName;
    }

    public function SetPosition(x:Float, y:Float)
    {
        mPos.x = x;
        mPos.y = y;
        mBaseObject.setPosition(x, y);
    }

    public function SetCurrentMap(map:GameMap)
    {
        mCurrentMap = map;
    }

    public function Dispose()
    {
        mCurrentMap = null;
        mBaseObject = null;
    }
}