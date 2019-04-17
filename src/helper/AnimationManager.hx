package helper;

import helper.Animation.Directions;
import helper.AnimationSprite;

typedef AnimationState = {
    ?name:String,
    ?animation:AnimationSprite
}

typedef AnimationTransition = {
    fromName:String, 
    toName:String
}

typedef AnimationCondition = {
    name:String,
    priority:Int,
    condition:Void->Bool
}

// TODO:
// 1.add callback after animation finished
// 2.support state condition
class AnimationManager
{
    public var mAnimationStates:Map<String, AnimationState>;
    public var mAnimationTransitions:Map<String, Map<String, Bool>>;
    public var mCurrentState:AnimationState = null;
    public var mNextState:AnimationState = null;

    public var mAnimationConditions:Map<String, AnimationCondition>;

    public function new()
    {
        mAnimationStates = new Map();
        mAnimationTransitions = new Map();
        mAnimationConditions = new Map();
    }

    public function AddState(name:String, animation:AnimationSprite)
    {
        var animationState:AnimationState = {};
        animationState.name = name;
        animationState.animation = animation;

        mAnimationStates.set(name, animationState);
    }

    // 强制设置当前状态
    public function SetState(name:String)
    {
        if (HasState(name) == true)
        {
            if (mCurrentState != null) {
                ClearAnimation(mCurrentState);
                mCurrentState = null;
            }
            if (mNextState != null) {
                ClearAnimation(mNextState);
                mNextState = null;
            }

            mCurrentState = mAnimationStates.get(name);
            InitializeAnimation(mCurrentState);
        }
    }

    public function RequestState(name:String)
    {
        if (HasState(name) && mNextState == null)
        {
            if (mCurrentState == null) 
            {
                SetState(name);
            }
            else 
            {
                mNextState = mAnimationStates.get(name);
            }
        }
    }

    public function HasState(name:String)
    {
        return mAnimationStates.exists(name);
    }

    private function InitializeAnimation(state:AnimationState)
    {
        if (state != null && state.animation != null) {
            var dir:Directions = state.animation.mCurrentDirection;
            state.animation.Play(state.name, dir);
        }
    }

    private function ClearAnimation(state:AnimationState)
    {
        if (state != null && state.animation != null) {
            state.animation.StopAll();
        }
    }

    // 添加状态机条件函数，当条件满足时会自动requestState
    public function RegisterStateCondition(name:String, priority:Int, condition:Void->Bool, ?is_force:Bool = false)
    {

    }

    public function Update(dt:Float)
    {
        // 暂时不处理trnasition
        if (mNextState != null)
        {
            if (mCurrentState != null) {
                ClearAnimation(mCurrentState);
                mCurrentState = null;
            }

            mCurrentState = mNextState;
            mNextState = null;
            
            InitializeAnimation(mCurrentState);
        }
    }
}