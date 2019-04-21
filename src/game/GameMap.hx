package game;

import game.entity.Camera;
import game.entity.Entity;
import h2d.Bitmap;

// 地图类，地图类管理所有的Entity，同时负责关卡的加载与切换
// NOTE：目前Hero由Map管理，未来希望将Hero的管理交由Game
class GameMap 
{
    public var mCurrentGame:Game;
    public var mIsLoaded:Bool = false;
    public var mCamera:Camera;

    public var mEntities:Array<Entity>;
    public var mNameEntitiesMap:Map<String, Entity>;

    public var mMapName:String = "";
    public var mMapWidth:Int;
    public var mMapHeight:Int;

    public var mBackground:h2d.Bitmap = null;

    public static var mMaxLayers :Int = 3;

    // 目前提供3个层级
    public var mCurrentLayers:Array<h2d.Layers>;

    public function new(currentGame:Game)
    {
        mCurrentGame = currentGame;
        mEntities = [];
        mNameEntitiesMap = new Map();
        mCamera = new Camera();

        // layer 1..3 zpos  is 3 .. 1
        // backgound zpos is 0
        mCurrentLayers = new Array();
        for (index in 0...3)
        {
            var layer = new h2d.Layers();
            mCurrentLayers.push(layer);
            currentGame.mRootLayer.add(layer, mMaxLayers - index); 
        }
    }

    public function LoadMap(path:String)
    {
        if (mIsLoaded == true) {
            return;
        }

        var mapLoader = new MapLoader();
        mapLoader.LoadMap(path, this);

        mIsLoaded = true;
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
        if (index < 0 || index >= 3)
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
        if (mIsLoaded == false) {
            return;
        }

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

    public function SetCurrentBackground(background:h2d.Bitmap)
    {
        if (mBackground != background)
        {
            if (mBackground != null) {
                mBackground.remove();
            }

            mBackground = background;
            mCurrentGame.mRootLayer.add(mBackground, 0); 
        }
    }

    public function CheckCollision()
    {
        return true;     
    }
}
