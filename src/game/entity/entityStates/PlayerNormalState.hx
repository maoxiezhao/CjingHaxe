package game.entity.entityStates;

import game.GameCommand;
import game.component.Movement;

class PlayerMovingState extends EntityState
{
    public function new(entity:Entity, name:String){super(entity, name);}

    override public function Update(dt:Float)
    {
        var player = GetEntity();
        var movement:Movement = cast(player.GetComponents().GetComponent("PlayerMove"), Movement);
        var gameCommands = player.GetGameCommmands();
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

    override public function NotifyGameCommand(commandEvent:GameCommandEvent) 
    {
        var player = GetEntity();
        var dir = player.GetDirection();
        if (commandEvent.command == GameCommand_Right && commandEvent.isPressed)
        {
            dir = Directoin_Right;
        }
        else if(commandEvent.command == GameCommand_Left && commandEvent.isPressed)
        {
            dir = Direction_Left;
        }
        player.SetDirection(dir);
    }
}

class PlayerWalkingState extends PlayerMovingState
{
    public function new(entity:Entity, name:String){super(entity, name);}
    override public function NotifyGameCommand(commandEvent:GameCommandEvent) 
    {
        super.NotifyGameCommand(commandEvent);

        if (commandEvent.command == GameCommand_Jump && commandEvent.isPressed)
        {
            var movement:Movement = cast(GetEntity().GetComponents().GetComponent("PlayerMove"), Movement);
            if (movement.IsOnFloor()) {
                GetEntity().SetState(new PlayerJumpingState(GetEntity(), "Jumping"));
            }
        }
    }
}

class PlayerJumpingState extends PlayerMovingState
{
    public function new(entity:Entity, name:String){super(entity, name);}
    override public function Start(prevState:EntityState)
    {
        TryStartingJumping();
    }

    override public function NotifyGameCommand(commandEvent:GameCommandEvent) 
    {
        super.NotifyGameCommand(commandEvent);
        if(commandEvent.command == GameCommand_Jump && !commandEvent.isPressed)
        {
            TryStoppingJumping();
        }
    }

    override public function Update(dt:Float)
    {
        super.Update(dt);

        var movement:Movement = cast(GetEntity().GetComponents().GetComponent("PlayerMove"), Movement);
        if (movement.IsOnFloor()) {
            // can use pushdown automata ???
            GetEntity().SetState(new PlayerWalkingState(GetEntity(), "Walking"));
        }
    }

    private function TryStartingJumping()
    {
        var movement:Movement = cast(GetEntity().GetComponents().GetComponent("PlayerMove"), Movement);
        if (movement.IsOnFloor()) {
            movement.SetSpeedY(-400);
        }
    }

    private function TryStoppingJumping()
    {
        // 临时实现一个跳跃按键缓冲
        var movement:Movement = cast(GetEntity().GetComponents().GetComponent("PlayerMove"), Movement);
        if (!movement.IsOnFloor()) {
            if (movement.GetSpeedY() < -200) {
                movement.SetSpeedY(-200);
            }
        }
    }
}