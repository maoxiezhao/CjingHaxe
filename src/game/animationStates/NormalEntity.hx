package game.animationStates;

import helper.AnimationManager;
import helper.AnimationStateCaller;
import game.entity.Entity;
import game.component.Movement;

// TODO: emmmm, is so stupid now...
class NormalEntity
{
    public static function CreateIdelState(entity:Entity)
    {
        var state:AnimationStateCaller = new AnimationStateCaller();
        state.mEntity = entity;
        state.OnUpdate = function()
        {
            if (entity != null)
            {
                var movementPtr = entity.GetComponents().GetComponent("PlayerMove");
                if (movementPtr == null) { 
                    state.mAnimationManger.RequestState("idle");
                    return;
                }

                var movement:Movement = cast(movementPtr, Movement);
                if (movement.IsOnFloor())
                {
                    if (movement.GetSpeedX() != 0) {
                        state.mAnimationManger.RequestState("walking");
                    }
                }
                else 
                {
                    state.mAnimationManger.RequestState("startjumping");
                }
            }
        };
        return state;
    }

    public static function CreateWalkingState(entity:Entity)
    {
        var state:AnimationStateCaller = new AnimationStateCaller();
        state.mEntity = entity;
        state.OnUpdate = function()
        {
            if (entity != null)
            {
                var movementPtr = entity.GetComponents().GetComponent("PlayerMove");
                if (movementPtr == null) { 
                    state.mAnimationManger.RequestState("idle");
                    return;
                }

                var movement:Movement = cast(movementPtr, Movement);
                if (movement.IsOnFloor())
                {
                    if (movement.GetSpeedX() == 0) {
                        state.mAnimationManger.RequestState("idle");
                    }
                }
                else 
                {
                    state.mAnimationManger.RequestState("startjumping");
                }
            }
        };
        return state;
    }

    public static function CreateStartJumpingState(entity:Entity)
    {
        var state:AnimationStateCaller = new AnimationStateCaller();
        state.mEntity = entity;
        state.OnUpdate = function()
        {
            if (entity != null)
            {
                var movementPtr = entity.GetComponents().GetComponent("PlayerMove");
                if (movementPtr == null) { 
                    state.mAnimationManger.RequestState("idle");
                    return;
                }

                var movement:Movement = cast(movementPtr, Movement);
                if (movement.IsOnFloor())
                {
                    if (movement.GetSpeedX() == 0)
                        state.mAnimationManger.RequestState("idle");
                    else
                        state.mAnimationManger.RequestState("walking");
                }
                else 
                {
                    if (movement.GetSpeedY() > 0) {
                        state.mAnimationManger.RequestState("endjumping");
                    }
                }
            }
        };
        return state;
    }

    public static function CreateEndJumpingState(entity:Entity)
    {
        var state:AnimationStateCaller = new AnimationStateCaller();
        state.mEntity = entity;
        state.OnUpdate = function()
        {
            if (entity != null)
            {
                var movementPtr = entity.GetComponents().GetComponent("PlayerMove");
                if (movementPtr == null) { 
                    state.mAnimationManger.RequestState("idle");
                    return;
                }

                var movement:Movement = cast(movementPtr, Movement);
                if (movement.IsOnFloor())
                {
                    if (movement.GetSpeedX() == 0)
                        state.mAnimationManger.RequestState("idle");
                    else
                        state.mAnimationManger.RequestState("walking");
                }
            }
        };
        return state;
    }
}