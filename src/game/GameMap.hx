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

    // 目前提供3个层级
    public var mCurrentLayers:Array<h2d.Layers>;

    public function new(currentGame:Game)
    {
        mCurrentGame = currentGame;
        mEntities = [];
        mNameEntitiesMap = new Map();
        mCamera = new Camera();
        mMapLoader = new MapLoader();

        // init layer
        mCurrentLayers = new Array();
        for (index in 1...3)
        {
            var layer = new h2d.Layers();
            mCurrentLayers.push(layer);
            currentGame.mRootLayer.add(layer, index);
        }
    }

    public function AddEntity(entity:Entity, layerIndex:Int = 1)
    {
        var name = entity.GetName();
        var layer:h2d.Layers = GetLayerByIndex(layerIndex);
        if (layer == null)
        {
            trace("The Adding Entity named" + name + 
                " has an invalid layer:" + layer);
            return;
        }
        layer.add(entity.mBaseObject, 1);

        if (name != "")
        {
            if (mNameEntitiesMap.exists(name)) {
                // TODO:instead of log
                trace("The Adding Entity named" + name + 
                    " has already exists and replace older.");
            }
            mNameEntitiesMap.set(name, entity);
        }
        mEntities.push(entity);

        entity.SetLayer(layerIndex);
        entity.SetCurrentMap(this);
    }

    public function GetLayerByIndex(index:Int)
    {
        if (index <= 0 || index > 3)
        {
            trace("Invalid index");
            return null;
        }
        return mCurrentLayers[index];
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
        
        for(layer in mCurrentLayers) {
            layer.removeChildren();
        }
        mCurrentLayers = null;

        mCurrentGame = null;
        mCamera = null;   

    }
}
