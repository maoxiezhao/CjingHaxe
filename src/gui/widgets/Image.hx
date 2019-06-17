package gui.widgets;

import hxd.clipper.Rect;
import h2d.Bitmap;
import helper.Log;

import Std.int;

typedef ImageRectInfo = 
{
    tile:h2d.Tile,
    rect:Rect
}

class Image extends Frame
{
    private var mOriginTile:h2d.Tile;
    private var mSlicedImageInfoMap:Map<String, ImageRectInfo>;
    private var mTileGroup:h2d.TileGroup;
    private var mIsImageLoaded:Bool = false;
    private var mIsImageSliced:Bool = false;

    public function new()
    {
        super();

        mSlicedImageInfoMap = new Map();
    }

    public function LoadSlice9Image(src:String, srcWidth:Int, srcHeight:Int, slice9:Array<Int>)
    {
        if (mIsImageLoaded) 
        {
            return;
        }

        var srcTile = hxd.Res.loader.load(src + ".png").toImage().toTile();
        mTileGroup = new h2d.TileGroup(srcTile);
        if (slice9.length == 4) 
        {
            var scale_x = 1.0;
            var scale_y = 1.0;

            if (srcWidth > 0) {
                scale_x = srcTile.width / srcWidth;
            }

            if (srcHeight > 0) {
                scale_y = srcTile.height / srcHeight;
            }

            var srcWidth = Std.int(srcTile.width);
            var srcHeight = Std.int(srcTile.height);

            var x1:Int = Std.int(slice9[0] * scale_x);
            var y1:Int = Std.int(slice9[1] * scale_y);
            var x2:Int = Std.int(slice9[2] * scale_x);
            var y2:Int = Std.int(slice9[3] * scale_y);

            var rects = new Map<String, Rect>();
            rects.set("top.left", new Rect(0, 0, x1, y1));
            rects.set("top", new Rect(x1, 0, x2-x1, y1));
            rects.set("top.right", new Rect(x2, 0, srcWidth-x2, y1));
            rects.set("left", new Rect(0, y1, x1, y2-y1));
            rects.set("middle", new Rect(x1, y1, x2-x1, y2-y1));
            rects.set("right", new Rect(x2, y1, srcWidth-x2, y2-y1));
            rects.set("bottom.left", new Rect(0, y2, x1, srcHeight-y2));
            rects.set("bottom", new Rect(x1, y2, x2-x1, srcHeight-y2));
            rects.set("bottom.right", new Rect(x2, y2, srcWidth-x2, srcHeight-y2));

            for (i in 0...9)
            {
                var name = GetPosNameByIndex(i);
                var currentRect = rects.get(name);
            
                var newTile = srcTile.sub(currentRect.left, currentRect.top, currentRect.right, currentRect.bottom);
                mTileGroup.add(currentRect.left, currentRect.top, newTile);

                mSlicedImageInfoMap.set(name, {
                    tile: newTile, 
                    rect: currentRect
                });
            }

            mIsImageSliced = true;
        }
        else 
        {
            if (srcWidth > 0) {
                srcTile.width = srcWidth;
            }

            if (srcHeight > 0) {
                srcTile.height = srcHeight;
            }

            mTileGroup.add(0, 0, srcTile);
            mIsImageSliced = false;
        }

        mOriginTile = srcTile;
        mIsImageLoaded = true;

        this.addChild(mTileGroup);
    }

    public function Resize(newWidth:Float, newHeight:Float)
    {
        var oldWidth = mOriginTile.width;
        var oldHeight = mOriginTile.height;

        if (oldWidth == newWidth && oldHeight == newHeight) {
            return;
        }

        mTileGroup.clear();

        if (mIsImageSliced) 
        {
            // LEFT TOP, TOP, RIGHT TOP
            var tlInfo = mSlicedImageInfoMap.get("top.left");
            if (tlInfo != null)
            {
                mTileGroup.add(tlInfo.rect.left, tlInfo.rect.top, tlInfo.tile);
            }

            var trInfo = mSlicedImageInfoMap.get("top.right");
            if (trInfo != null)
            {
                trInfo.rect.left = Std.int(newWidth) - Std.int(trInfo.tile.width);
                mTileGroup.add(trInfo.rect.left, trInfo.rect.top, trInfo.tile);
            }

            var tInfo = mSlicedImageInfoMap.get("top");
            if (tInfo != null)
            {
                tInfo.tile.width = Math.max(0, Std.int(newWidth - tlInfo.tile.width - trInfo.tile.width));
                tInfo.rect.left = tlInfo.rect.right;
                tInfo.rect.right = tInfo.rect.left + Std.int(tInfo.tile.width);
                mTileGroup.add(tInfo.rect.left, tInfo.rect.top, tInfo.tile);
            }

            // LEFT BOTTOM, BOTTOM, RIGHT BOTTOM
            var blInfo = mSlicedImageInfoMap.get("bottom.left");
            if (blInfo != null)
            {
                blInfo.rect.top = Std.int(newHeight) - Std.int(blInfo.tile.height);
                mTileGroup.add(blInfo.rect.left, blInfo.rect.top, blInfo.tile);
            }

            var brInfo = mSlicedImageInfoMap.get("bottom.right");
            if (brInfo != null)
            {
                brInfo.rect.left = Std.int(newWidth) - Std.int(brInfo.tile.width);
                brInfo.rect.top = Std.int(newHeight) - Std.int(brInfo.tile.height);
                mTileGroup.add(brInfo.rect.left, brInfo.rect.top, brInfo.tile);
            }

            var bInfo = mSlicedImageInfoMap.get("bottom");
            if (bInfo != null)
            {
                bInfo.tile.width = Math.max(0, Std.int(newWidth - blInfo.tile.width - brInfo.tile.width));
                bInfo.rect.left = blInfo.rect.right;
                bInfo.rect.top = Std.int(newHeight - bInfo.tile.height);
                bInfo.rect.right = bInfo.rect.left + Std.int(bInfo.tile.width);
                mTileGroup.add(bInfo.rect.left, bInfo.rect.top, bInfo.tile);
            }

            // LEFT, MIDDLE, RIGHT
            var lInfo = mSlicedImageInfoMap.get("left");
            if (lInfo != null)
            {
                lInfo.tile.height = Math.max(0, Std.int(newHeight - tlInfo.tile.height - blInfo.tile.height));
                lInfo.rect.top = tlInfo.rect.bottom;
                mTileGroup.add(lInfo.rect.left, lInfo.rect.top, lInfo.tile);
            }

            var rInfo = mSlicedImageInfoMap.get("right");
            if (rInfo != null)
            {
                rInfo.tile.height = Math.max(0, Std.int(newHeight - trInfo.tile.height - brInfo.tile.height));
                rInfo.rect.top = trInfo.rect.bottom;
                rInfo.rect.left = Std.int(newWidth - rInfo.tile.width);
                mTileGroup.add(rInfo.rect.left, rInfo.rect.top, rInfo.tile);
            }

            var mInfo = mSlicedImageInfoMap.get("middle");
            if (mInfo != null)
            {
                mInfo.tile.width = Math.max(0, Std.int(newWidth - lInfo.tile.width - rInfo.tile.width));
                mInfo.tile.height = Math.max(0, Std.int(newHeight - tInfo.tile.height - bInfo.tile.height));
                mInfo.rect.left = lInfo.rect.right;
                mInfo.rect.right = tInfo.rect.bottom;
                mTileGroup.add(mInfo.rect.left, mInfo.rect.top, mInfo.tile);
            }
        }
        else 
        {
            mOriginTile.width = newWidth;
            mOriginTile.height = newHeight;
            mTileGroup.add(0, 0, mOriginTile);
        }
    }    

    private function GetPosNameByIndex(index:Int)
    {
        var name = "top.left";
        switch(index)
        {
            case 0: name = "top.left";
            case 1: name = "top";
            case 2: name = "top.right";
            case 3: name = "left";
            case 4: name = "middle";
            case 5: name = "right";
            case 6: name = "bottom.left";
            case 7: name = "bottom";
            case 8: name = "bottom.right";
            default: name = "top.left";
        }
        return name;
    }

    override public function SetSize(width:Int, height:Int)
    {
        Resize(width, height);
    }
}