package game.entity;

import hxd.Timer;
import helper.AnimationSprite;
import hxd.Key;
import hxd.res.Image;
import hxd.Res;
import helper.ParticleInst;
import helper.Animation.AnimationOption;
import game.animationStates.NormalEntity;
import game.GameCommand;
import game.component.BoundingBox;
import game.component.Movement;
import game.component.AccelMovement;
import game.entity.entityStates.PlayerNormalState;

//  TODO 
//  1.关于跳跃，希望实现一个EntityState，以达到不同主角状态下
//  对相同按键不同的响应
class Hero extends Entity
{
    private var mBody:AnimationSprite;
    private var mParticleInst:ParticleInstance;

    public function new()
    {
        super("Hero", EntityType_Hero);

        mBody = CreateAnimationSprite("player");
        mBody.Play("idle");
        SetPosition(600, 200);

        var animationManger = GetAnimationManger();
        animationManger.AddState("idle", mBody, NormalEntity.CreateIdelState(this));
        animationManger.AddState("walking", mBody, NormalEntity.CreateWalkingState(this));
        animationManger.AddState("startjumping", mBody, NormalEntity.CreateStartJumpingState(this));
        animationManger.AddState("endjumping", mBody, NormalEntity.CreateEndJumpingState(this));
        animationManger.RequestState("idle");

        var components = GetComponents();
        var movement = new AccelMovement("PlayerMove");
        movement.SetGravityEnable(true);
        movement.SetCheckCollisionEnable(true);
        movement.SetCheckOnFloorEnable(true);
        components.Add(movement);

        var boundingBox = new BoundingBox("BoundingBox", 6, 0, 20, 32);
        boundingBox.SetDebugEnable(false);
        components.Add(boundingBox);

        SetState(new PlayerWalkingState(this, "walking"));
    }

    override public function OnEnterMap()
    {
        var map = GetCurrentMap();
        mParticleInst = map.GetOrCreateParticleInst("dust");
    }

    override public function OnLeaveMap()
    {

    }

    override function Update(dt:Float)
    {
        super.Update(dt);
    }
}