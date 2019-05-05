package game.entity;

import hxd.Timer;
import helper.AnimationSprite;
import hxd.Key;
import hxd.res.Image;
import hxd.Res;
import helper.Animation.AnimationOption;
import game.animationStates.NormalEntity;
import game.GameCommand;
import game.component.BoundingBox;
import game.component.Movement;
import game.component.AccelMovement;

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
        animationManger.AddState("idle", mBody, NormalEntity.CreateIdelState(this));
        animationManger.AddState("walking", mBody, NormalEntity.CreateWalkingState(this));
        animationManger.AddState("startjumping", mBody, NormalEntity.CreateStartJumpingState(this));
        animationManger.AddState("endjumping", mBody, NormalEntity.CreateEndJumpingState(this));
        animationManger.RequestState("idle");

        var components = GetComponents();
        var movement = new AccelMovement("PlayerMove");
        movement.SetGravityEnable(true);
        movement.SetUpdateSmooth(true);
        components.Add(movement);

        var boundingBox = new BoundingBox("BoundingBox", 6, 0, 20, 32);
        boundingBox.SetDebugEnable(false);
        components.Add(boundingBox);
    }

    override function Update(dt:Float)
    {
        super.Update(dt);
        
        var movement:Movement = cast(GetComponents().GetComponent("PlayerMove"), Movement);
        var gameCommands = GetGameCommmands();
        if (gameCommands != null)
        {
            if (gameCommands.IsCommandPressed(GameCommand_Right)) 
            {
                movement.SetSpeedX(200);
            }
            else if (gameCommands.IsCommandPressed(GameCommand_Left)) 
            {
                movement.SetSpeedX(-200);
            }
            else 
            {
                movement.SetSpeedX(0);
            }
        }
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

        if (commandEvent.command == GameCommand_Jump && commandEvent.isPressed)
        {
            TryJumping();
        }
    }
    
    // TODO
    public function GetGameCommmands()
    {
        if (mCurrentMap != null)
        {
            var currentGame = mCurrentMap.mCurrentGame;
            if (currentGame != null) {
                return currentGame.mGameCommandManager;
            }
        }
        return null;
    }

    public function TryJumping()
    {
        var movement:Movement = cast(GetComponents().GetComponent("PlayerMove"), Movement);
        if (movement.IsOnFloor()) {
            movement.SetSpeedY(-280);
        }
    }
}