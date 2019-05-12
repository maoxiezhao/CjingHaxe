package game;

import game.GameCommand;
import game.entity.Camera;
import game.entity.Entity;
import game.entity.Entities;
import game.entity.MapTile;

import helper.Log;

import h2d.Bitmap;
import h2d.col.Point;
import Std;

// 地图类，地图类管理所有的Entity，同时负责关卡的加载与切换
// TODO：
// 0.public -> private
// 1.目前Hero由Map管理，未来希望将Hero的管理交由Game
// 2.entities class
class GameMap 
{
    public var mCurrentGame:Game;
    public var mIsLoaded:Bool = false;
    public var mMapName:String = "";
    public var mMapWidth:Int;
    public var mMapHeight:Int;
    public var mMapTileRowNumber:Int;
    public var mMapTileColNumber:Int;
    public var mMaxLayers :Int = 3;
    public var mCellGroundWidth:Int = 32;
    public var mCellGroundHeight:Int = 32;

    private var mScroller:h2d.Layers;
    private var mBackground:h2d.Bitmap = null;
    private var mEntities:Entities;

    public function new(currentGame:Game)
    {
        mCurrentGame = currentGame;

        mScroller = new h2d.Layers();
        currentGame.mRootLayer.add(mScroller, 9);
    }

    public function Dispose()
    {
        mEntities.Dispose();
        
        mScroller.removeChildren();
        mScroller.remove();

        mCurrentGame = null;
    }

    public function LoadMap(path:String)
    {
        if (mIsLoaded == true) {
            return;
        }

        var mapLoader = new MapLoader();
        mapLoader.LoadMap(path, this);
        mEntities = new Entities(this);

        // TODO: 为了保证处理Grounds时，entities已经存在，故将处理延后
        mapLoader.ProcessMapGrounds(this);

        mIsLoaded = true;
    }

    public function Update(dt:Float)
    {
        if (mIsLoaded == false) {
            return;
        }

        mEntities.Update(dt);
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

    public function NotifyGameCommand(commandEvent:GameCommandEvent)
    {
        mEntities.NotifyGameCommand(commandEvent);
    }

    public function GetScroller() { return mScroller;}
    public function GetMaxLayer() { return mMaxLayers;}
    public function GetEntities() { return mEntities; }

    //**********************************************************************/
    // Check Collision
    //**********************************************************************/

    // 先强行检测四个点（四个角），在xy方向上各一次
    // TODO: 实现一个碰撞检测类，能够生成碰撞点和检测规则，以满足不同情况
    public function CheckCollision(bound:h2d.col.Bounds, offset:Point, entity:Entity)
    {
        var xBegin = Std.int(bound.x);
        var xEnd   = Std.int(xBegin + bound.width);
        var yBegin = Std.int(bound.y);
        var yEnd   = Std.int(yBegin + bound.height);

        var layer = entity.GetLayer();
        if (CheckCollisionWithGround(layer, xBegin, yBegin) ||
            CheckCollisionWithGround(layer, xBegin, yEnd) ||
            CheckCollisionWithGround(layer, xEnd,   yBegin) ||
            CheckCollisionWithGround(layer, xEnd,   yEnd)){
            return true;
        }

        return false;     
    }

    // 与简单的ground检查碰撞，基于32x32的网格
    public function CheckCollisionWithGround(layer:Int, x:Int, y:Int)
    {    
        var ground = mEntities.GetGround(layer, Math.floor(x / mCellGroundWidth), Math.floor(y / mCellGroundHeight));
        var cantMove = false;
        switch (ground) {
            case GROUND_EMPTY:
                cantMove = false;
            case GROUND_WALL:
                cantMove = true;
        }
        return cantMove;
    }
}
