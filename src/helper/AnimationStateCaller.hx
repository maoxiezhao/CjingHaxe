package helper;

import game.entity.Entity;
import helper.AnimationManager;

class AnimationStateCaller
{
    public var mName:String;
    public var mAnimationManger:AnimationManager = null;
    public var mEntity:Entity = null;

    public var OnEnter:Void->Void;
    public var OnUpdate:Void->Void;
    public var OnLeave:Void->Void;

    public function new()
    {        
        OnEnter = function() {return;};
        OnUpdate = function() {return;};
        OnLeave = function() {return;};
    }
}