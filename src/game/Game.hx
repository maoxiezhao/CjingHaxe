package game;

import game.entity.Hero;
import game.GameCommand;
import h2d.Layers;
import h2d.Mask;
import hxd.Key;
import helper.Log;

class Game
{
    public var mCurrentApp:App;
    public var mHero:Hero;
    public var mCurrentMap:GameMap = null;
    public var mNextMap:GameMap = null;
    public var mRootLayer:h2d.Layers;
    public var mGameCommandManager:GameCommandManager;

    public function new(currentApp:App)
    {
        mCurrentApp = currentApp;
     
        mRootLayer = new h2d.Layers(mCurrentApp.s2d);   
        mCurrentMap = new GameMap(this);

        mHero = new Hero();

        mGameCommandManager = new GameCommandManager(this);
        mGameCommandManager.BindDefaultCommand();

        Logger.Info("The Game Staring.");
        mCurrentMap.LoadMap("tutorial");
        mCurrentMap.GetEntities().AddEntity(mHero);
    }

    public function Update(dt:Float)
    {
        mGameCommandManager.CheckInput();

        if (mCurrentMap != null) {
            mCurrentMap.Update(dt);
        }

    #if debug
        if (Key.isReleased(Key.ESCAPE)) {
            mCurrentApp.Close();
        }
    #end
    }

    public function Dispose()
    {
        if (mCurrentMap != null) {
            mCurrentMap.Dispose();
        }
    }

    public function NotifyGameCommand(commandEvent:GameCommandEvent)
    {
        if (mCurrentMap != null) {
            mCurrentMap.NotifyGameCommand(commandEvent);
        }
    }
}