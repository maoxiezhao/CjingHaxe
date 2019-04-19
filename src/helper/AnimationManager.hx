package helper;

import helper.Animation.Directions;
import helper.AnimationSprite;

typedef AnimationStateFunc = {
    ?onEnter:Void->Void,
    ?onUpdate:Void->Void,
    ?onLeave:Void->Void
}

typedef AnimationState = {
    ?name:String,
    ?animation:AnimationSprite,
    ?func:AnimationStateFunc
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
// 1. use transition condition or state func??, use state func now.
class AnimationManager
{
    public var mAnimationStates:Map<String, AnimationState>;
    public var mAnimationTransitions:Map<String, Map<String, Bool>>;
    public var mCurrentState:AnimationState = null;
    public var mNextState:AnimationState = null;

    private var mGlobalAnimationConditionEnable:Bool = false;
    private var mGlobalAnimationConditions:Array<AnimationCondition>;

    public function new()
    {
        mAnimationStates = new Map();
        mAnimationTransitions = new Map();
        mGlobalAnimationConditions = new Array();
    }

    public function AddState(name:String, animation:AnimationSprite, ?func:AnimationStateFunc)
    {
        var animationState:AnimationState = {};
        animationState.name = name;
        animationState.animation = animation;
        animationState.func = func;

        mAnimationStates.set(name, animationState);
    }

    // 强制设置当前状态
    public function SetState(name:String)
    {
        if (HasState(name) == true)
        {
            if (mNextState != null) {
                LeaveState(mNextState);
                mNextState = null;
            }

            if (mCurrentState != null && mCurrentState.name == name) {
                return;
            }

            if (mCurrentState != null) 
            {
                LeaveState(mCurrentState);
                mCurrentState = null;
            }
            
            mCurrentState = mAnimationStates.get(name);
            EnterState(mCurrentState);
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
                if (mCurrentState.name == name){
                    return;
                }
                mNextState = mAnimationStates.get(name);
            }
        }
    }

    public function HasState(name:String)
    {
        return mAnimationStates.exists(name);
    }

    private function EnterState(state:AnimationState)
    {
        if (state.func != null && state.func.onEnter != null) {
            state.func.onEnter();
        }

        if (state != null && state.animation != null) {
            var dir:Directions = state.animation.mCurrentDirection;
            state.animation.Play(state.name, dir);
        }
    }

    private function LeaveState(state:AnimationState)
    {
        if (state.func != null && state.func.onLeave != null) {
            state.func.onLeave();
        }

        if (state != null && state.animation != null) {
            state.animation.StopAll();
        }
    }

    // 添加状态机条件函数，当条件满足时会自动requestState
    public function RegisterStateCondition(name:String, priority:Int, condition:Void->Bool, ?is_force:Bool = false)
    {
        if (condition == null)
            return;

        mGlobalAnimationConditions.push({
            name:name,
            priority: priority,
            condition: condition
        });
        mGlobalAnimationConditions.sort(function(a, b) 
            return -Reflect.compare(a.priority, b.priority));
    }

    public function RemoveStateCondition(name:String, priority:Int)
    {
        for(condition in mGlobalAnimationConditions)
        {
            if (condition.name == name && condition.priority == priority)
            {
                mGlobalAnimationConditions.remove(condition);
                break;
            }
        }
    }

    public function Update(dt:Float)
    {
        if (mNextState != null)
        {
            if (mCurrentState != null) {
                LeaveState(mCurrentState);
                mCurrentState = null;
            }

            mCurrentState = mNextState;
            EnterState(mCurrentState);

            mNextState = null;
        }

        if (mGlobalAnimationConditionEnable == true) 
        {
            for (condition in mGlobalAnimationConditions)
            {
                if (condition.condition())
                {
                    RequestState(condition.name);
                    break;
                }
            }
        }

        if (mCurrentState != null)
        {
            if (mCurrentState.func != null && mCurrentState.func.onUpdate != null)
                mCurrentState.func.onUpdate();
        }
    }

    public function SetGlobalAnimationConditonEnable(enable:Bool)
    {
        mGlobalAnimationConditionEnable = enable;
    }
}