package helper;

import h2d.Object;
import helper.Animation;
import game.entity.Entity;

// TODO:refacto animation 
// 目前保存了所有的Animation,只在BaseObject中添加当前正在播放的player，如果停止则从baseObject中移除
class AnimationSprite
{
    public var mAnimationMap:Map<String, Animation>;
    public var mAnimationArray:Array<Animation>;
    public var mCurrentAnimation:Animation;
    public var mCurrentDirection:Directions = Directoin_Right;
    public var mBaseObject:Object;

    public function new(entity:Entity, options:Array<AnimationOption>)
    {
        mAnimationMap = new Map();
        mAnimationArray = new Array();

        mBaseObject = new Object();
        entity.mBaseObject.addChild(mBaseObject);
        
        for(option in options)
        {
            var name = option.name;
            var animation = new Animation(option);
            mAnimationMap.set(name, animation);
            mAnimationArray.push(animation);
        }

        if (mAnimationArray.length > 0) {
            mCurrentAnimation = mAnimationArray[0];
        }
    }

    public function Play(animName:String, ?force_dir:Directions, ?endCallBack:Void -> Void)
    {
        if (mCurrentAnimation != null)
        {
            mBaseObject.removeChild(mCurrentAnimation.mAnimPlayer);
            mCurrentAnimation.Stop();
            mCurrentAnimation = null;
        }

        var animation = mAnimationMap.get(animName);
        if (animation != null)
        {
            mCurrentAnimation = animation;

            var dir = mCurrentDirection;
            if (force_dir != null) {
                dir = force_dir;
            }
            mCurrentAnimation.Play(dir, endCallBack);
            mBaseObject.addChild(mCurrentAnimation.mAnimPlayer);
        }
    }

    public function StopAll()
    {
        if (mCurrentAnimation != null)
        {
            mCurrentAnimation.Stop();
            mCurrentAnimation.mAnimPlayer.remove();
            mCurrentAnimation = null;
        }
    }

    public function Dispose()
    {
        for (animation in mAnimationArray) {
            animation.Dispose();
        }
        mAnimationArray = null;
        mAnimationMap = null;
    }

    public function Update(dt:Float)
    {
        for (animation in mAnimationArray) {
            animation.Update(dt);
        }
    }

    public function SetCurrentDirection(direction:Directions)
    {
        mCurrentDirection = direction;

        // TODO:更改方向，直接改动画可能有问题
        if (mCurrentAnimation != null)
        {
            mCurrentAnimation.Stop();
            mCurrentAnimation.Play(mCurrentDirection);
        }
    }
}