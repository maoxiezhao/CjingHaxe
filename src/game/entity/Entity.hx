package game.entity;

import h2d.col.Point;
import h2d.Object;
import helper.Animation;
import helper.AnimationSprite;

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
    private var mLayer:Int = 0;
    public var mPos:Point = new Point(0, 0);
    public var mDir:Directions = Direction_Up;

    public var mBaseObject:Object;
    public var mEntityType:EntityType = EntityType_Unknown;
    public var mCurrentMap:GameMap;

    // TODO: Add Component, 将Animation、Movement实现为Component，
    public var mAnimations:Array<AnimationSprite>;

    public function new(name:String)
    {
        mName = name;
        mBaseObject = new Object();
        mBaseObject.setPosition(mPos.x, mPos.y);

        mAnimations = new Array();
    }

    public function Update(dt:Float)
    {
        for (animation in mAnimations)
        {
            animation.Dispose();
        }
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
        for (animation in mAnimations)
        {
            animation.Dispose();
        }
        mAnimations = null;

        mCurrentMap = null;
        mBaseObject = null;
    }

    public function SetLayer(layer:Int)
    {
        mLayer = layer;
    }

    public function GetLayer()
    {
        return mLayer;
    }

    public function CreateAnimationSprite(options:Array<AnimationOption>)
    {
        var animationSprite = new AnimationSprite(this, options);
        mAnimations.push(animationSprite);
        return animationSprite;
    }
}