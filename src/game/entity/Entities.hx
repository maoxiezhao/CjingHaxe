package game.entity;

import helper.Log;
import helper.System;
import helper.Grid;
import game.GameCommand;
import game.entity.MapTile;
import game.GameMap;
import game.component.BoundingBox;

// manage all entities
class Entities
{
    private var mAllEntities:List<Entity>;
    private var mEntitiesToRemoved:Array<Entity>;
    private var mEntitiesNameMap:Map<String, Entity>;
    private var mEntitiesGrid:Grid;

    private var mCurrentMap:GameMap;
    private var mCurrentLayers:Array<h2d.Layers>;

    private var mLayerGrounds:Array<Array<MapGround>>;
    private var mDebugObstacleEnable:Bool = false;
    private var mDebugDrawable:h2d.Graphics;

    private var mMapTileRowNumber:Int;
    private var mMapTileColNumber:Int;

    public var mCamera:Camera;

    public function new(map:GameMap)
    {
        mAllEntities = new List();
        mEntitiesToRemoved = new Array();
        mEntitiesNameMap = new Map();
        mCurrentLayers = new Array();
        mLayerGrounds = new Array();

        mEntitiesGrid = new Grid(
            map.mMapWidth, map.mMapHeight, 
            map.mGridCellWidth, map.mGridCellHeight
        );

        mCurrentMap = map;
        mMapTileRowNumber = map.mMapTileRowNumber;
        mMapTileColNumber = map.mMapTileColNumber;

        mCamera = new Camera();
        mCamera.SetDragmarginRect(new hxd.clipper.Rect(100, 0, 100, 0));
        mCamera.SetUpdateSmoothEnable(false);
        mCamera.SetCurrentMap(map);

        var scroller = mCurrentMap.GetScroller();
        for (index in 0... mCurrentMap.GetMaxLayer())
        {
            var layer = new h2d.Layers();
            mCurrentLayers.push(layer);

            var grounds:Array<MapGround> = new Array();
            mLayerGrounds.push(grounds);
            scroller.add(layer, index); 
        }

        mDebugDrawable = new h2d.Graphics();
        scroller.add(mDebugDrawable, 10);
    }

    public function Dispose()
    {
        for(layer in mCurrentLayers) {
            layer.removeChildren();
            layer.remove();
        }
        mCurrentLayers = null;
        mLayerGrounds = null;

        for(entity in mAllEntities) {
            entity.Dispose();
        }

        mEntitiesGrid.Clear();
        mEntitiesGrid = null;

        mAllEntities = null;
        mEntitiesToRemoved = null;
        mEntitiesNameMap = null;
    }

    public function Update(dt:Float)
    {
        for(entity in mAllEntities) {
            entity.Update(dt);
        }

        mCamera.Update(dt);

        for(entity in mEntitiesToRemoved)
        {
            mAllEntities.remove(entity);
            
            var name = entity.GetName();
            if (name != "") {
                mEntitiesNameMap.remove(name);
            } 

            var boundingBoxs = entity.GetComponents().GetComponentsByType(ComponentType_BoundingBox);
            if (boundingBoxs.length > 0)
            {
                var boundingBox:BoundingBox = cast(boundingBoxs[0], BoundingBox);
                mEntitiesGrid.Remove(entity, boundingBox.mBound);
            }
        }
        if (mDebugObstacleEnable)
        {
            mDebugDrawable.clear();
            mDebugDrawable.beginFill(0xFFFFFF);
            var grounds = mLayerGrounds[1];

            var index = 0;
            for (ground in grounds)
            {
                if (ground == GROUND_WALL)
                    mDebugDrawable.drawRect(
                        index % mCurrentMap.mMapTileColNumber * mCurrentMap.mCellGroundWidth, 
                        Math.floor(index / mCurrentMap.mMapTileColNumber) * mCurrentMap.mCellGroundHeight, 
                        mCurrentMap.mCellGroundWidth, mCurrentMap.mCellGroundHeight);

                index++;
            }
        }
    }

    public function AddEntity(entity:Entity)
    {
        var name = entity.GetName();
        var layerIndex = entity.GetLayer();
        var layer:h2d.Layers = GetLayerByIndex(layerIndex);
        if (layer == null)
        {
            Logger.Waring("The Adding Entity named" + name + 
                " has an invalid layer:" + layer);
            return;
        }
        layer.add(entity.mBaseObject, 1);

        if (name != "")
        {
            if (mEntitiesNameMap.exists(name)) {
                // TODO:instead of log
                Logger.Waring("The Adding Entity named" + name + 
                    " has already exists and replace older.");
            }
            mEntitiesNameMap.set(name, entity);
        }
        mAllEntities.push(entity);

        // tracing hero
        if (entity.GetEntityType() == EntityType_Hero) 
        {
            mCamera.TraceTarget(entity);
        }

        if (entity.GetEntityType() != EntityType_Camera)
        {
            var boundingBoxs = entity.GetComponents().GetComponentsByType(ComponentType_BoundingBox);
            if (boundingBoxs.length > 0)
            {
                var boundingBox:BoundingBox = cast(boundingBoxs[0], BoundingBox);
                mEntitiesGrid.Add(entity, boundingBox.mBound);
            }
        }

        entity.SetLayer(layerIndex);
        entity.SetCurrentMap(mCurrentMap);
    }

    public function RemoveEntity(entity:Entity)
    {
        if (entity.GetIsBeRemoved() == false)
        {
            mEntitiesToRemoved.push(entity);
            entity.SetIsBeRemoved();
        }
    }

    public function GetLayerByIndex(index:Int)
    {
        if (index < 0 || index >= 3)
        {
            Logger.Error("Invalid index");
            return null;
        }
        return mCurrentLayers[index];
    }

    public function GetGround(layer:Int, cellX:Int, cellY:Int):MapGround
    {
        var grounds = mLayerGrounds[layer];
        var index = cellY * mMapTileColNumber + cellX;
        return grounds[index];
    }

    public function GetGroundByLayer(layer:Int) { return mLayerGrounds[layer];}

    public function NotifyGameCommand(commandEvent:GameCommandEvent)
    {
        for(entity in mAllEntities) {
            entity.NotifyGameCommand(commandEvent);
        }
    }
}