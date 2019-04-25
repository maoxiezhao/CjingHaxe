package game.entity;

import hxd.Timer;
import helper.AnimationSprite;
import hxd.Key;
import hxd.res.Image;
import hxd.Res;
import helper.Animation.AnimationOption;
import game.animationStates.NormalEntity;
import game.GameCommand;
import game.component.Movement;

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

        var components = GetComponents();
        components.Add(new Movement("PlayerMove"));
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
                GetAnimationManger().RequestState("walking");
                movement.SetSpeed(60, 0);
            }
            else if (gameCommands.IsCommandPressed(GameCommand_Left)) 
            {
                GetAnimationManger().RequestState("walking");
                movement.SetSpeed(-60, 0);
            }
            else 
            {
                GetAnimationManger().RequestState("idle");
                movement.SetSpeed(0, 0);
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
}