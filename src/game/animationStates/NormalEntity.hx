package game.animationStates;

import helper.AnimationManager;
import helper.AnimationStateCaller;
import game.entity.Entity;

class NormalEntity
{
    public static function CreateIdelState(entity:Entity)
    {
        var state:AnimationStateCaller = new AnimationStateCaller();
        state.mEntity = entity;
        state.OnUpdate = function()
        {
          

        };

        return state;
    }

}