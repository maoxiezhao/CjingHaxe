package game.entity;

import h2d.col.Point;
import h2d.Object;
import game.GameCommand;
import game.Component;
import game.entity.EntityInclude;
import game.entity.entityStates.EntityState;
import helper.Animation;
import helper.AnimationSprite;
import helper.AnimationOptionLoader;
import helper.AnimationManager;
import helper.CoolDownTimer;

// base entity class
// TODO: 1.add paused status 
class Entity
{
    private var mName:String = "";
    private var mLayer:Int = 1;
    private var mEntityType:EntityType = EntityType_Unknown;
    private var mPos:Point = new Point(0, 0);
    private var mWidth:Int = 0;
    private var mHeight:Int = 0;
    private var mDir:Directions = Direction_Left;
    private var mIsBeRemoved:Bool = false;

    public var mBaseObject:Object;
    public var mCurrentMap:GameMap;
    public var mCoolDownTimer:CoolDownTimer;
    public var mEventManagement:EventManagement;

    private var mCurrentState:EntityState;
    private var mPrevStates:EntityState;

    // TODO: will refactor component
    private var mComponents:ComponentManager;

    // TODO: move other places
    private var mAnimationManager:AnimationManager;

    // TODO: Add Component, 将Animation、Movement实现为Component，
    private var mAnimations:Array<AnimationSprite>;

    public function new(name:String, entityType:EntityType)
    {
        mName = name;
        mEntityType = entityType;
        mBaseObject = new Object();
        mBaseObject.setPosition(mPos.x, mPos.y);

        mComponents = new ComponentManager(this);

        mCoolDownTimer = new CoolDownTimer();
        mEventManagement = new EventManagement();
        mAnimationManager = new AnimationManager();
        mAnimations = new Array();
    }

    public function Dispose()
    {
        mComponents.Dispose();
        
        for (animation in mAnimations)
        {
            animation.Dispose();
        }
        mAnimations = null;

        mCoolDownTimer.Dispose();

        mCurrentMap = null;
        mBaseObject = null;
    }

    public function Update(dt:Float)
    {
        mCoolDownTimer.Update(dt);
        
        mComponents.Update(dt);

        UpdateState(dt);

        for (animation in mAnimations) {
            animation.Update(dt);
        }
        mAnimationManager.Update(dt);
    }

    public function GetName()
    {
        return mName;
    }

    public function SetSize(width:Int, height:Int)
    {
        mWidth = width;
        mHeight = height;
    }

    public function SetPositionX(x:Float) {SetPosition(x, mPos.y);}
    public function SetPositionY(y:Float) {SetPosition(mPos.x, y);}
    public function SetPosition(x:Float, y:Float)
    {
        mPos.x = x;
        mPos.y = y;
        mBaseObject.setPosition(x, y);

        NotifyEntityEvent(EntityEvent_PositionChanged);
    }
    public function GetPosition() { return mPos; }

    public function GetCenterPos() 
    {
        return new Point(
            mPos.x + mWidth * 0.5, 
            mPos.y + mHeight * 0.5
        );
    } 

    public function SetCurrentMap(map:GameMap)
    {
        mCurrentMap = map;
    }

    public function GetCurrentMap()
    {
        return mCurrentMap;
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

    public function GetComponents()
    {
        return mComponents;
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

    public function GetEntityType() 
    { 
        return mEntityType; 
    }

    public function GetGameCommmands()
    {
        if (mCurrentMap != null)
        {
            var currentGame = mCurrentMap.mCurrentGame;
            if (currentGame != null) {
                return currentGame.mGameCommandManager;
            }
        }
        return null;
    }

    public function NotifyGameCommand(commandEvent:GameCommandEvent) 
    {
        if (mCurrentState != null) {
            mCurrentState.NotifyGameCommand(commandEvent);
        }
    }

    public function RegisterEntityEventCallback(event:EntityEvent, callback:Void->Void)
    {
        mEventManagement.Add(event, callback);
    }

    public function NotifyEntityEvent(event:EntityEvent)
    {
        mEventManagement.NotifyEvent(event);
    }

    public function SetState(state:EntityState)
    {
        var prevState = mCurrentState;
        if (prevState != null)
        {
            prevState.Stop(state);
            mCurrentState = null;
        }

        if (state != null)
        {
            mCurrentState = state;
            mCurrentState.Start(prevState);
        }
    }

    public function UpdateState(dt:Float)
    {
        if (mCurrentState != null) {
            mCurrentState.Update(dt);
        }
    }

    public function SetIsBeRemoved()
    {
        if (mIsBeRemoved == false) 
        {
            NotifyEntityEvent(EntityEvent_ToBeRemoved);
            mIsBeRemoved = true;
        }
    }

    public function GetIsBeRemoved() { return mIsBeRemoved; }
}