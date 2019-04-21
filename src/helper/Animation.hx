package helper;

import h2d.Tile;
import hxd.res.Image;

// 方向定义为上、右、下、左
enum Directions
{
    Directoin_Right;
    Direction_Left;
    Direction_Down;
    Direction_Up;
}

typedef AnimationDirection = {
    x:Int, 
    y:Int,
    width:Int,
    height:Int,
    numFrames:Int
}

typedef AnimationOption = {
    name:String,
    srcImg:Image,
    speed:Int,
    loop:Bool,
    directions:Array<AnimationDirection>
}

typedef TileArray = {
    mTiles:Array<Tile>
}

class Animation
{
    public var mAnimPlayer:h2d.Anim;
    public var mAllFrames:Map<Directions, TileArray>;
    public var mIsPlaying:Bool = false;

    public var mName:String;
    public var mSpeed:Int;
    public var mIsLoop:Bool;

    public function new(option:AnimationOption) {
        mAnimPlayer = new h2d.Anim([]);
        mAllFrames = new Map();

        LoadAnimations(option);
    }

    public function Dispose()
    {
        mAnimPlayer.remove();
        mAnimPlayer = null;
        mAllFrames = null;
    }

    public function LoadAnimations(option:AnimationOption)
    {
        mSpeed = option.speed;
        mIsLoop = option.loop;
        mName = option.name;

        var srcTile = option.srcImg.toTile();
        var directions = option.directions;
        var index = 0;
        for (directionData in directions)
        {
            var direction = Directions.createByIndex(index);
            var tileArray:TileArray = {mTiles: new Array()};

            for (i in 0...directionData.numFrames)
            {
                var tile = srcTile.sub(
                    directionData.x + i * directionData.width,
                    directionData.y,
                    directionData.width,
                    directionData.height
                );

                tileArray.mTiles.push(tile);
            }

            mAllFrames.set(direction, tileArray);
            index++;
        }
    }

    public function Play(dir:Directions, ?endCallBack:Void -> Void)
    {
        var tileArray = mAllFrames.get(dir);
        if (tileArray == null)
        {
            mIsPlaying = false;
            mAnimPlayer.pause = true;
            mAnimPlayer.removeChildren();

            return;
        }

        mAnimPlayer.play(tileArray.mTiles);
        mAnimPlayer.loop = mIsLoop;
        mAnimPlayer.speed = mSpeed;

        mAnimPlayer.onAnimEnd = function(){};
        if (endCallBack != null) {
            mAnimPlayer.onAnimEnd = endCallBack;
        }

        mIsPlaying = true;
    }

    public function Update(dt:Float)
    {
        mIsPlaying = mAnimPlayer.pause;
    }

    public function Stop()
    {
        mAnimPlayer.pause = true;
        mIsPlaying = false;
    }

    public function SetVisible(isVisible)
    {
        mAnimPlayer.visible = isVisible;
    }
}