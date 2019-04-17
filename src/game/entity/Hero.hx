package game.entity;

import helper.AnimationSprite;
import hxd.Key;
import hxd.res.Image;
import hxd.Res;
import helper.Animation.AnimationOption;

class Hero extends Entity
{
    var mBody:AnimationSprite;

    public function new()
    {
        super("Hero", EntityType_Hero);

        mBody = CreateAnimationSprite("player_a");
        mBody.Play("walking", mDir);

        SetPosition(600, 300);

        var animationManger = GetAnimationManger();
        animationManger.AddState("walking", mBody);
        animationManger.AddState("shifting", mBody);
    }
}