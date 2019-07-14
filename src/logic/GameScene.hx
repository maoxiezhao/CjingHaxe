package logic;

import game.Game;
import logic.LogicScene;

class GameScene extends LogicScene
{
    public static var mMainGame:Game;

    public function new(manager:LogicSceneManager)
    {
        super(manager);

        mMainGame = new Game(manager.GetApp());
    }

    override public function OnEnter() 
    {
        mMainGame.Initialize();
    }

    override public function OnLeave() 
    {
        mMainGame.Dispose();
    }

    override public function Update(dt:Float) 
    {
        mMainGame.Update(dt);
    }
}