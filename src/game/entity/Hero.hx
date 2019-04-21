package game.entity;

import helper.AnimationSprite;
import hxd.Key;
import hxd.res.Image;
import hxd.Res;
import helper.Animation.AnimationOption;
import game.animationStates.NormalEntity;
import game.GameCommand;

class Hero extends Entity
{
    var mBody:AnimationSprite;

    public function new()
    {
        super("Hero", EntityType_Hero);

        mBody = CreateAnimationSprite("player");
        mBody.Play("idle");
        SetPosition(600, 200);

        var animationManger = GetAnimationManger();
        var idelState = NormalEntity.CreateIdelState(this);
        animationManger.AddState("idle", mBody, idelState);
        animationManger.AddState("walking", mBody);
    }

    override function Update(dt:Float)
    {
        super.Update(dt);
        
    }

    override function NotifyGameCommand(commandEvent:GameCommandEvent)
    {
        var dir = GetDirection();
        if (commandEvent.command == GameCommand_Right && commandEvent.isPressed)
        {
            dir = Directoin_Right;
        }
        else if(commandEvent.command == GameCommand_Left && commandEvent.isPressed)
        {
            dir = Direction_Left;
        }
        SetDirection(dir);
    }
}