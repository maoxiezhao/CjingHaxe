package game.entity;

import helper.AnimationSprite;
import hxd.Key;
import hxd.res.Image;
import hxd.Res;
import helper.Animation.AnimationOption;
import helper.AnimationOptionLoader;

class Hero extends Entity
{
    var mBody:AnimationSprite;

    public function new()
    {
        super("Hero");
        mEntityType = EntityType_Hero;

        // TODO:加载文件必须放在
        var options:Array<AnimationOption> = new Array();
        var option:AnimationOption = AnimationOptionLoader.LoadFromJson("player_a");
        options.push(option);

        mBody = CreateAnimationSprite(options);
        mBody.Play("walk", mDir);

        SetPosition(600, 300);
    }
}