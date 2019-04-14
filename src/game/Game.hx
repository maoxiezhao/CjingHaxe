package game;

import game.entity.Hero;

class Game
{
    public var mCurrentApp:App;
    public var mHero:Hero;
    public var mCurrentMap:GameMap;

    public function new(currentApp:App)
    {
        mCurrentApp = currentApp;
        mCurrentMap = new GameMap(this);
        mHero = new Hero();

        mCurrentMap.AddEntity(mHero);
    }

    public function Update(dt:Float)
    {
        mCurrentMap.Update(dt);
    }

    public function Dispose()
    {
        mCurrentMap.Dispose();
    }
}