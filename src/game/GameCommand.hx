package game;

import hxd.Key;
import game.Game;

enum GameCommand
{
    GameCommand_Right;
    GameCommand_Left;
    GameCommand_Down;
    GameCommand_Up;
    GameCommand_Jump;
}

typedef GameCommandEvent = 
{
    command:GameCommand,
    isPressed:Bool
} 

// TODO:
// 1.process mult keys case
// 2.support save key mapping.
class GameCommandManager
{
    private var mCurrentGame:Game;
    private var mInputGameCommandMapping:Map<Int, GameCommand>;
    private var mPressedGameCommands:Array<GameCommand>;

    public function new(currentGame:Game)
    {
        mCurrentGame = currentGame;
        mInputGameCommandMapping = new Map();
        mPressedGameCommands = new Array();
    }

    public function BindGameCommand(key:Int, command:GameCommand)
    {
        mInputGameCommandMapping.set(key, command);
    }

    public function CheckInput()
    {
        for (key => command in mInputGameCommandMapping)
        {
            if (Key.isPressed(key))
            {
                mPressedGameCommands.push(command);
                var commandEvent:GameCommandEvent = {
                    command:command,
                    isPressed: true    
                };
                mCurrentGame.NotifyGameCommand(commandEvent);
            }
            else if(Key.isReleased(key))
            {
                mPressedGameCommands.remove(command);
                var commandEvent:GameCommandEvent = {
                    command:command,
                    isPressed: false    
                };
                mCurrentGame.NotifyGameCommand(commandEvent);
            }
        }
    }

    public function BindDefaultCommand()
    {
        BindGameCommand(Key.LEFT, GameCommand_Left);
        BindGameCommand(Key.RIGHT, GameCommand_Right);
        BindGameCommand(Key.UP, GameCommand_Up);
        BindGameCommand(Key.DOWN, GameCommand_Down);
        BindGameCommand(Key.SPACE, GameCommand_Jump);
    }
}