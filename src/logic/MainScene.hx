package logic;

import game.Game;
import logic.LogicScene;
import logic.GameScene;

class MainScene extends LogicScene
{
    public function new(manager:LogicSceneManager)
    {
        super(manager);
    }

    override public function OnEnter() 
    {
        GetSceneManager().RequsetScene(new GameScene(mSceneManager));
    }

    override public function OnLeave() 
    {

    }
}