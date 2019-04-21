package game.entity;

import helper.AnimationSprite;
import hxd.Key;
import hxd.res.Image;
import hxd.Res;
import helper.Animation.AnimationOption;
import game.animationStates.NormalEntity;

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
        
        var dir = GetDirection();
        if (Key.isDown(Key.RIGHT))
        {
            dir = Directoin_Right;
        }
        else if(Key.isDown(Key.LEFT))
        {
            dir = Direction_Left;
        }
        SetDirection(dir);
    }
}