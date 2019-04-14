package game;

import game.entity.Camera;
import game.entity.Entity;

// 地图类，地图类管理所有的Entity，同时负责关卡的加载与切换
// NOTE：目前Hero由Map管理，未来希望将Hero的管理交由Game
class GameMap 
{
    public var mCurrentGame:Game;
    public var mCamera:Camera;
    public var mEntities:Array<Entity>;
    public var mNameEntitiesMap:Map<String, Entity>;
    public var mMapLoader:MapLoader;

    public function new(currentGame:Game)
    {
        mCurrentGame = currentGame;
        mEntities = [];
        mNameEntitiesMap = new Map();
        mCamera = new Camera();
        mMapLoader = new MapLoader();
    }

    public function AddEntity(entity:Entity)
    {
        var name = entity.GetName();
        if (name != "")
        {
            if (mNameEntitiesMap.exists(name)) {
                // TODO:instead of log
                trace("The Adding Entity named" + name + 
                    " has already exists and replace older.");
            }
            mNameEntitiesMap.set(name, entity);
        }
        
        entity.SetCurrentMap(this);
    }

    public function RemoveEntity(entity:Entity)
    {
        mEntities.remove(entity);

        var name = entity.GetName();
        if (name != "")  {
            mNameEntitiesMap.remove(name);
        }
    }

    public function Update(dt:Float)
    {
        for(entity in mEntities) {
            entity.Update(dt);
        }
    }

    public function Dispose()
    {
        for(entity in mEntities) {
            entity.Dispose();
        }
        mEntities = null;
        mCurrentGame = null;
        mCamera = null;   
    }
}
