package game.entity;

import h2d.col.Point;
import h2d.Object;
import game.GameCommand;
import game.entity.EntityInclude;
import helper.Animation;
import helper.AnimationSprite;
import helper.AnimationOptionLoader;
import helper.AnimationManager;


// base entity class
// TODO: 1.add paused status 
class Entity
{
    private var mName:String = "";
    private var mLayer:Int = 0;
    private var mEntityType:EntityType = EntityType_Unknown;
    private var mPos:Point = new Point(0, 0);
    private var mDir:Directions = Direction_Left;

    public var mBaseObject:Object;
    public var mCurrentMap:GameMap;

    // TODO: move other places
    public var mAnimationManager:AnimationManager;

    // TODO: Add Component, 将Animation、Movement实现为Component，
    public var mAnimations:Array<AnimationSprite>;

    public function new(name:String, entityType:EntityType)
    {
        mName = name;
        mEntityType = entityType;
        mBaseObject = new Object();
        mBaseObject.setPosition(mPos.x, mPos.y);

        mAnimationManager = new AnimationManager();
        mAnimations = new Array();
    }

    public function Update(dt:Float)
    {
        for (animation in mAnimations) {
            animation.Update(dt);
        }
        mAnimationManager.Update(dt);
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

    public function CreateAnimationSpriteFromOptions(options:Array<AnimationOption>)
    {
        var animationSprite = new AnimationSprite(this, options);
        animationSprite.SetCurrentDirection(mDir);
        mAnimations.push(animationSprite);
        return animationSprite;
    }

    public function CreateAnimationSprite(path:String)
    {
        var options:Array<AnimationOption> = AnimationOptionLoader.LoadFromJson(path);
        return CreateAnimationSpriteFromOptions(options);
    }

    public function GetAnimationManger()
    {
        return mAnimationManager;
    }

    public function GetDirection(){ return mDir;}
    public function SetDirection(dir:Directions)
    {
        if (mDir != dir)
        {
            mDir = dir;
            for (animation in mAnimations) {
                animation.SetCurrentDirection(dir);
            }
        }
    }

    public function NotifyGameCommand(commandEvent:GameCommandEvent)
    {
        
    }
}