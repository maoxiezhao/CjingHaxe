package helper;

import helper.Animation;
import game.entity.Entity;

class AnimationSprite
{
    public var mAnimationMap:Map<String, Animation>;
    public var mAnimationArray:Array<Animation>;
    public var mCurrentAnimation:Animation;
    
    public function new(entity:Entity, options:Array<AnimationOption>)
    {
        mAnimationMap = new Map();
        mAnimationArray = new Array();

        for(option in options)
        {
            var name = option.name;
            var animation = new Animation(option);
            mAnimationMap.set(name, animation);
            mAnimationArray.push(animation);

            entity.mBaseObject.addChild(animation.mAnimPlayer);
        }

        if (mAnimationArray.length > 0) {
            mCurrentAnimation = mAnimationArray[0];
        }
    }

    public function Play(animName:String, dir:Directions, ?endCallBack:Void -> Void)
    {
        if (mCurrentAnimation != null)
        {
            mCurrentAnimation.Stop();
            mCurrentAnimation = null;
        }

        var animation = mAnimationMap.get(animName);
        if (animation != null)
        {
            mCurrentAnimation = animation;
            mCurrentAnimation.Play(dir, endCallBack);
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

}